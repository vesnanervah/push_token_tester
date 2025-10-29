import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/view/app_footer.dart';
import 'package:push_by_token_tester/core/view/app_header.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final appModel = AppModel();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: Scaffold(
        body: ListenableProvider(
          create: (context) => appModel,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppHeader(appModel: appModel),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(30),
                  child: PageView.builder(
                    controller: appModel.pageViewController,
                    itemCount: appModel.appRoutes.length,
                    itemBuilder: (context, index) =>
                        appModel.appRoutes[index].body,
                  ),
                ),
              ),
              AppFooter(appModel: appModel),
            ],
          ),
        ),
      ),
    );
  }
}
