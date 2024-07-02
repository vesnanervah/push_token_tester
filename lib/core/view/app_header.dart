import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/model/entities/nav_item.dart';

class AppHeader extends StatelessWidget {
  final ValueNotifier<NavItem> selectedNavItemNotifier;
  final bool shouldDisplayHelpBtn;
  final VoidCallback? onHelpClick;

  const AppHeader({
    required this.selectedNavItemNotifier,
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
      child: ValueListenableBuilder(
        valueListenable: selectedNavItemNotifier,
        builder: (BuildContext context, NavItem value, Widget? child) => Stack(
          children: [
            // TODO: callback from value
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
                value.title,
                style: AppText.header,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
