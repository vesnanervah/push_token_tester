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
        decoration: const InputDecoration(
            hintText:
                '{           "type": "service_account",           "project_id": "app-id",           "private_key_id": "key-id",           "private_key": "-----BEGIN PRIVATE KEY-----PRIVATE KEY-----END PRIVATE KEY-----",           "client_email": "clientemail.gserviceaccount.com",           "client_id": "111111111111111",           "auth_uri": "https://accounts.google.com/o/oauth2/auth",           "token_uri": "https://oauth2.googleapis.com/token",           "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",           "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebaseclientx509url",           "universe_domain": "googleapis.com"         }'),
        validator: (value) =>
            (value?.isEmpty ?? true) ? 'Не должно быть пустым' : null,
      );

  @override
  Widget buildLoadingStatusBlock() => const Column(
        children: [
          Text.rich(
            TextSpan(
              style: AppText.statusCommonText,
              children: [
                TextSpan(text: 'Происходит'),
                TextSpan(text: ' получение ', style: AppText.statusAccentText),
                TextSpan(text: 'токена авторизации от FirebaseMessaging'),
              ],
            ),
          ),
          SizedBox(height: 20),
          LinearProgressIndicator(),
        ],
      );

  @override
  Widget buildNotSendedStatusBlock() => ElevatedButton(
        onPressed: () => trySubmit(),
        child: const Text(
          'Отправить',
          style: AppText.btnText,
        ),
      );

  @override
  Widget buildRejectedStatusBlock() => Column(
        children: [
          Text.rich(
            TextSpan(
              style: AppText.statusCommonText,
              children: [
                const TextSpan(text: 'Ошибка: '),
                TextSpan(
                  text: model.errorMsg ?? 'Что-то пошло не так',
                  style: AppText.statusAccentText,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => model.resetForm(),
                child: const Text(
                  'Сбросить',
                  style: AppText.btnText,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: navigate to next page
                },
                child: const Text(
                  'Повторить',
                  style: AppText.btnText,
                ),
              )
            ],
          ),
        ],
      );

  @override
  Widget buildSuccessfulStatusBlock() => Column(
        children: [
          const Text.rich(
            TextSpan(
              style: AppText.statusCommonText,
              children: [
                TextSpan(text: 'Токен авторизации FirebaseMessaging'),
                TextSpan(text: ' успешно ', style: AppText.statusAccentText),
                TextSpan(text: 'получен'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => model.resetForm(),
                child: const Text(
                  'Отменить',
                  style: AppText.btnText,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  // TODO: navigate to next page
                },
                child: const Text(
                  'Продолжить',
                  style: AppText.btnText,
                ),
              )
            ],
          ),
        ],
      );
}
