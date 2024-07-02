import 'dart:convert';
import 'package:googleapis_auth/auth_io.dart';

class GoogleAuthFormModel {
  final _firebaseMessagingScope =
      'https://www.googleapis.com/auth/firebase.messaging';
  bool isLoading = false;
  AutoRefreshingAuthClient? client;

  Future<String?> auth(String credentialsJsonString) async {
    isLoading = true;
    try {
      client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
          jsonEncode(credentialsJsonString),
        ),
        [_firebaseMessagingScope],
      );
      isLoading = false;
    } catch (e) {
      // TODO: обработка ошибок
      print(e);
      isLoading = false;
      return 'Что-то пошло не так';
    }
  }
}
