import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/core/bloc/app_bloc.dart';
import 'package:push_by_token_tester/core/di/app_container.dart';
import 'package:push_by_token_tester/core/view/view.dart';

class App extends StatefulWidget {
  final AppContainer appContainer;

  const App({required this.appContainer, super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: Scaffold(
        body: RepositoryProvider(
          create: (_) => widget.appContainer,
          child: BlocProvider(
            create: (context) => AppBloc(),
            child: const AppLayout(),
          ),
        ),
      ),
    );
  }
}
