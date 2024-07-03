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
        body: Provider(
          create: (context) => appModel,
          child: ValueListenableBuilder(
            valueListenable: appModel.isInitializedNotifier,
            builder: (context, value, child) {
              return value
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        AppHeader(
                          selectedNavItemNotifier:
                              appModel.selectedNavItemNotifier,
                        ),
                        Expanded(
                          child: Container(
                            decoration:
                                const BoxDecoration(color: AppColors.blackXxl),
                            padding: const EdgeInsets.all(30),
                            child: PageView.builder(
                              controller: appModel.pageViewController,
                              itemCount: appModel.appRoutes!.length,
                              itemBuilder: (context, index) =>
                                  appModel.appRoutes![index].body,
                            ),
                          ),
                        ),
                        AppFooter(appModel: appModel),
                      ],
                    )
                  : const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ),
    );
  }
}
