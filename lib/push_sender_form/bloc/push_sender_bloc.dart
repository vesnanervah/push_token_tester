import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';
import 'package:push_by_token_tester/push_sender_form/repository/push_repository.dart';

class PushSenderBloc extends BaseFormBloc {
  final PushRepository repository;
  final titleController = TextEditingController();
  final textPushController = TextEditingController();
  final bodyController = TextEditingController();

  PushSenderBloc(this.repository, super.appModel);

  @override
  Future<void> close() {
    titleController.dispose();
    textPushController.dispose();
    bodyController.dispose();
    return super.close();
  }

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<BaseFormState> emit,
  ) async {
    emit(BaseFormState.loading());
    Map<String, dynamic>? body;
    try {
      body = bodyController.text.trim().isNotEmpty
          ? jsonDecode(bodyController.text.trim()) as Map<String, dynamic>
          : null;
    } catch (_) {
      emit(
        BaseFormState.rejected(
          'Не удалось спарсить body. Убедитесь, что оно в формате Map<String, String>',
        ),
      );
    }
    try {
      final response = await repository.sendPush(
        appModel.authClient!,
        title: titleController.text.trim(),
        text: textPushController.text.trim(),
        body: body,
        projectId: appModel.projectId!,
      );
      if (response.statusCode >= 400) {
        emit(BaseFormState.rejected('Ошибка на сервере'));
      } else {
        emit(BaseFormState.successful());
      }
    } catch (_) {
      emit(BaseFormState.rejected('Что-то пошло не так'));
    }
  }

  @override
  void resetForm(BaseFormEvent event, Emitter<BaseFormState> emit) {
    titleController.text = '';
    textPushController.text = '';
    bodyController.text = '';
    super.resetForm(event, emit);
  }
}
