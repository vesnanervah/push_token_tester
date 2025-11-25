import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:push_by_token_tester/base_form/base_form.dart';
import 'package:push_by_token_tester/core/bloc/bloc.dart';

part 'device_token_state.dart';
part 'device_token_event.dart';

class DeviceTokenBloc extends BaseFormBloc<DeviceTokenState> {
  DeviceTokenBloc() : super(DeviceTokenState.initial()) {
    on<DeviceTokenInputChanged>(
      onDeviceTokenInputChanged,
      transformer: debounceTransformer(const Duration(milliseconds: 200)),
    );
  }

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<DeviceTokenState> emit,
  ) async {
    assert((state.token ?? '').isNotEmpty);
    emit(DeviceTokenState.successful(state.token!));
  }

  @protected
  void onDeviceTokenInputChanged(
    DeviceTokenInputChanged event,
    Emitter<DeviceTokenState> emit,
  ) {
    return emit(DeviceTokenState(event.token));
  }
}
