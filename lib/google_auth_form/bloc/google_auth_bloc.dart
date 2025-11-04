import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:push_by_token_tester/core/base_form/bloc/bloc.dart';
import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart';

class GoogleAuthBloc extends BaseFormBloc {
  // TODO(Zverev): controller should be private and expose its value via state
  final jsonTextController = TextEditingController();
  final GoogleAuthClientRepository repository;

  GoogleAuthBloc(super.appModel, this.repository);
  AuthClient? get client => appModel.authClient;

  @override
  Future<void> close() {
    jsonTextController.dispose();
    return super.close();
  }

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<BaseFormState> emit,
  ) async {
    emit(BaseFormState.loading());
    try {
      final jsonData = jsonDecode(jsonTextController.text.trim());
      appModel.authClient = await repository.retrieveAuthClient(jsonData);
      final projectId = jsonData['project_id'];
      if (projectId is! String) {
        return emit(BaseFormState.rejected('Не найден project_id'));
      }
      appModel.projectId = projectId;
      emit(BaseFormState.successful());
    } catch (e) {
      // TODO(Zverev): обработка ошибок
      print(e);
      emit(BaseFormState.rejected('Что-то пошло не так'));
    }
  }

  @override
  void resetForm(BaseFormEvent event, Emitter<BaseFormState> emit) {
    client?.close();
    // TODO: actions in model state after replacement of appModel into bloc
    appModel.authClient = null;
    jsonTextController.text = '';
    appModel.projectId = null;
    appModel.notify();
    super.resetForm(event, emit);
  }
}
