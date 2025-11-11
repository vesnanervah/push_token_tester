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
  late final pageController = context.read<AppBloc>().pageViewController;
  late final appRoutes = context.read<AppBloc>().appRoutes;

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
    listener: _onStateChange,
  );
}

void _onStateChange(BuildContext context, AppState state) {}
