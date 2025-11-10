part of 'device_token_page.dart';

class _DeviceTokenForm extends StatefulWidget {
  const _DeviceTokenForm();

  @override
  State<StatefulWidget> createState() => _DeviceTokenFormState();
}

class _DeviceTokenFormState
    extends AbstractForm<BaseFormState, DeviceTokenBloc> {
  late final TextEditingController deviceTokenFieldController =
      TextEditingController(text: appBloc.state.deviceToken);

  @override
  get submitButtonText => 'Продолжить';

  @override
  void dispose() {
    deviceTokenFieldController.dispose();
    super.dispose();
  }

  @override
  Widget buildFields(BuildContext context) => TextFormField(
    controller: deviceTokenFieldController,
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

  @override
  onFormStateUpdate(BuildContext context, BaseFormState state) {
    if (state.status.isSuccessful) {
      appBloc.add(
        AppDeviceTokenSelected(deviceTokenFieldController.text.trim()),
      );
    }
  }
}
