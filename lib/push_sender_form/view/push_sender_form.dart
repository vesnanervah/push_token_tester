part of 'push_sender_page.dart';

class _PushSenderForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PushSenderFormState();
}

class _PushSenderFormState
    extends AbstractServerValidatedForm<BaseFormState, PushSenderBloc> {
  @override
  String get submitButtonText =>
      formBloc.state.status.isSuccessful ? 'Повторить' : 'Отправить';

  @override
  Widget buildFields(BuildContext context) => Column(
    children: [
      //TODO(Zverev): do not use controllers, hold values in state
      TextFormField(
        controller: formBloc.titleController,
        maxLines: 1,
        decoration: const InputDecoration(hintText: 'Заголовок...'),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: formBloc.textPushController,
        maxLines: 1,
        decoration: const InputDecoration(hintText: 'Текст уведомления...'),
      ),
      const SizedBox(height: 20),
      TextFormField(
        controller: formBloc.bodyController,
        maxLines: 4,
        decoration: const InputDecoration(hintText: 'Тело уведомления...'),
        validator: (value) {
          if (value?.isEmpty ?? true) {
            return null;
          }
          try {
            //TODO(Zverev): wrap in method
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
