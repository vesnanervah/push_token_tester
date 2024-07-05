import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';

class GoogleAuthFormModel extends BaseFormPageModel {
  final jsonTextController = TextEditingController();
  final _firebaseMessagingScope =
      'https://www.googleapis.com/auth/firebase.messaging';
  AutoRefreshingAuthClient? client;

  GoogleAuthFormModel({required super.appModel}) {
    if (appModel.googleAuthJsonString?.isNotEmpty ?? false) {
      jsonTextController.text = appModel.googleAuthJsonString!;
    }
  }

  @override
  void resetForm() {
    client = null;
    appModel.googleAuthJsonString = '';
    appModel.googleAuthToken = '';
    formStatus.value = FormStatus.notSended;
  }

  @override
  Future<void> submitForm() async {
    formStatus.value = FormStatus.loading;
    print(jsonTextController.text);
    try {
      final jsonData = jsonDecode(jsonTextController.text);
      client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(jsonData),
        [_firebaseMessagingScope],
      );
      appModel.projectId = jsonData['project_id'];
      appModel.googleAuthToken = client!.credentials.accessToken.data;
      appModel.googleAuthJsonString = jsonTextController.text;
      formStatus.value = FormStatus.successful;
    } catch (e) {
      // TODO: обработка ошибок
      print(e);
      errorMsg = 'Что-то пошло не так';
      formStatus.value = FormStatus.rejected;
    }
  }
}
