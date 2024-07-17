import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';

class PushApi {
  final AppModel appModel;

  PushApi({
    required this.appModel,
  });

  String get url =>
      'https://fcm.googleapis.com/v1/projects/${appModel.projectId}/messages:send';

  Map<String, String> get headers => {
        'Authorization': 'Bearer ${appModel.googleAuthToken}',
        'Content-Type': 'application/json',
      };

  Uri get getUrl => Uri.parse(url);

  Future<Response> sendPush({
    required String title,
    required String text,
    Map<String, dynamic>? body,
  }) async {
    final params = {
      'message': {
        'token': appModel.deviceToken,
        'notification': {
          'title': title,
          'body': text,
        },
        if (body != null) 'data': body,
      },
    };
    return await http.post(
      getUrl,
      headers: headers,
      body: jsonEncode(params),
    );
  }
}
