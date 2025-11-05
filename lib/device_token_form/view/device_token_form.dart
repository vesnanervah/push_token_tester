part of 'device_token_page.dart';

class _DeviceTokenForm extends StatefulWidget {
  const _DeviceTokenForm({super.key});

  @override
  State<StatefulWidget> createState() => _DeviceTokenFormState();
}

class _DeviceTokenFormState extends AbstractForm<DeviceTokenBloc> {
  @override
  get submitButtonText => 'Продолжить';

  @override
  Widget buildFields(BuildContext context) => TextFormField(
    // TODO(Zverev): hold value in state
    controller: formBloc.deviceTokenFieldController,
    decoration: const InputDecoration(hintText: 'Девайс токен...'),
    minLines: 12,
    maxLines: 14,
    validator: (value) =>
        (value?.isEmpty ?? true) ? 'Не должно быть пустым' : null,
  );

  @override
  Widget buildStatusBlock(BuildContext context) => Column(
    children: [
      const Text.rich(
        TextSpan(
          style: AppText.statusCommonText,
          children: [
            TextSpan(text: 'Внимательно проверьте токен. Его валидация '),
            TextSpan(text: 'отсутствует', style: AppText.statusAccentText),
          ],
        ),
      ),
      const SizedBox(height: 20),
      buildSubmitButton(),
    ],
  );
}
