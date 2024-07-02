import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/app_theme.dart';
import 'package:push_by_token_tester/core/model/nav_item.dart';
import 'package:push_by_token_tester/core/view/app_footer.dart';
import 'package:push_by_token_tester/core/view/app_header.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<StatefulWidget> createState() => _AppState();
}

class _AppState extends State<App> {
  final pageViewController = PageController();
  final pages = NavItem.values.map((navItem) => navItem.body).toList();
  final selectedNavItemNotifier = ValueNotifier(NavItem.jsonPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.themeData,
      home: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppHeader(
            selectedNavItemNotifier: selectedNavItemNotifier,
          ),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(color: AppColors.blackXxl),
              padding: const EdgeInsets.all(30),
              child: PageView.builder(
                controller: pageViewController,
                itemCount: pages.length,
                itemBuilder: (context, index) => pages[index],
              ),
            ),
          ),
          // TODO: read subpages lenght
          AppFooter(
            navigationItemsLenght: pages.length,
            onPageIndicatorClick: (index) => handleNavigation(index),
          )
        ],
      ),
    );
  }

  void handleNavigation(int index) {
    selectedNavItemNotifier.value = NavItem.values[index];
    pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
  }
}
