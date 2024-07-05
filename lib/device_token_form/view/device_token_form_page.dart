import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/view/base_form_page.dart';
import 'package:push_by_token_tester/device_token_form/model/device_token_form_model.dart';

class DeviceTokenFormPage extends BaseFormPage {
  const DeviceTokenFormPage({super.key});

  @override
  State<StatefulWidget> createState() => _DeviceTokenFormPageState();
}

class _DeviceTokenFormPageState
    extends BaseFormPageState<DeviceTokenFormModel> {
  @override
  DeviceTokenFormModel createModel() =>
      DeviceTokenFormModel(appModel: appModel, status: currentRoute!.status);

  @override
  Widget buildFields(BuildContext context) => TextFormField(
        decoration: const InputDecoration(hintText: 'Девайс токен...'),
        minLines: 12,
        maxLines: 14,
        validator: (value) =>
            (value?.isEmpty ?? true) ? 'Не должно быть пустым' : null,
      );

  @override
  Widget buildNotSendedStatusBlock() => Column(
        children: [
          const Text.rich(
            TextSpan(
              style: AppText.statusCommonText,
              children: [
                TextSpan(text: 'Внимательно проверьте токен. Его валидация '),
                TextSpan(text: 'отсутствует', style: AppText.statusAccentText)
              ],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              trySubmit();
            },
            child: const Text(
              'Продолжить',
              style: AppText.btnText,
            ),
          ),
        ],
      );

  // TODO: make builders bellow nullable in super class
  @override
  Widget buildSuccessfulStatusBlockText() {
    // TODO: implement buildSuccessfulStatusBlockText
    throw UnimplementedError();
  }

  @override
  String getSubmitBtnText() {
    // TODO: implement getSubmitBtnText
    throw UnimplementedError();
  }

  @override
  Widget buildLoadingStatusBlockText() {
    // TODO: implement buildLoadingStatusBlockText
    throw UnimplementedError();
  }
}
