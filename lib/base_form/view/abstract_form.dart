import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/bloc.dart';
import 'package:push_by_token_tester/core/bloc/app_bloc.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';

abstract class AbstractForm<S extends BaseFormState, B extends BaseFormBloc<S>>
    extends State<StatefulWidget> {
  abstract final String submitButtonText;

  final formKey = GlobalKey<FormState>();

  late final AppBloc appBloc = context.read<AppBloc>();

  B get formBloc => context.read<B>();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const Spacer(flex: 4),
          wrapFieldsWithConstraints(context),
          const Spacer(flex: 2),
          BlocConsumer<B, S>(
            listener: onFormStateUpdate,
            builder: (context, state) => buildStatusBlock(context, state),
          ),
        ],
      ),
    );
  }

  Widget wrapFieldsWithConstraints(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 576) return buildFields(context);
    if (width < 768) {
      return SizedBox(width: width / 100 * 80, child: buildFields(context));
    }
    if (width < 1100) {
      return SizedBox(width: width / 100 * 70, child: buildFields(context));
    }
    return SizedBox(width: 768, child: buildFields(context));
  }

  @protected
  Widget buildFields(BuildContext context);

  @protected
  Widget buildStatusBlock(BuildContext context, S state);

  @protected
  Widget buildSubmitButton() => ElevatedButton(
    key: const ValueKey('submit_form_btn'),
    onPressed: () => trySubmit(),
    child: Text(submitButtonText, style: AppText.btnText),
  );

  Widget buildContinueButton() => ElevatedButton(
    key: const ValueKey('continue_form_btn'),
    onPressed: () => appBloc.add(const AppNavigationChange()),
    child: const Text('Продолжить', style: AppText.btnText),
  );

  void trySubmit() async {
    if (!context.mounted) {
      return;
    }
    if (validate()) {
      formBloc.add(const SubmitForm());
    }
  }

  bool validate() => formKey.currentState?.validate() ?? false;

  void onFormStateUpdate(BuildContext context, S state) {}
}
