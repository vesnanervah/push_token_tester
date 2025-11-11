part of 'base_form_bloc.dart';

class BaseFormEvent {
  const BaseFormEvent();
}

class SubmitForm extends BaseFormEvent {
  const SubmitForm();
}

class ResetForm extends BaseFormEvent {
  const ResetForm();
}
