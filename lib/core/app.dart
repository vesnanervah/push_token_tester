import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/core/bloc/app_bloc.dart';
import 'package:push_by_token_tester/core/view/view.dart';
import 'package:push_by_token_tester/push_workbench/push_transport.dart';
import 'package:push_by_token_tester/push_workbench/push_workbench_page.dart';

class App extends StatefulWidget {
  final bool dryRun;
  const App({super.key, this.dryRun = false});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Push token tester'),
          actions: [
            Builder(
              builder: (context) => TextButton(
                key: const ValueKey('open_workbench'),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => PushWorkbenchPage(
                      transport: widget.dryRun
                          ? const SimulatedPushTransport()
                          : HttpPushTransport(),
                    ),
                  ),
                ),
                child: const Text('FCM / RuStore · новый отправитель'),
              ),
            ),
          ],
        ),
        body: BlocProvider(
          create: (context) => AppBloc(),
          child: const AppLayout(),
        ),
      ),
    );
  }
}
