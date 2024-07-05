import 'package:flutter/cupertino.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';

class PushSenderFormModel extends BaseFormPageModel {
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
    try {
      final result = await appModel.api.sendPush(
        title: titleController.text,
        text: textPushController.text,
        body: bodyController.text,
      );
      if (!result) {
        errorMsg = 'Что-то пошло не так';
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
