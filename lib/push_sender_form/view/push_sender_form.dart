part of 'push_sender_page.dart';

class _PushSenderForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PushSenderFormState();
}

class _PushSenderFormState
    extends AbstractServerValidatedForm<PushSenderState, PushSenderBloc> {
  final headerTextController = TextEditingController();
  final textTextController = TextEditingController();
  final bodyTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    headerTextController.addListener(
      () => formBloc.add(PushSenderHeaderChanged(headerTextController.text)),
    );
    textTextController.addListener(
      () => formBloc.add(PushSenderTextChanged(textTextController.text)),
    );
    bodyTextController.addListener(
      () => formBloc.add(PushSenderBodyChanged(bodyTextController.text)),
    );
  }

  @override
  void dispose() {
    headerTextController.dispose();
    textTextController.dispose();
    bodyTextController.dispose();
    super.dispose();
  }

  @override
  String get submitButtonText =>
      formBloc.state.status.isSuccessful ? 'Повторить' : 'Отправить';

  @override
  Widget buildFields(BuildContext context) => Column(
    children: [
      TextFormField(
        maxLines: 1,
        controller: headerTextController,
        decoration: const InputDecoration(hintText: 'Заголовок...'),
      ),
      const SizedBox(height: 20),
      TextFormField(
        maxLines: 1,
        controller: textTextController,
        decoration: const InputDecoration(hintText: 'Текст уведомления...'),
      ),
      const SizedBox(height: 20),
      TextFormField(
        maxLines: 4,
        controller: bodyTextController,
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

  @override
  void onFormStateUpdate(BuildContext context, PushSenderState state) {
    if (state is ResetPushSenderState) {
      headerTextController.text = '';
      textTextController.text = '';
      bodyTextController.text = '';
    }
  }
}
