import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';
import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart';

class GoogleAuthFormModel extends BaseFormPageModel {
  final jsonTextController = TextEditingController();
  final repository = GoogleAuthClientRepository();
  AuthClient? get client => appModel.authClient;

  GoogleAuthFormModel({required super.appModel, required super.status});

  @override
  void resetForm() {
    client?.close();
    appModel.authClient = null;
    jsonTextController.text = '';
    appModel.projectId = null;
    appModel.notify();
    super.resetForm();
  }

  @override
  Future<void> submitForm() async {
    formStatusNotifier.value = FormStatus.loading;
    print(jsonTextController.text);
    try {
      final jsonData = jsonDecode(jsonTextController.text.trim());
      appModel.authClient = await repository.retrieveAuthClient(jsonData);
      final projectId = jsonData['project_id'];
      if (projectId is! String) {
        errorMsg = 'Не найден project_id';
        formStatusNotifier.value = FormStatus.rejected;
        return;
      }
      appModel.projectId = projectId;
      formStatusNotifier.value = FormStatus.successful;
    } catch (e) {
      // TODO: обработка ошибок
      print(e);
      errorMsg = 'Что-то пошло не так';
      formStatusNotifier.value = FormStatus.rejected;
    }
  }
}
