import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'base_form_event.dart';
part 'base_form_state.dart';

abstract class BaseFormBloc<S extends BaseFormState>
    extends Bloc<BaseFormEvent, S> {
  BaseFormBloc(super.initialState) {
    on<SubmitForm>(submitForm);
    on<ResetForm>(resetForm);
  }

  Future<void> submitForm(BaseFormEvent event, Emitter<S> emit);

  void resetForm(BaseFormEvent event, Emitter<S> emit) {}
}
