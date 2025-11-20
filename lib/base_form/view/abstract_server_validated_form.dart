import 'package:flutter/material.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';
import 'package:push_by_token_tester/base_form/view/abstract_form.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';

abstract class AbstractServerValidatedForm<
  S extends BaseFormState,
  B extends BaseFormBloc<S>
>
    extends AbstractForm<S, B> {
  @override
  Widget buildStatusBlock(BuildContext context, S state) =>
      switch (state.status) {
        FormStatus.initial => buildNotSendedStatusBlock(),
        FormStatus.loading => buildLoadingStatusBlock(),
        FormStatus.successful => buildSuccessfulStatusBlock(),
        FormStatus.rejected => buildRejectedStatusBlock(state),
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
  Widget buildRejectedStatusBlock(S state) => Column(
    children: [
      Text.rich(
        TextSpan(
          style: AppText.statusCommonText,
          children: [
            const TextSpan(text: 'Ошибка: '),
            TextSpan(
              text: state.error ?? 'Что-то пошло не так',
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
          buildSubmitButton(),
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
          buildContinueButton(),
        ],
      ),
    ],
  );

  @protected
  Widget buildLoadingStatusBlockText();

  @protected
  Widget buildSuccessfulStatusBlockText();

  Widget buildResetButton() => ElevatedButton(
    key: const Key('reset_form_btn'),
    onPressed: () => formBloc.add(const ResetForm()),
    child: const Text('Сбросить', style: AppText.btnText),
  );
}
