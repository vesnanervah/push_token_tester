import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';

class AppHeader extends StatelessWidget {
  final AppModel appModel;
  final bool shouldDisplayHelpBtn;

  const AppHeader({
    required this.appModel,
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
            if (appModel.currentRoute.faq != null)
              Align(
                alignment: Alignment.centerLeft,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => Container(
                        alignment: Alignment.center,
                        color: Colors.white54,
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Text(
                          appModel.currentRoute.faq!,
                          style:
                              AppText.header.copyWith(color: AppColors.blackL),
                        ),
                      ),
                    );
                  },
                  child: const Text(
                    'где искать?',
                    style: AppText.btnText,
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 192),
              child: Align(
                alignment: Alignment.center,
                child: AutoSizeText(
                  appModel.currentRoute.navItem.title,
                  style: AppText.header,
                  maxLines: 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
