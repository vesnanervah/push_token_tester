import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';

class AppHeader extends StatelessWidget {
  final AppModel appModel;
  final bool shouldDisplayHelpBtn;
  final VoidCallback? onHelpClick;

  const AppHeader({
    required this.appModel,
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
      child: ListenableBuilder(
        listenable: appModel,
        builder: (BuildContext context, _) => Stack(
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
                appModel.currentRoute.navItem.title,
                style: AppText.header,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
