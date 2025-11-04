import 'package:bloc/bloc.dart';
import 'package:push_by_token_tester/core/base_form/bloc/base_form_event.dart';
import 'package:push_by_token_tester/core/base_form/bloc/base_form_state.dart';

abstract class BaseFormBloc extends Bloc<BaseFormEvent, BaseFormState> {
  BaseFormBloc() : super(BaseFormState.initial()) {
    on<SubmitForm>(submitForm);
  }

  Future<void> submitForm(BaseFormEvent event, Emitter<BaseFormState> emit);

  void resetForm(BaseFormEvent event, Emitter<BaseFormState> emit) =>
      emit(BaseFormState.initial());
}
