import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:injectable/injectable.dart' show Environment;
import 'package:push_by_token_tester/core/app.dart';
import 'package:push_by_token_tester/core/di/injection.dart';
import 'package:push_by_token_tester/push_workbench/push_message.dart';
import 'package:push_by_token_tester/push_workbench/push_transport.dart';
import 'package:push_by_token_tester/push_workbench/push_workbench_page.dart';

// Ephemeral synthetic values: no real credentials or captured requests in fixtures.
String secret() => List.generate(
  32,
  (_) => Random.secure().nextInt(16).toRadixString(16),
).join();
final now = DateTime.utc(2026, 1, 1);

PushMessage message({
  Map<String, String>? data,
  bool dataOnly = true,
  int ttl = 3600,
  String? expiryKey,
  String? token,
  String title = 'Test',
}) => PushMessage(
  deviceToken: token ?? secret(),
  dataOnly: dataOnly,
  title: title,
  body: 'Test body',
  data: data ?? {'example': 'value'},
  ttlSeconds: ttl,
  expiryKey: expiryKey,
);

void main() {
  group('payload validation', () {
    test(
      'data-only omits both notification objects; normal mode retains title/body',
      () {
        final payload = message().payload(now)['message'] as Map;
        expect(payload.containsKey('notification'), false);
        expect((payload['android'] as Map).containsKey('notification'), false);
        expect(payload['android'], {'ttl': '3600s'});
        expect(
          message(dataOnly: false).payload(now)['message']['notification'],
          {'title': 'Test', 'body': 'Test body'},
        );
      },
    );
    for (final invalid in [
      '[]',
      'null',
      '{',
      '{"count":1}',
      '{"x":null}',
      '{"x":{}}',
      '{"from":"x"}',
      '{"google.test":"x"}',
      '{"":"x"}',
    ]) {
      test('rejects invalid or reserved data: $invalid', () {
        expect(
          () => parsePushData(invalid),
          throwsA(isA<PushValidationException>()),
        );
      });
    }
    test(
      'arbitrary application fields are passed through without domain rules',
      () {
        final data = {'custom_kind': 'ping', 'any_key': 'any value'};
        expect(message(data: data).payload(now)['message']['data'], data);
      },
    );
    test(
      'validates empty message, TTL, project path, bearer and single recipient',
      () {
        for (final value in [
          message(data: {}),
          message(ttl: 0),
          message(ttl: 2419201),
          message(token: 'one two'),
          message(token: 'one,two'),
          message(token: ''),
          message(token: 'a' * 2049),
          message(dataOnly: false, title: ''),
        ]) {
          expect(
            () => value.payload(now),
            throwsA(isA<PushValidationException>()),
          );
        }
        expect(
          () => RuStoreConfiguration('../elsewhere', secret()).validate(),
          throwsA(isA<PushValidationException>()),
        );
        expect(
          () => const RuStoreConfiguration('project', 'line\nbreak').validate(),
          throwsA(isA<PushValidationException>()),
        );
      },
    );
    test('enforces UTF-8 request limit including token and envelope', () {
      expect(
        () => message(data: {'text': '🌱' * 1024}).payload(now),
        throwsA(isA<PushValidationException>()),
      );
      expect(
        () =>
            message(data: {'text': 'x' * 2000}, token: 'x' * 2048).payload(now),
        throwsA(isA<PushValidationException>()),
      );
    });
    test('expiry is opt-in and caps TTL conservatively on every attempt', () {
      final expires = '${now.millisecondsSinceEpoch ~/ 1000 + 100}';
      final value = message(data: {'deadline': expires}, expiryKey: 'deadline');
      expect(value.payload(now)['message']['android'], {'ttl': '100s'});
      expect(
        value.payload(
          now.add(const Duration(milliseconds: 10500)),
        )['message']['android'],
        {'ttl': '89s'},
      );
      expect(
        () => value.payload(now.add(const Duration(milliseconds: 99500))),
        throwsA(isA<PushValidationException>()),
      );
      expect(
        message(data: {'expires_at': 'not our schema'}).payload(now),
        isNotEmpty,
      );
    });
    test('invalid expiry is rejected without leaking input', () {
      for (final value in [
        'bad',
        '0',
        '9223372036854775807',
        '${now.millisecondsSinceEpoch ~/ 1000}',
        '${now.millisecondsSinceEpoch ~/ 1000 + 2419201}',
      ]) {
        expect(
          () => message(
            data: {'expiry': value},
            expiryKey: 'expiry',
          ).payload(now),
          throwsA(isA<PushValidationException>()),
        );
      }
    });
    test(
      'UUID generation is v4, distinct and does not encode device identity',
      () {
        final first = newMessageId();
        expect(
          first,
          matches(
            RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
            ),
          ),
        );
        expect(newMessageId(), isNot(first));
      },
    );
  });

  group('HTTP transport', () {
    test(
      'RuStore uses fixed HTTPS, bearer, one recipient and no Google OAuth',
      () async {
        final bearer = secret();
        final recipient = secret();
        var calls = 0;
        final transport = HttpPushTransport(
          now: () => now,
          clientFactory: () => MockClient((request) async {
            calls++;
            expect(
              request.url.toString(),
              'https://vkpns.rustore.ru/v1/projects/example-project/messages:send',
            );
            expect(request.method, 'POST');
            expect(request.followRedirects, false);
            expect(request.headers['Authorization'] == 'Bearer $bearer', true);
            expect(
              request.headers['Content-Type'],
              startsWith('application/json'),
            );
            final payload = jsonDecode(request.body)['message'] as Map;
            expect(payload['token'] == recipient, true);
            expect(payload.keys.toSet(), {'token', 'data', 'android'});
            expect(payload['android'], {'ttl': '3600s'});
            return http.Response('{}', 200);
          }),
          accessTokenProvider: (_, __) =>
              throw StateError('Must not use OAuth'),
        );
        final result = await transport.send(
          RuStoreConfiguration('example-project', bearer),
          message(token: recipient),
        );
        expect(result.outcome, PushOutcome.accepted);
        expect(calls, 1);
        expect(result.description, contains('не подтверждены'));
      },
    );

    test(
      'FCM uses Google access token, supports normal and data-only payloads',
      () async {
        final accessToken = secret();
        var authorizations = 0;
        final configuration = FcmConfiguration(
          'example-project',
          jsonEncode({
            'type': 'service_account',
            'project_id': 'example-project',
            'client_email': 'example@example.invalid',
            'client_id': 'example-client',
            'private_key': secret(),
          }),
        );
        for (final dataOnly in [false, true]) {
          final transport = HttpPushTransport(
            now: () => now,
            accessTokenProvider: (_, __) async {
              authorizations++;
              return accessToken;
            },
            clientFactory: () => MockClient((request) async {
              expect(request.url.host, 'fcm.googleapis.com');
              expect(
                request.headers['Authorization'] == 'Bearer $accessToken',
                true,
              );
              expect(
                (jsonDecode(request.body)['message'] as Map).containsKey(
                  'notification',
                ),
                !dataOnly,
              );
              return http.Response(
                '{"name":"projects/example/messages/test"}',
                200,
              );
            }),
          );
          expect(
            (await transport.send(
              configuration,
              message(dataOnly: dataOnly),
            )).outcome,
            PushOutcome.accepted,
          );
        }
        expect(authorizations, 2);
      },
    );

    for (final code in [400, 401, 403, 404, 429, 500, 503, 302]) {
      test('HTTP $code is sanitized and never retried', () async {
        final bearer = secret();
        var calls = 0;
        final transport = HttpPushTransport(
          now: () => now,
          clientFactory: () => MockClient((_) async {
            calls++;
            return http.Response(
              jsonEncode({
                'error': {'message': bearer},
              }),
              code,
            );
          }),
        );
        final result = await transport.send(
          RuStoreConfiguration('project', bearer),
          message(),
        );
        expect(
          result.outcome,
          code >= 500 || code == 302
              ? PushOutcome.unknown
              : PushOutcome.rejected,
        );
        expect(result.description.contains(bearer), false);
        expect(calls, 1);
      });
    }
    for (final body in ['not JSON', '[]', 'null', '{"error":{}}']) {
      test('invalid successful response is unknown: $body', () async {
        final transport = HttpPushTransport(
          now: () => now,
          clientFactory: () =>
              MockClient((_) async => http.Response(body, 200)),
        );
        expect(
          (await transport.send(
            RuStoreConfiguration('project', secret()),
            message(),
          )).outcome,
          PushOutcome.unknown,
        );
      });
    }
    test(
      'timeout and exception are unknown without retry or secret output',
      () async {
        final bearer = secret();
        for (final timedOut in [true, false]) {
          var calls = 0;
          final transport = HttpPushTransport(
            now: () => now,
            timeout: const Duration(milliseconds: 1),
            clientFactory: () => MockClient((_) async {
              calls++;
              if (timedOut) {
                await Future<void>.delayed(const Duration(milliseconds: 10));
              }
              throw Exception(bearer);
            }),
          );
          final result = await transport.send(
            RuStoreConfiguration('project', bearer),
            message(),
          );
          expect(result.outcome, PushOutcome.unknown);
          expect(result.description.contains(bearer), false);
          await Future<void>.delayed(const Duration(milliseconds: 15));
          expect(calls, 1);
        }
      },
    );
    test(
      'validation prevents network access and diagnostics redact secrets',
      () async {
        final bearer = secret();
        final transport = HttpPushTransport(
          now: () => now,
          clientFactory: () => throw StateError('Should not create client'),
        );
        final result = await transport.send(
          RuStoreConfiguration('project', bearer),
          message(data: {}),
        );
        expect(result.outcome, PushOutcome.notSent);
        expect(result.description.contains(bearer), false);
        expect(
          RuStoreConfiguration('project', bearer).toString().contains(bearer),
          false,
        );
      },
    );

    test(
      'authorization timeout cannot send later, and closes the client',
      () async {
        final lateToken = Completer<String>();
        final client = _TrackingClient();
        final transport = HttpPushTransport(
          now: () => now,
          timeout: const Duration(milliseconds: 1),
          clientFactory: () => client,
          accessTokenProvider: (_, __) => lateToken.future,
        );
        final result = await transport.send(_fcmConfiguration(), message());
        expect(result.outcome, PushOutcome.notSent);
        expect(client.closed, true);
        lateToken.complete(secret());
        await Future<void>.delayed(const Duration(milliseconds: 5));
        expect(client.calls, 0);
      },
    );

    test('expiry is rechecked after OAuth and prevents a stale push', () async {
      var clock = now;
      final client = _TrackingClient();
      final transport = HttpPushTransport(
        now: () => clock,
        clientFactory: () => client,
        accessTokenProvider: (_, __) async {
          clock = now.add(const Duration(seconds: 10));
          return secret();
        },
      );
      final result = await transport.send(
        _fcmConfiguration(),
        message(
          data: {'expiry': '${now.millisecondsSinceEpoch ~/ 1000 + 5}'},
          expiryKey: 'expiry',
        ),
      );
      expect(result.outcome, PushOutcome.notSent);
      expect(client.calls, 0);
      expect(client.closed, true);
    });

    test(
      'invalid service-account JSON is rejected without reflecting it',
      () async {
        final value = secret();
        for (final input in [
          value,
          '[]',
          jsonEncode({
            'type': 'service_account',
            'project_id': 'project',
            'client_id': 'example',
            'client_email': 'example@example.invalid',
            'private_key': value,
            'token_uri': 'https://example.invalid/token',
          }),
        ]) {
          final transport = HttpPushTransport(
            clientFactory: () => throw StateError('No network'),
          );
          final result = await transport.send(
            FcmConfiguration('project', input),
            message(),
          );
          expect(result.outcome, PushOutcome.notSent);
          expect(result.description.contains(value), false);
        }
      },
    );
  });

  group('workbench widgets', () {
    Future<void> open(WidgetTester tester, PushTransport transport) async {
      tester.view.physicalSize = const Size(1200, 1800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      await tester.pumpWidget(
        MaterialApp(home: PushWorkbenchPage(transport: transport)),
      );
    }

    Future<void> tap(WidgetTester tester, String key) async {
      final finder = find.byKey(ValueKey(key));
      await tester.ensureVisible(finder);
      await tester.tap(finder);
      await tester.pumpAndSettle();
    }

    Future<void> fill(WidgetTester tester) async {
      await tester.enterText(
        find.byKey(const ValueKey('project')),
        'example-project',
      );
      await tester.enterText(
        find.byKey(const ValueKey('credential')),
        secret(),
      );
      await tester.enterText(find.byKey(const ValueKey('device')), secret());
      await tester.enterText(
        find.byKey(const ValueKey('data')),
        '{"custom":"value"}',
      );
    }

    testWidgets(
      'original app opens demo workbench; leaving discards credentials',
      (tester) async {
        tester.view.physicalSize = const Size(1200, 1800);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);
        configureDependencies(Environment.test);
        addTearDown(getIt.reset);
        await tester.pumpWidget(const App(dryRun: true));
        expect(find.byKey(const ValueKey('google_auth_page')), findsOneWidget);
        await tap(tester, 'open_workbench');
        await fill(tester);
        await tap(tester, 'send');
        expect(
          find.text('Демонстрация: сетевой запрос не выполнялся.'),
          findsOneWidget,
        );
        await tester.pageBack();
        await tester.pumpAndSettle();
        await tap(tester, 'open_workbench');
        for (final key in ['credential', 'device', 'project']) {
          expect(
            tester
                .widget<TextField>(find.byKey(ValueKey(key)))
                .controller!
                .text
                .isEmpty,
            true,
          );
        }
      },
    );

    testWidgets(
      'masked credentials, provider selection and full memory reset',
      (tester) async {
        await open(tester, _RecordingTransport());
        await fill(tester);
        for (final key in ['credential', 'device']) {
          final field = tester.widget<TextField>(find.byKey(ValueKey(key)));
          expect(field.obscureText, true);
          expect(field.enableSuggestions, false);
          expect(field.enableIMEPersonalizedLearning, false);
        }
        await tap(tester, 'provider');
        await tester.tap(find.text('FCM').last);
        await tester.pumpAndSettle();
        expect(find.text('Google service-account JSON'), findsOneWidget);
        for (final key in ['credential', 'device', 'project']) {
          expect(
            tester
                .widget<TextField>(find.byKey(ValueKey(key)))
                .controller!
                .text
                .isEmpty,
            true,
          );
        }
        await tester.enterText(
          find.byKey(const ValueKey('credential')),
          secret(),
        );
        await tap(tester, 'clear');
        final field = tester.widget<TextField>(
          find.byKey(const ValueKey('credential')),
        );
        expect(field.controller!.text.isEmpty, true);
        expect(field.undoController!.value.canUndo, false);
      },
    );
    testWidgets(
      'unknown result preserves ID and expiry; new test rotates only explicitly',
      (tester) async {
        final transport = _RecordingTransport();
        await open(tester, transport);
        await fill(tester);
        await tap(tester, 'use_id');
        await tester.enterText(
          find.byKey(const ValueKey('id_key')),
          'custom_id',
        );
        await tap(tester, 'use_expiry');
        await tap(tester, 'send');
        expect(transport.messages.length, 1);
        final first = transport.messages.first;
        expect(first.data['custom_id'], isNotEmpty);
        expect(first.data['expires_at'], isNotEmpty);
        expect(
          tester.widget<TextField>(find.byKey(const ValueKey('data'))).enabled,
          false,
        );
        await tap(tester, 'send');
        expect(transport.messages.length, 2);
        expect(transport.messages.last.data, first.data);
        await tap(tester, 'new_test');
        expect(transport.messages.length, 2);
        await tap(tester, 'send');
        expect(
          transport.messages.last.data['custom_id'],
          isNot(first.data['custom_id']),
        );
        expect(transport.messages.last.data['custom'], 'value');
        await tap(tester, 'clear');
        expect(
          tester
              .widget<TextField>(find.byKey(const ValueKey('data')))
              .controller!
              .text,
          '{}',
        );
      },
    );
    testWidgets('in-flight request disables duplicate submission and edits', (
      tester,
    ) async {
      final completer = Completer<PushResult>();
      final transport = _RecordingTransport(pending: completer.future);
      await open(tester, transport);
      await fill(tester);
      await tap(tester, 'send');
      expect(
        tester
            .widget<FilledButton>(find.byKey(const ValueKey('send')))
            .onPressed,
        isNull,
      );
      expect(
        tester
            .widget<OutlinedButton>(find.byKey(const ValueKey('new_test')))
            .onPressed,
        isNull,
      );
      expect(transport.messages.length, 1);
      completer.complete(
        const PushResult(PushOutcome.accepted, 'API accepted'),
      );
      await tester.pumpAndSettle();
      expect(transport.messages.length, 1);
    });
  });
}

class _RecordingTransport implements PushTransport {
  final messages = <PushMessage>[];
  final Future<PushResult>? pending;
  _RecordingTransport({this.pending});
  @override
  Future<PushResult> send(
    PushConfiguration configuration,
    PushMessage message,
  ) async {
    messages.add(message);
    return pending ??
        const PushResult(PushOutcome.unknown, 'Unknown; repeat manually.');
  }
}

FcmConfiguration _fcmConfiguration() => FcmConfiguration(
  'project',
  jsonEncode({
    'type': 'service_account',
    'project_id': 'project',
    'client_id': 'example',
    'client_email': 'example@example.invalid',
    'private_key': secret(),
  }),
);

class _TrackingClient extends http.BaseClient {
  bool closed = false;
  int calls = 0;
  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    calls++;
    return http.StreamedResponse(Stream.value(utf8.encode('{}')), 200);
  }

  @override
  void close() => closed = true;
}
