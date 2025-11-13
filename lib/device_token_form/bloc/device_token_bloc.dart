import 'package:bloc/bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';

part 'device_token_state.dart';
part 'device_token_event.dart';

class DeviceTokenBloc extends BaseFormBloc<DeviceTokenState> {
  DeviceTokenBloc() : super(DeviceTokenState.initial()) {
    on<DeviceTokenInputChanged>(onDeviceTokenInputChanged);
  }

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<DeviceTokenState> emit,
  ) async {
    assert((state.token ?? '').isNotEmpty);
    emit(DeviceTokenState.successful(state.token!));
  }

  void onDeviceTokenInputChanged(
    DeviceTokenInputChanged event,
    Emitter<DeviceTokenState> emit,
  ) {
    // TODO(Zverev): throttle
    return emit(DeviceTokenState(event.token));
  }
}
