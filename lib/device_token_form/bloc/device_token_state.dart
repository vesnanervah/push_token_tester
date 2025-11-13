part of 'device_token_bloc.dart';

class DeviceTokenState extends BaseFormState {
  final String? token;

  const DeviceTokenState(this.token, {super.status});

  factory DeviceTokenState.initial() =>
      const DeviceTokenState(null, status: FormStatus.initial);

  factory DeviceTokenState.successful(String token) =>
      DeviceTokenState(token, status: FormStatus.successful);

  @override
  List<Object?> get props => [token, ...super.props];
}
