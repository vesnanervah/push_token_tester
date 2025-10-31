import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';
import 'package:push_by_token_tester/push_sender_form/repository/push_repository.dart';

class PushSenderFormModel extends BaseFormPageModel {
  final PushRepository api = PushRepository();

  PushSenderFormModel({required super.appModel, required super.status});

  final titleController = TextEditingController();
  final textPushController = TextEditingController();
  final bodyController = TextEditingController();

  @override
  void resetForm() {
    titleController.text = '';
    textPushController.text = '';
    bodyController.text = '';
    super.resetForm();
  }

  @override
  Future<void> submitForm() async {
    formStatusNotifier.value = FormStatus.loading;
    Map<String, String>? body;
    try {
      body = bodyController.text.trim().isNotEmpty
          ? jsonDecode(bodyController.text.trim()) as Map<String, String>
          : null;
    } catch (_) {
      errorMsg =
          'Не удалось спарсить body. Убедитесь, что оно в формате Map<String, String>';
      formStatusNotifier.value = FormStatus.rejected;
    }
    try {
      final response = await api.sendPush(
        appModel.authClient!,
        title: titleController.text.trim(),
        text: textPushController.text.trim(),
        body: body,
        projectId: appModel.projectId!,
      );
      if (response.statusCode >= 400) {
        errorMsg = 'Ошибка на сервере';
        formStatusNotifier.value = FormStatus.rejected;
      } else {
        formStatusNotifier.value = FormStatus.successful;
      }
    } catch (_) {
      errorMsg = 'Что-то пошло не так';
      formStatusNotifier.value = FormStatus.rejected;
    }
  }
}
