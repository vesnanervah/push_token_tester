import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/view/abstract_server_validated_form.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/google_auth_form/bloc/google_auth_bloc.dart';
import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart';

part 'gooogle_auth_form.dart';

class GoogleAuthFormPage extends StatelessWidget {
  const GoogleAuthFormPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider<GoogleAuthBloc>(
    create: (context) =>
        GoogleAuthBloc(context.read<AppModel>(), GoogleAuthClientRepository()),
    child: const _GoogleAuthForm(),
  );
}
