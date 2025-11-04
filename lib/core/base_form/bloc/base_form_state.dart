part of 'base_form_bloc.dart';

class BaseFormState {
  final FormStatus status;
  final String? error;

  BaseFormState._({this.status = FormStatus.initial, this.error = null});

  factory BaseFormState.initial() => BaseFormState._();
  factory BaseFormState.loading() =>
      BaseFormState._(status: FormStatus.loading);
  factory BaseFormState.successful() =>
      BaseFormState._(status: FormStatus.successful);
  factory BaseFormState.rejected(String error) =>
      BaseFormState._(status: FormStatus.rejected, error: error);
}

enum FormStatus { initial, loading, successful, rejected }

extension FormStatusX on FormStatus {
  bool get isInitial => this == FormStatus.initial;
  bool get isLoading => this == FormStatus.loading;
  bool get isSuccessful => this == FormStatus.successful;
  bool get isRejected => this == FormStatus.rejected;
}
