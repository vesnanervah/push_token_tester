import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/bloc.dart';
import 'package:push_by_token_tester/base_form/view/abstract_server_validated_form.dart';
import 'package:push_by_token_tester/core/bloc/bloc.dart';
import 'package:push_by_token_tester/core/di/app_continer.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';
import 'package:push_by_token_tester/push_sender_form/bloc/push_sender_bloc.dart';

part 'push_sender_form.dart';

class PushSenderPage extends StatefulWidget {
  const PushSenderPage({super.key});

  @override
  State<PushSenderPage> createState() => _PushSenderPageState();
}

class _PushSenderPageState extends State<PushSenderPage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final appBlocState = context.read<AppBloc>().state;
        return PushSenderBloc(
          context.read<AppContainer>().pushRepository,
          authClient: appBlocState.authClient!,
          projectId: appBlocState.projectId!,
          deviceToken: appBlocState.deviceToken!,
        );
      },
      child: _PushSenderForm(),
    );
  }
}
