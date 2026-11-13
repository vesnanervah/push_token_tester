import 'dart:convert';
import 'dart:math';

/// Validation errors contain only static descriptions, never supplied values.
class PushValidationException implements Exception {
  final String message;
  const PushValidationException(this.message);

  @override
  String toString() => message;
}

enum PushProvider { fcm, rustore }

sealed class PushConfiguration {
  final String projectId;
  const PushConfiguration(this.projectId);
  PushProvider get provider;

  void validate() {
    if (!RegExp(r'^[A-Za-z0-9_-]{1,128}$').hasMatch(projectId)) {
      throw const PushValidationException('Некорректный Project ID.');
    }
  }
}

class RuStoreConfiguration extends PushConfiguration {
  final String serviceToken;
  const RuStoreConfiguration(super.projectId, this.serviceToken);
  @override
  PushProvider get provider => PushProvider.rustore;

  @override
  void validate() {
    super.validate();
    if (!RegExp(r'^[\x21-\x7E]+$').hasMatch(serviceToken)) {
      throw const PushValidationException(
        'Укажите сервисный Bearer-токен без пробелов.',
      );
    }
  }
}

class FcmConfiguration extends PushConfiguration {
  final String serviceAccountJson;
  const FcmConfiguration(super.projectId, this.serviceAccountJson);
  @override
  PushProvider get provider => PushProvider.fcm;

  Map<String, dynamic> credentials() {
    try {
      final value = jsonDecode(serviceAccountJson);
      if (value is! Map<String, dynamic> ||
          value['type'] != 'service_account' ||
          value['project_id'] != projectId ||
          value['client_email'] is! String ||
          value['client_id'] is! String ||
          value['private_key'] is! String ||
          (value['token_uri'] != null &&
              value['token_uri'] != 'https://oauth2.googleapis.com/token')) {
        throw const FormatException();
      }
      return value;
    } catch (_) {
      throw const PushValidationException(
        'Нужен JSON service account с совпадающим Project ID и Google token_uri.',
      );
    }
  }

  @override
  void validate() {
    super.validate();
    credentials();
  }
}

Map<String, String> parsePushData(String input) {
  try {
    final value = jsonDecode(input);
    if (value is! Map<String, dynamic> ||
        value.values.any((value) => value is! String)) {
      throw const FormatException();
    }
    if (value.keys.any(
      (key) =>
          key.isEmpty ||
          key == 'from' ||
          key == 'message_type' ||
          key.startsWith('google.') ||
          key.startsWith('gcm.'),
    )) {
      throw const PushValidationException(
        'В data есть пустой или зарезервированный ключ.',
      );
    }
    return value.cast<String, String>();
  } on PushValidationException {
    rethrow;
  } catch (_) {
    throw const PushValidationException(
      'Data должен быть JSON-объектом со строковыми значениями.',
    );
  }
}

String newMessageId() {
  final random = Random.secure();
  final bytes = List.generate(16, (_) => random.nextInt(256));
  bytes[6] = (bytes[6] & 0x0f) | 0x40;
  bytes[8] = (bytes[8] & 0x3f) | 0x80;
  final hex = bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-'
      '${hex.substring(16, 20)}-${hex.substring(20)}';
}

class PushMessage {
  static const maxTtlSeconds = 28 * 24 * 60 * 60;
  final String deviceToken;
  final bool dataOnly;
  final String title;
  final String body;
  final Map<String, String> data;
  final int ttlSeconds;

  /// Optional application-defined data key containing Unix seconds.
  final String? expiryKey;

  PushMessage({
    required this.deviceToken,
    required this.dataOnly,
    required Map<String, String> data,
    required this.ttlSeconds,
    this.title = '',
    this.body = '',
    this.expiryKey,
  }) : data = Map.unmodifiable(data);

  Map<String, dynamic> payload(DateTime now) {
    if (!RegExp(r'^[\x21-\x7E]{1,2048}$').hasMatch(deviceToken) ||
        deviceToken.contains(',')) {
      throw const PushValidationException(
        'Нужен ровно один push-токен (до 2048 символов, без пробелов).',
      );
    }
    if (ttlSeconds < 1 || ttlSeconds > maxTtlSeconds) {
      throw const PushValidationException(
        'TTL должен быть от 1 до 2419200 секунд (28 дней).',
      );
    }
    parsePushData(jsonEncode(data));
    if (dataOnly && data.isEmpty) {
      throw const PushValidationException(
        'Для data-only нужен непустой объект data.',
      );
    }
    if (!dataOnly && title.trim().isEmpty) {
      throw const PushValidationException('Укажите заголовок уведомления.');
    }
    var ttl = ttlSeconds;
    if (expiryKey != null) {
      final expiry = int.tryParse(data[expiryKey] ?? '');
      if (expiry == null || expiry <= 0) {
        throw const PushValidationException(
          'Поле срока действия должно содержать Unix seconds строкой.',
        );
      }
      // Bound seconds before converting to milliseconds to avoid int overflow.
      final nowSeconds = now.millisecondsSinceEpoch ~/ 1000;
      if (expiry <= nowSeconds || expiry > nowSeconds + maxTtlSeconds) {
        throw const PushValidationException(
          'Срок действия истёк или превышает 28 дней.',
        );
      }
      // Floor the remaining duration: even a fractional last second is expired.
      final remaining = ((expiry * 1000 - now.millisecondsSinceEpoch) / 1000)
          .floor();
      if (remaining < 1 || remaining > maxTtlSeconds) {
        throw const PushValidationException(
          'Срок действия истёк или превышает 28 дней.',
        );
      }
      ttl = min(ttl, remaining);
    }
    final payload = <String, dynamic>{
      'message': {
        'token': deviceToken,
        if (!dataOnly) 'notification': {'title': title, 'body': body},
        if (data.isNotEmpty) 'data': data,
        'android': {'ttl': '${ttl}s'},
      },
    };
    if (utf8.encode(jsonEncode(payload)).length > 4096) {
      throw const PushValidationException(
        'Размер запроса превышает 4096 байт UTF-8.',
      );
    }
    return payload;
  }
}
