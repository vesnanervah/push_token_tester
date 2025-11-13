part of 'device_token_bloc.dart';

class DeviceTokenEvent extends BaseFormEvent {
  const DeviceTokenEvent();
}

class DeviceTokenInputChanged extends DeviceTokenEvent {
  final String token;

  const DeviceTokenInputChanged(this.token);
}
