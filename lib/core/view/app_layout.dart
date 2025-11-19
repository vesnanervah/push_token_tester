import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/core/bloc/app_bloc.dart';
import 'package:push_by_token_tester/core/nav/nav_item.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';
import 'package:push_by_token_tester/device_token_form/view/device_token_page.dart';
import 'package:push_by_token_tester/google_auth_form/view/view.dart';
import 'package:push_by_token_tester/push_sender_form/view/push_sender_page.dart';

part 'app_footer.dart';
part 'app_header.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<AppBloc, AppState>(
    builder: (context, state) => Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppHeader(state.selectedNavItem, key: const ValueKey('app_header')),
        Expanded(
          key: const ValueKey('app_body'),
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: PageView.builder(
              controller: pageController,
              itemCount: NavItem.values.length,
              itemBuilder: (context, index) => getPageFromNavItem(index),
            ),
          ),
        ),
        AppFooter(
          state,
          key: const ValueKey('app_footer'),
          onNavItemTap: (index) => context.read<AppBloc>().add(
            AppNavigationChange(item: NavItem.values[index]),
          ),
        ),
      ],
    ),
    listener: onStateChange,
  );

  Widget getPageFromNavItem(int index) => switch (NavItem.values[index]) {
    NavItem.jsonPage => const GoogleAuthPage(key: ValueKey('google_auth_page')),
    NavItem.deviceTokenPage => const DeviceTokenPage(
      key: ValueKey('device_token_page'),
    ),
    NavItem.pushContentPage => const PushSenderPage(),
  };

  void onStateChange(BuildContext context, AppState state) {
    if ((pageController.page?.toInt() ?? 0) != state.selectedNavItem.index) {
      pageController.animateToPage(
        state.selectedNavItem.index,
        duration: const Duration(milliseconds: 200),
        curve: Curves.bounceIn,
      );
    }
  }
}
