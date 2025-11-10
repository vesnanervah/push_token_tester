part of 'base_form_bloc.dart';

sealed class BaseFormEvent {}

class SubmitForm extends BaseFormEvent {}

class ResetForm extends BaseFormEvent {}
