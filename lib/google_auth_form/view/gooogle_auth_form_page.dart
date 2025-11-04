import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/base_form/view/abstract_server_validated_form.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/google_auth_form/bloc/google_auth_bloc.dart';

class GoogleAuthFormPage extends StatefulWidget {
  const GoogleAuthFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _GoogleAuthFormPageState();
}

class _GoogleAuthFormPageState
    extends AbstractServerValidatedForm<GoogleAuthBloc> {
  @override
  get submitButtonText => 'Отправить';

  @override
  Widget buildFields(BuildContext context) => TextFormField(
    minLines: 12,
    //TODO(Zverev): controller isn't a good mix with bloc. Replace with onChange.
    controller: formBloc.jsonTextController,
    maxLines: 14,
    decoration: const InputDecoration(hintText: _credentialsJsonPlaceholer),
    validator: (value) =>
        (value?.isEmpty ?? true) ? 'Не должно быть пустым' : null,
  );

  @override
  Widget buildLoadingStatusBlockText() => const Text.rich(
    TextSpan(
      style: AppText.statusCommonText,
      children: [
        TextSpan(text: 'Происходит'),
        TextSpan(text: ' получение ', style: AppText.statusAccentText),
        TextSpan(text: 'токена авторизации от FirebaseMessaging'),
      ],
    ),
  );

  @override
  Widget buildSuccessfulStatusBlockText() => const Text.rich(
    TextSpan(
      style: AppText.statusCommonText,
      children: [
        TextSpan(text: 'Токен авторизации FirebaseMessaging'),
        TextSpan(text: ' успешно ', style: AppText.statusAccentText),
        TextSpan(text: 'получен'),
      ],
    ),
  );
}

const _credentialsJsonPlaceholer = '''
    {
      "type": "service_account",
      "project_id": "app-id",          
      "private_key_id": "key-id",          
      "private_key": "-----BEGIN PRIVATE KEY-----PRIVATE KEY-----END PRIVATE KEY-----",          
      "client_email": "clientemail.gserviceaccount.com",          
      "client_id": "111111111111111",          
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",          
      "token_uri": "https://oauth2.googleapis.com/token",          
      "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",          "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509firebaseclientx509url",          
      "universe_domain": "googleapis.com"        }
    ''';
