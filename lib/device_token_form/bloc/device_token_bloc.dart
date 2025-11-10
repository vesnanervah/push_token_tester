import 'package:bloc/bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';

class DeviceTokenBloc extends BaseFormBloc {
  DeviceTokenBloc() : super(BaseFormState.initial());

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<BaseFormState> emit,
  ) async {
    emit(BaseFormState.successful());
  }
}
