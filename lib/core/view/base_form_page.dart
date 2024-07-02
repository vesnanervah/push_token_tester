import 'package:flutter/widgets.dart';
import 'package:push_by_token_tester/core/model/base_form_page_model.dart';
import 'package:push_by_token_tester/core/model/entities/form_status.dart';

abstract class BaseFormPage extends StatefulWidget {}

abstract class _BaseFormPageState extends State<BaseFormPage> {
  late final BaseFormPageModel model;

  @override
  void initState() {
    super.initState();
    model = createModel();
  }

  @protected
  BaseFormPageModel createModel();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildFields(context),
        ValueListenableBuilder(
          valueListenable: model.formStatus,
          builder: (context, _, __) => buildStatusBlock(context),
        )
      ],
    );
  }

  @protected
  Widget buildFields(BuildContext context);

  Widget buildStatusBlock(BuildContext context) {
    return switch (model.formStatus.value) {
      FormStatus.notSended => buildNotSendedStatusBlock(),
      FormStatus.loading => buildLoadingStatusBlock(),
      FormStatus.successful => buildSuccessfulStatusBlock(),
      FormStatus.rejected => buildRejectedStatusBlock()
    };
  }

  @protected
  Widget buildNotSendedStatusBlock();

  @protected
  Widget buildLoadingStatusBlock();

  @protected
  Widget buildRejectedStatusBlock();

  @protected
  Widget buildSuccessfulStatusBlock();
}
