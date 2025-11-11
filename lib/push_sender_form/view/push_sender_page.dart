import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/bloc.dart';
import 'package:push_by_token_tester/base_form/view/abstract_server_validated_form.dart';
import 'package:push_by_token_tester/core/bloc/bloc.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';
import 'package:push_by_token_tester/push_sender_form/bloc/push_sender_bloc.dart';
import 'package:push_by_token_tester/push_sender_form/repository/repository.dart';

part 'push_sender_form.dart';

class PushSenderPage extends StatelessWidget {
  const PushSenderPage({super.key});

  @override
  // TODO(Zverev): maybe hold all repositories in same place
  Widget build(BuildContext context) => BlocProvider(
    create: (context) {
      final appBlocState = context.read<AppBloc>().state;
      return PushSenderBloc(
        PushRepository(),
        authClient: appBlocState.authClient!,
        projectId: appBlocState.projectId!,
      );
    },
    child: _PushSenderForm(),
  );
}
