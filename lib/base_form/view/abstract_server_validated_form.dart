import 'package:flutter/material.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';
import 'package:push_by_token_tester/base_form/view/abstract_form.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';

abstract class AbstractServerValidatedForm<B extends BaseFormBloc>
    extends AbstractForm<B> {
  @override
  Widget buildStatusBlock(BuildContext context) =>
      switch (formBloc.state.status) {
        FormStatus.initial => buildNotSendedStatusBlock(),
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
              text: formBloc.state.error ?? 'Что-то пошло не так',
              style: AppText.statusAccentText,
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildResetButton(),
          const SizedBox(width: 20),
          ElevatedButton(
            onPressed: () {
              formBloc.add(ResetForm());
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
          buildResetButton(),
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

  Widget buildResetButton() => ElevatedButton(
    onPressed: () => formBloc.add(SubmitForm()),
    child: const Text('Сбросить', style: AppText.btnText),
  );
}
