import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/app_theme.dart';

class AppHeader extends StatelessWidget {
  final String headerText;
  final bool shouldDisplayHelpBtn;
  final VoidCallback? onHelpClick;

  const AppHeader({
    required this.headerText,
    this.onHelpClick,
    this.shouldDisplayHelpBtn = true,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(color: AppColors.blackXl),
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: () => onHelpClick?.call(),
              child: const Text(
                'где искать?',
                style: AppText.btnText,
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              headerText,
              style: AppText.header,
            ),
          ),
        ],
      ),
    );
  }
}
