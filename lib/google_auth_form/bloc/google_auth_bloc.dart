import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:push_by_token_tester/base_form/bloc/bloc.dart';
import 'package:push_by_token_tester/core/bloc/bloc_events_devouncer.dart';
import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart';

part 'google_auth_state.dart';
part 'google_auth_event.dart';

class GoogleAuthBloc extends BaseFormBloc<GoogleAuthState> {
  final GoogleAuthClientRepository repository;
  String _jsonValue = '';
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
    emit(GoogleAuthState.loading());
    try {
      final jsonData = jsonDecode(_jsonValue.trim());
      final projectId = jsonData['project_id'];
      if (projectId is! String) {
        return emit(GoogleAuthState.rejected('Не найден project_id'));
      }
      final client = await repository.retrieveAuthClient(jsonData);
      emit(
        GoogleAuthState.successful(authClient: client, projectId: projectId),
      );
    } catch (e) {
      if (e is FormatException) {
        emit(GoogleAuthState.rejected('объект не в JSON формате'));
      } else {
        emit(GoogleAuthState.rejected('что-то пошло не так'));
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
    _jsonValue = event.value;
  }
}
