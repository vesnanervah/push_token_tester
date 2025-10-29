import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';

abstract class BaseFormPage extends StatefulWidget {
  const BaseFormPage({super.key});
}

abstract class BaseFormPageState<M extends BaseFormPageModel>
    extends State<BaseFormPage> {
  abstract final String submitButtonText;

  final formKey = GlobalKey<FormState>();
  late final M model;

  late final AppModel appModel = context.read<AppModel>();

  late final AppRoute currentRoute = appModel.currentRoute;

  @override
  void initState() {
    super.initState();
    model = createModel();
  }

  @override
  void dispose() {
    currentRoute.status = model.formStatusNotifier.value;
    super.dispose();
  }

  @protected
  M createModel();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          const Spacer(flex: 4),
          wrapFieldsWithConstraints(context),
          const Spacer(flex: 2),
          ValueListenableBuilder(
            valueListenable: model.formStatusNotifier,
            builder: (context, _, __) => buildStatusBlock(context),
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
    if (model.formStatusNotifier.value == FormStatus.loading) {
      return;
    }
    if (formKey.currentState?.validate() ?? false) {
      model.submitForm();
    }
  }
}
