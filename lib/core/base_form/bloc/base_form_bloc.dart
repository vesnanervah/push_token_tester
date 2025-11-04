import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';

part 'base_form_event.dart';
part 'base_form_state.dart';

abstract class BaseFormBloc extends Bloc<BaseFormEvent, BaseFormState> {
  final AppModel appModel;

  BaseFormBloc(this.appModel) : super(BaseFormState.initial()) {
    on<SubmitForm>(submitForm);
    on<ResetForm>(resetForm);
  }

  Future<void> submitForm(BaseFormEvent event, Emitter<BaseFormState> emit);

  void resetForm(BaseFormEvent event, Emitter<BaseFormState> emit) =>
      emit(BaseFormState.initial());
}
