import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/view/base_form_page.dart';
import 'package:push_by_token_tester/push_sender_form/model/push_sender_form_model.dart';

class PushSenderFormPage extends BaseFormPage {
  const PushSenderFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _PushSenderFormPageState();
}

class _PushSenderFormPageState extends BaseFormPageState<PushSenderFormModel> {
  @override
  PushSenderFormModel createModel() =>
      PushSenderFormModel(appModel: appModel, status: currentRoute!.status);

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
          )
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
  String getSubmitBtnText() => 'Отправить';
}
