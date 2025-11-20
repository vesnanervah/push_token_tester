part of 'push_sender_bloc.dart';

class PushSenderState extends BaseFormState {
  final String pushHeader;
  final String pushText;
  final String pushBody;

  const PushSenderState({
    this.pushHeader = '',
    this.pushText = '',
    this.pushBody = '',
    super.status,
    super.error,
  });

  factory PushSenderState.initial() => const PushSenderState();

  factory PushSenderState.rejected(String error) =>
      PushSenderState(error: error, status: FormStatus.rejected);

  PushSenderState copyWith({
    String? pushHeader,
    String? pushText,
    String? pushBody,
    FormStatus? status,
    String? error,
  }) => PushSenderState(
    pushHeader: pushHeader ?? this.pushHeader,
    pushText: pushText ?? this.pushText,
    pushBody: pushBody ?? this.pushBody,
    status: status ?? this.status,
    error: error ?? this.error,
  );

  @override
  List<Object?> get props => [pushHeader, pushText, pushBody, ...super.props];
}
