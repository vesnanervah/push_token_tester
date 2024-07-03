import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';

abstract class BaseFormPageModel {
  final formStatus = ValueNotifier(FormStatus.notSended);
  final AppModel appModel;
  String? errorMsg;

  BaseFormPageModel({required this.appModel});

  Future<void> submitForm();

  void resetForm();
}