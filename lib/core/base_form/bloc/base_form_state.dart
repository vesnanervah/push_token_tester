part of 'base_form_bloc.dart';

class BaseFormState extends Equatable {
  final FormStatus status;
  final String? error;

  const BaseFormState._({this.status = FormStatus.initial, this.error});

  factory BaseFormState.initial() => const BaseFormState._();
  factory BaseFormState.loading() =>
      const BaseFormState._(status: FormStatus.loading);
  factory BaseFormState.successful() =>
      const BaseFormState._(status: FormStatus.successful);
  factory BaseFormState.rejected(String error) =>
      BaseFormState._(status: FormStatus.rejected, error: error);

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
