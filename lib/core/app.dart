import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/app_theme.dart';
import 'package:push_by_token_tester/core/view/app_footer.dart';
import 'package:push_by_token_tester/core/view/app_header.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const AppHeader(headerText: 'Тайтл страницы'),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.blackXxl),
              padding: EdgeInsets.all(30),
              child: Column(
                children: [
                  // TODO: main content
                ],
              ),
            ),
          ),
          // TODO: read subpages lenght
          const AppFooter(navigationItemsLenght: 3),
        ],
      ),
    );
  }
}
