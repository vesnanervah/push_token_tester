import 'dart:convert';

import 'package:http/http.dart' as http;
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

  Future<bool> sendPush({
    required String title,
    required String text,
    required String body,
  }) async {
    try {
      final params = {
        'message': {
          'token': appModel.deviceToken,
          'notification': {
            'title': title,
            'body': text,
          },
          /// todo: add data
        },
      };
      final response = await http.post(
        getUrl,
        headers: headers,
        body: jsonEncode(params),
      );
      print(params);
      print(response.body);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
