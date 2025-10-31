import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';
import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart';

class GoogleAuthFormModel extends BaseFormPageModel {
  final jsonTextController = TextEditingController();
  final repository = GoogleAuthClientRepository();
  AuthClient? client;

  GoogleAuthFormModel({required super.appModel, required super.status}) {
    if (appModel.googleAuthJsonString?.isNotEmpty ?? false) {
      jsonTextController.text = appModel.googleAuthJsonString!;
    }
  }

  @override
  void resetForm() {
    client?.close();
    client = null;
    jsonTextController.text = '';
    appModel.googleAuthJsonString = null;
    appModel.googleAuthToken = null;
    appModel.notify();
    super.resetForm();
  }

  @override
  Future<void> submitForm() async {
    formStatusNotifier.value = FormStatus.loading;
    print(jsonTextController.text);
    try {
      final jsonData = jsonDecode(jsonTextController.text.trim());
      client = await repository.retrieveAuthClient(jsonData);
      appModel.projectId = jsonData['project_id'];
      appModel.googleAuthToken = client!.credentials.accessToken.data;
      appModel.googleAuthJsonString = jsonTextController.text;
      formStatusNotifier.value = FormStatus.successful;
    } catch (e) {
      // TODO: обработка ошибок
      print(e);
      errorMsg = 'Что-то пошло не так';
      formStatusNotifier.value = FormStatus.rejected;
    }
  }
}
