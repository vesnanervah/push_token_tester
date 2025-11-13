import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';
import 'package:push_by_token_tester/push_sender_form/repository/push_repository.dart';

part 'push_sender_state.dart';
part 'push_sender_event.dart';

class PushSenderBloc extends BaseFormBloc<PushSenderState> {
  final PushRepository repository;

  final AuthClient authClient;
  final String projectId;
  final String deviceToken;

  PushSenderBloc(
    this.repository, {
    required this.authClient,
    required this.projectId,
    required this.deviceToken,
  }) : super(PushSenderState.initial()) {
    on<PushSenderHeaderChanged>(onPushSenderHeaderChanged);
    on<PushSenderTextChanged>(onPushSenderTextChanged);
    on<PushSenderBodyChanged>(onPushSenderBodyChanged);
  }

  @override
  Future<void> submitForm(
    BaseFormEvent event,
    Emitter<PushSenderState> emit,
  ) async {
    emit(state.copyWith(status: FormStatus.loading));
    Map<String, dynamic>? body;
    try {
      body = state.pushBody.trim().isNotEmpty
          ? jsonDecode(state.pushBody.trim()) as Map<String, dynamic>
          : null;
    } catch (_) {
      emit(
        PushSenderState.rejected(
          'Не удалось спарсить body. Убедитесь, что оно в формате Map<String, String>',
        ),
      );
    }
    try {
      final response = await repository.sendPush(
        authClient,
        title: state.pushHeader.trim(),
        text: state.pushText.trim(),
        body: body,
        projectId: projectId,
        deviceToken: deviceToken,
      );
      if (response.statusCode >= 400) {
        emit(PushSenderState.rejected('Ошибка на сервере'));
      } else {
        emit(state.copyWith(status: FormStatus.successful));
      }
    } catch (_) {
      emit(PushSenderState.rejected('Что-то пошло не так'));
    }
  }

  @override
  void resetForm(BaseFormEvent event, Emitter<PushSenderState> emit) {
    emit(PushSenderState.initial());
  }

  @protected
  void onPushSenderHeaderChanged(
    PushSenderHeaderChanged event,
    Emitter<PushSenderState> emit,
  ) {
    // TODO(Zverev): throttle
    emit(state.copyWith(pushHeader: event.header));
  }

  @protected
  void onPushSenderTextChanged(
    PushSenderTextChanged event,
    Emitter<PushSenderState> emit,
  ) {
    // TODO(Zverev): throttle
    emit(state.copyWith(pushText: event.text));
  }

  @protected
  void onPushSenderBodyChanged(
    PushSenderBodyChanged event,
    Emitter<PushSenderState> emit,
  ) {
    // TODO(Zverev): throttle
    emit(state.copyWith(pushBody: event.body));
  }
}
