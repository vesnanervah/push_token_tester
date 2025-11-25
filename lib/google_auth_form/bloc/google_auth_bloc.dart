import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:push_by_token_tester/base_form/base_form.dart';
import 'package:push_by_token_tester/core/bloc/bloc.dart';
import 'package:push_by_token_tester/google_auth_form/google_auth_form.dart';

part 'google_auth_state.dart';
part 'google_auth_event.dart';

class GoogleAuthBloc extends BaseFormBloc<GoogleAuthState> {
  final GoogleAuthClientRepository repository;
  GoogleAuthBloc(this.repository) : super(GoogleAuthState.initial()) {
    on<GoogleAuthJsonChange>(
      onGoogleAuthJsonChange,
      transformer: debounceTransformer(const Duration(milliseconds: 200)),
    );
  }

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<GoogleAuthState> emit,
  ) async {
    emit(state.copyWith(status: FormStatus.loading));
    try {
      final jsonData = jsonDecode(state.jsonValue);
      final projectId = jsonData['project_id'];
      if (projectId is! String) {
        return emit(
          state.copyAsError(
            projectId == null
                ? 'Не найден project_id'
                : 'project_Id должен быть в формате String',
          ),
        );
      }
      final client = await repository.retrieveAuthClient(jsonData);
      emit(
        state.copyWith(
          status: FormStatus.successful,
          authClient: client,
          projectId: projectId,
        ),
      );
    } catch (e) {
      if (e is FormatException) {
        emit(state.copyAsError('объект не в JSON формате'));
      } else {
        emit(state.copyAsError('что-то пошло не так'));
      }
    }
  }

  @override
  void resetForm(BaseFormEvent event, Emitter<BaseFormState> emit) {
    state.authClient?.close();
    emit(GoogleAuthState.initial());
  }

  @protected
  void onGoogleAuthJsonChange(
    GoogleAuthJsonChange event,
    Emitter<BaseFormState> emit,
  ) async {
    emit(state.copyWith(jsonValue: event.value));
  }
}
