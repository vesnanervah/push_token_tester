import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';

abstract class BaseFormPageModel {
  final formStatus = ValueNotifier(FormStatus.notSended);

  @protected
  Future<void> submitForm();

  @protected
  void resetForm();
}
