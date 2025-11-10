import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/bloc.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';

abstract class AbstractForm<B extends BaseFormBloc>
    extends State<StatefulWidget> {
  abstract final String submitButtonText;

  final formKey = GlobalKey<FormState>();

  late final AppModel appModel = context.read<AppModel>();

  late final AppRoute currentRoute = appModel.currentRoute;

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
          BlocConsumer<B, BaseFormState>(
            listener: (context, state) {
              currentRoute.status = state.status;
            },
            builder: (context, state) => buildStatusBlock(context),
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
  Widget buildStatusBlock(BuildContext context);

  @protected
  Widget buildSubmitButton() => ElevatedButton(
    onPressed: () => trySubmit(),
    child: Text(submitButtonText, style: AppText.btnText),
  );

  void trySubmit() async {
    if (!context.mounted) {
      return;
    }
    if (formKey.currentState?.validate() ?? false) {
      formBloc.add(SubmitForm());
    }
  }
}
