import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/base_form/bloc/base_form_bloc.dart';
import 'package:push_by_token_tester/base_form/view/abstract_server_validated_form.dart';
import 'package:push_by_token_tester/core/bloc/bloc.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';
import 'package:push_by_token_tester/google_auth_form/bloc/google_auth_bloc.dart';
import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart';

part 'gooogle_auth_form.dart';

class GoogleAuthPage extends StatefulWidget {
  const GoogleAuthPage({super.key});

  @override
  State<GoogleAuthPage> createState() => _GoogleAuthPageState();
}

class _GoogleAuthPageState extends State<GoogleAuthPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider<GoogleAuthBloc>(
      create: (context) => GoogleAuthBloc(GoogleAuthClientRepository()),
      child: const _GoogleAuthForm(),
    );
  }
}
