import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';
import 'package:push_by_token_tester/core/view/base_form_page.dart';

abstract class BaseValidatedFormPage extends BaseFormPage {
  const BaseValidatedFormPage({super.key});
}

abstract class BaseValidatedFormPageState<M extends BaseFormPageModel>
    extends BaseFormPageState<M> {
  @override
  Widget buildStatusBlock(BuildContext context) =>
      switch (model.formStatusNotifier.value) {
        FormStatus.notSended => buildNotSendedStatusBlock(),
        FormStatus.loading => buildLoadingStatusBlock(),
        FormStatus.successful => buildSuccessfulStatusBlock(),
        FormStatus.rejected => buildRejectedStatusBlock(),
      };

  @protected
  Widget buildNotSendedStatusBlock() => buildSubmitButton();

  @protected
  Widget buildLoadingStatusBlock() => Column(
    children: [
      buildLoadingStatusBlockText(),
      const SizedBox(height: 20),
      const LinearProgressIndicator(),
    ],
  );

  @protected
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
            child: const Text('Сбросить', style: AppText.btnText),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              model.submitForm();
            },
            child: const Text('Повторить', style: AppText.btnText),
          ),
        ],
      ),
    ],
  );

  @protected
  Widget buildSuccessfulStatusBlock() => Column(
    spacing: 20,
    children: [
      buildSuccessfulStatusBlockText(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            onPressed: () => model.resetForm(),
            child: const Text('Сбросить', style: AppText.btnText),
          ),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              appModel.continueToNextStep();
            },
            child: const Text('Продолжить', style: AppText.btnText),
          ),
        ],
      ),
    ],
  );

  @protected
  Widget buildLoadingStatusBlockText();

  @protected
  Widget buildSuccessfulStatusBlockText();
}
