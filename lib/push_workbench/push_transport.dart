import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

import 'push_message.dart';

enum PushOutcome { accepted, rejected, unknown, notSent, simulated }

/// Only allowlisted diagnostics cross the transport boundary.
class PushResult {
  final PushOutcome outcome;
  final String description;
  const PushResult(this.outcome, this.description);
}

abstract interface class PushTransport {
  Future<PushResult> send(PushConfiguration configuration, PushMessage message);
}

typedef AccessTokenProvider =
    Future<String> Function(FcmConfiguration configuration, http.Client client);

class HttpPushTransport implements PushTransport {
  final http.Client Function() _clientFactory;
  final AccessTokenProvider _accessTokenProvider;
  final DateTime Function() _now;
  final Duration timeout;

  HttpPushTransport({
    http.Client Function()? clientFactory,
    AccessTokenProvider? accessTokenProvider,
    DateTime Function()? now,
    this.timeout = const Duration(seconds: 20),
  }) : _clientFactory = clientFactory ?? http.Client.new,
       _accessTokenProvider = accessTokenProvider ?? _googleAccessToken,
       _now = now ?? DateTime.now;

  static Future<String> _googleAccessToken(
    FcmConfiguration configuration,
    http.Client client,
  ) async {
    final credentials = await obtainAccessCredentialsViaServiceAccount(
      ServiceAccountCredentials.fromJson(configuration.credentials()),
      ['https://www.googleapis.com/auth/firebase.messaging'],
      client,
    );
    return credentials.accessToken.data;
  }

  @override
  Future<PushResult> send(
    PushConfiguration configuration,
    PushMessage message,
  ) async {
    if (kIsWeb) {
      return const PushResult(
        PushOutcome.notSent,
        'Сервисные ключи разрешены только в desktop-приложении.',
      );
    }
    try {
      configuration.validate();
      message.payload(_now());
    } on PushValidationException catch (error) {
      return PushResult(PushOutcome.notSent, error.message);
    }
    final client = _clientFactory();
    var sending = false;
    try {
      final token = switch (configuration) {
        RuStoreConfiguration c => c.serviceToken,
        FcmConfiguration c => await _accessTokenProvider(
          c,
          client,
        ).timeout(timeout),
      };
      // OAuth can take time; recalculate expiry immediately before sending.
      final payload = message.payload(_now());
      final host = configuration.provider == PushProvider.rustore
          ? 'vkpns.rustore.ru'
          : 'fcm.googleapis.com';
      final request =
          http.Request(
              'POST',
              Uri.https(
                host,
                '/v1/projects/${configuration.projectId}/messages:send',
              ),
            )
            ..followRedirects = false
            ..headers.addAll({
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            })
            ..body = jsonEncode(payload);
      sending = true;
      // Exactly one attempt. No RetryClient, redirects, or automatic OAuth retry.
      final response = await (() async {
        final stream = await client.send(request);
        return http.Response.fromStream(stream);
      })().timeout(timeout);
      return _result(response, configuration.provider);
    } on PushValidationException catch (error) {
      return PushResult(PushOutcome.notSent, error.message);
    } on TimeoutException {
      return PushResult(
        sending ? PushOutcome.unknown : PushOutcome.notSent,
        sending
            ? 'Таймаут: результат неизвестен. Повтор только вручную с тем же ID.'
            : 'Таймаут авторизации. Push-запрос не отправлен.',
      );
    } catch (_) {
      return PushResult(
        sending ? PushOutcome.unknown : PushOutcome.notSent,
        sending
            ? 'Ошибка сети: результат неизвестен. Повтор только вручную с тем же ID.'
            : 'Не удалось авторизоваться в Google. Проверьте service account и срок действия ключа.',
      );
    } finally {
      client.close();
    }
  }

  PushResult _result(http.Response response, PushProvider provider) {
    final code = response.statusCode;
    if (code >= 200 && code < 300) {
      try {
        final body = jsonDecode(response.body);
        if (body is! Map<String, dynamic> ||
            body.containsKey('error') ||
            (provider == PushProvider.fcm && body['name'] is! String)) {
          throw const FormatException();
        }
        return const PushResult(
          PushOutcome.accepted,
          'API принял запрос. Доставка и показ на устройстве не подтверждены.',
        );
      } catch (_) {
        return const PushResult(
          PushOutcome.unknown,
          'Некорректный ответ API: результат неизвестен. Сохраните ID для ручного повтора.',
        );
      }
    }
    final description = switch (code) {
      400 => 'HTTP 400: неверный payload или push-токен.',
      401 => 'HTTP 401: ключ недействителен или истёк; обновите авторизацию.',
      403 => 'HTTP 403: нет доступа; проверьте сервисный ключ и проект.',
      404 => 'HTTP 404: проект или адресат не найден; push-токен мог истечь.',
      429 => 'HTTP 429: превышен лимит. Повторите позже вручную с тем же ID.',
      >= 500 =>
        'HTTP 5xx: ошибка провайдера; результат неизвестен. Повтор только вручную с тем же ID.',
      >= 300 && < 400 => 'Перенаправление API отклонено. Результат неизвестен.',
      _ => 'API отклонил запрос. Проверьте настройки.',
    };
    return PushResult(
      code >= 500 || (code >= 300 && code < 400)
          ? PushOutcome.unknown
          : PushOutcome.rejected,
      description,
    );
  }
}

class SimulatedPushTransport implements PushTransport {
  const SimulatedPushTransport();

  @override
  Future<PushResult> send(
    PushConfiguration configuration,
    PushMessage message,
  ) async {
    return const PushResult(
      PushOutcome.simulated,
      'Демонстрация: сетевой запрос не выполнялся.',
    );
  }
}
