part of 'push_sender_bloc.dart';

class PushSenderEvent extends BaseFormEvent {
  const PushSenderEvent();
}

class PushSenderHeaderChanged extends PushSenderEvent {
  final String header;

  const PushSenderHeaderChanged(this.header);
}

class PushSenderTextChanged extends PushSenderEvent {
  final String text;

  const PushSenderTextChanged(this.text);
}

class PushSenderBodyChanged extends PushSenderEvent {
  final String body;

  const PushSenderBodyChanged(this.body);
}
