import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';

class DeviceTokenFormModel extends BaseFormPageModel {
  final deviceTokenFieldController = TextEditingController();

  DeviceTokenFormModel({required super.appModel}) {
    if (appModel.deviceToken != null) {
      deviceTokenFieldController.text = appModel.deviceToken!;
    }
  }

  @override
  void resetForm() {
    appModel.deviceToken = null;
    deviceTokenFieldController.text = '';
    errorMsg = null;
  }

  @override
  Future<void> submitForm() async {
    appModel.deviceToken = deviceTokenFieldController.text;
    appModel.continueToNextStep();
  }
}
