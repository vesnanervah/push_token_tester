part of 'base_form_bloc.dart';

@immutable
class BaseFormState extends Equatable {
  final FormStatus status;
  final String? error;

  const BaseFormState({this.status = FormStatus.initial, this.error});

  factory BaseFormState.initial() => const BaseFormState();
  factory BaseFormState.loading() =>
      const BaseFormState(status: FormStatus.loading);
  factory BaseFormState.successful() =>
      const BaseFormState(status: FormStatus.successful);
  factory BaseFormState.rejected(String error) =>
      BaseFormState(status: FormStatus.rejected, error: error);

  @override
  List<Object?> get props => [status, error];
}

enum FormStatus { initial, loading, successful, rejected }

extension FormStatusX on FormStatus {
  bool get isInitial => this == FormStatus.initial;
  bool get isLoading => this == FormStatus.loading;
  bool get isSuccessful => this == FormStatus.successful;
  bool get isRejected => this == FormStatus.rejected;
}
