import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:push_by_token_tester/core/bloc/app_bloc.dart';
import 'package:push_by_token_tester/core/view/app_theme.dart';

part 'app_footer.dart';
part 'app_header.dart';

class AppLayout extends StatefulWidget {
  const AppLayout({super.key});

  @override
  State<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends State<AppLayout> {
  final pageController = PageController();
  late final appRoutes = context.read<AppBloc>().appRoutes;

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
        const AppHeader(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(30),
            child: PageView.builder(
              controller: pageController,
              itemCount: appRoutes.length,
              itemBuilder: (context, index) => appRoutes[index].body,
            ),
          ),
        ),
        const AppFooter(),
      ],
    ),
    listener: onStateChange,
  );

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
