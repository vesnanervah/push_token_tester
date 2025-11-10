import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';

class DeviceTokenBloc extends BaseFormBloc {
  late final deviceTokenFieldController = TextEditingController(
    text: appModel.deviceToken,
  );

  DeviceTokenBloc(super.appModel);

  @override
  Future<void> close() {
    deviceTokenFieldController.dispose();
    return super.close();
  }

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<BaseFormState> emit,
  ) async {
    appModel.deviceToken = deviceTokenFieldController.text.trim();
    appModel.continueToNextStep();
  }

  @override
  void resetForm(BaseFormEvent event, Emitter<BaseFormState> emit) {
    appModel.deviceToken = null;
    deviceTokenFieldController.text = '';
    appModel.notify();
    super.resetForm(event, emit);
  }
}
