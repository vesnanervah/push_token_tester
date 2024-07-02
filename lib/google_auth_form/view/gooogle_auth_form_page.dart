import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/view/base_form_page.dart';
import 'package:push_by_token_tester/google_auth_form/model/google_auth_form_model.dart';

class GoogleAuthFormPage extends BaseFormPage {
  const GoogleAuthFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _GoogleAuthFormPageState();
}

class _GoogleAuthFormPageState extends BaseFormPageState {
  @override
  BaseFormPageModel createModel() => GoogleAuthFormModel(appModel: appModel);

  @override
  Widget buildFields(BuildContext context) => TextFormField(
        minLines: 12,
        maxLines: 14,
        decoration: InputDecoration(
            hintText:
                '{           "type": "service_account",           "project_id": "app-id",           "private_key_id": "key-id",           "private_key": "-----BEGIN PRIVATE KEY-----PRIVATE KEY-----END PRIVATE KEY-----",           "client_email": "clientemail.gserviceaccount.com",           "client_id": "111111111111111",           "auth_uri": "https://accounts.google.com/o/oauth2/auth",           "token_uri": "https://oauth2.googleapis.com/token",           "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",           "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebaseclientx509url",           "universe_domain": "googleapis.com"         }'),
        validator: (value) =>
            (value?.isEmpty ?? true) ? 'Не должно быть пустым' : null,
      );

  @override
  Widget buildLoadingStatusBlock() {
    // TODO: implement buildLoadingStatusBlock
    throw UnimplementedError();
  }

  @override
  Widget buildNotSendedStatusBlock() => ElevatedButton(
        onPressed: () => trySubmit(),
        child: const Text(
          'Отправить',
          style: AppText.btnText,
        ),
      );

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
}
