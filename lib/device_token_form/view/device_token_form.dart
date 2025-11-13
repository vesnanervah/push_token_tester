part of 'device_token_page.dart';

class _DeviceTokenForm extends StatefulWidget {
  const _DeviceTokenForm();

  @override
  State<StatefulWidget> createState() => _DeviceTokenFormState();
}

class _DeviceTokenFormState
    extends AbstractForm<DeviceTokenState, DeviceTokenBloc> {
  @override
  get submitButtonText => 'Сохранить';

  @override
  Widget buildFields(BuildContext context) => TextFormField(
    decoration: const InputDecoration(hintText: 'Девайс токен...'),
    minLines: 12,
    maxLines: 14,
    onChanged: (val) => formBloc.add(DeviceTokenInputChanged(val)),
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
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 20,
        children: [
          buildSubmitButton(),
          if (formBloc.state.status.isSuccessful) buildContinueButton(),
        ],
      ),
    ],
  );

  Widget buildContinueButton() => ElevatedButton(
    onPressed: () => appBloc.add(const AppNavigationChange()),
    child: const Text('Продолжить', style: AppText.btnText),
  );

  @override
  onFormStateUpdate(BuildContext context, DeviceTokenState state) {
    if (state.status.isSuccessful) {
      appBloc.add(AppDeviceTokenSelected(state.token!.trim()));
    }
  }
}
