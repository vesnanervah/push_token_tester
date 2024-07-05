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
  final formKey = GlobalKey<FormState>();
  late final M model;

  AppModel get appModel => context.read<AppModel>();

  @override
  void initState() {
    super.initState();
    model = createModel();
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
            valueListenable: model.formStatus,
            builder: (context, _, __) => buildStatusBlock(context),
          )
        ],
      ),
    );
  }

  Widget wrapFieldsWithConstraints(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < 576) return buildFields(context);
    if (width < 768) {
      return SizedBox(
        width: width / 100 * 80,
        child: buildFields(context),
      );
    }
    if (width < 1100) {
      return SizedBox(
        width: width / 100 * 70,
        child: buildFields(context),
      );
    }
    return SizedBox(
      width: 768,
      child: buildFields(context),
    );
  }

  @protected
  Widget buildFields(BuildContext context);

  @protected
  Widget buildStatusBlock(BuildContext context) =>
      switch (model.formStatus.value) {
        FormStatus.notSended => buildNotSendedStatusBlock(),
        FormStatus.loading => buildLoadingStatusBlock(),
        FormStatus.successful => buildSuccessfulStatusBlock(),
        FormStatus.rejected => buildRejectedStatusBlock()
      };

  @protected
  Widget buildNotSendedStatusBlock() => ElevatedButton(
        onPressed: () => trySubmit(),
        child: Text(
          getSubmitBtnText(),
          style: AppText.btnText,
        ),
      );

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
                child: const Text(
                  'Сбросить',
                  style: AppText.btnText,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  model.submitForm();
                },
                child: const Text(
                  'Повторить',
                  style: AppText.btnText,
                ),
              )
            ],
          ),
        ],
      );

  @protected
  Widget buildSuccessfulStatusBlock() => Column(
        children: [
          buildSuccessfulStatusBlockText(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => model.resetForm(),
                child: const Text(
                  'Сбросить',
                  style: AppText.btnText,
                ),
              ),
              const SizedBox(width: 20),
              ElevatedButton(
                onPressed: () {
                  appModel.continueToNextStep();
                },
                child: const Text(
                  'Продолжить',
                  style: AppText.btnText,
                ),
              )
            ],
          ),
        ],
      );

  @protected
  Widget buildLoadingStatusBlockText();

  @protected
  Widget buildSuccessfulStatusBlockText();

  String getSubmitBtnText();

  void trySubmit() async {
    if (!context.mounted) {
      return;
    }
    if (model.formStatus.value == FormStatus.loading) {
      return;
    }
    if (formKey.currentState?.validate() ?? false) {
      model.submitForm();
    }
  }
}
