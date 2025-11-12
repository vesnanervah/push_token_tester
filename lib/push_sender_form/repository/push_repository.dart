import 'dart:convert';
import 'dart:io';

import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';

class PushRepository {
  Uri buildUri(String projectId) => Uri.parse(
    'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
  );

  Future<Response> sendPush(
    AuthClient client, {
    required String text,
    required String title,
    required String projectId,
    required String deviceToken,
    Map<String, dynamic>? body,
  }) async {
    final params = {
      'message': {
        'token': deviceToken,
        'notification': {'title': title, 'body': text},
        if (body != null) 'data': body,
      },
    };
    final uri = buildUri(projectId);
    return await client.post(
      uri,
      body: jsonEncode(params),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader:
            'Bearer ${client.credentials.accessToken.data}',
      },
    );
  }
}
