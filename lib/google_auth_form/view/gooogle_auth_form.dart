import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/view/base_form_page.dart';
import 'package:push_by_token_tester/google_auth_form/model/google_auth_form_model.dart';

class GoogleAuthForm extends BaseFormPage {
  const GoogleAuthForm({super.key});

  @override
  State<StatefulWidget> createState() => _GoogleAuthFormState();
}

class _GoogleAuthFormState extends BaseFormPageState {
  @override
  Widget buildFields(BuildContext context) {
    // TODO: implement buildFields
    throw UnimplementedError();
  }

  @override
  Widget buildLoadingStatusBlock() {
    // TODO: implement buildLoadingStatusBlock
    throw UnimplementedError();
  }

  @override
  Widget buildNotSendedStatusBlock() {
    // TODO: implement buildNotSendedStatusBlock
    throw UnimplementedError();
  }

  @override
  Widget buildRejectedStatusBlock() {
    // TODO: implement buildRejectedStatusBlock
    throw UnimplementedError();
  }

  @override
  Widget buildSuccessfulStatusBlock() {
    // TODO: implement buildSuccessfulStatusBlock
    throw UnimplementedError();
  }

  @override
  BaseFormPageModel createModel() => GoogleAuthFormModel(appModel: appModel);
}
