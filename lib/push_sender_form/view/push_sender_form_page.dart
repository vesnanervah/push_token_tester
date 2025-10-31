import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/view/base_form_page.dart';
import 'package:push_by_token_tester/core/view/base_validated_form_page.dart';
import 'package:push_by_token_tester/push_sender_form/model/push_sender_form_model.dart';

class PushSenderFormPage extends BaseFormPage {
  const PushSenderFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _PushSenderFormPageState();
}

class _PushSenderFormPageState
    extends BaseValidatedFormPageState<PushSenderFormModel> {
  @override
  String get submitButtonText =>
      model.formStatusNotifier.value.isSuccessful ? 'Повторить' : 'Отправить';

  @override
  PushSenderFormModel createModel() =>
      PushSenderFormModel(appModel: appModel, status: currentRoute.status);

  @override
  Widget buildFields(BuildContext context) => Column(
    children: [
      TextFormField(
        controller: model.titleController,
        maxLines: 1,
        decoration: const InputDecoration(hintText: 'Заголовок...'),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: model.textPushController,
        maxLines: 1,
        decoration: const InputDecoration(hintText: 'Текст уведомления...'),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: model.bodyController,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'Тело уведомления...'),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return null;
          }
          try {
            final res = jsonDecode(value!) is Map
                ? null
                : 'Должен быть в формате Map<String, String>';
            return res;
          } catch (_) {
            return 'Не удалось спарсить body. Убедитесь, что оно в формате Map<String, String>';
          }
        },
      ),
    ],
  );
  @override
  Widget buildLoadingStatusBlockText() => const Text.rich(
    TextSpan(
      style: AppText.statusCommonText,
      children: [
        TextSpan(text: 'Отправляем'),
        TextSpan(text: ' пуш', style: AppText.statusAccentText),
      ],
    ),
  );

  @override
  Widget buildSuccessfulStatusBlockText() => const Text.rich(
    TextSpan(
      style: AppText.statusCommonText,
      children: [
        TextSpan(text: 'Пуш'),
        TextSpan(text: ' успешно ', style: AppText.statusAccentText),
        TextSpan(text: 'отправлен'),
      ],
    ),
  );

  @override
  Widget buildSuccessfulStatusBlock() => Column(
    children: [
      buildSuccessfulStatusBlockText(),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildResetButton(),
          const SizedBox(width: 20),
          buildSubmitButton(),
        ],
      ),
    ],
  );
}
