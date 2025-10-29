import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_model.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';
import 'package:push_by_token_tester/core/model/entities/nav_item.dart';

class AppFooter extends StatefulWidget {
  final AppModel appModel;

  const AppFooter({required this.appModel, super.key});

  @override
  State<StatefulWidget> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(color: AppColors.blackXl),
      child: Center(
        child: ListenableBuilder(
          listenable: widget.appModel,
          builder: (context, _) {
            return ListView.separated(
              itemCount: widget.appModel.appRoutes.length,
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              separatorBuilder: (context, index) => const SizedBox(width: 25),
              itemBuilder: (context, index) =>
                  buildPageIndicator(context, index),
            );
          },
        ),
      ),
    );
  }

  Widget buildPageIndicator(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => handleNavigation(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: getRouteAccessability(index)
              ? AppColors.pinkXxl
              : AppColors.purple,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  void handleNavigation(int index) {
    if (!getRouteAccessability(index)) {
      return;
    }
    widget.appModel.selectedNavItem = NavItem.values[index];
    widget.appModel.animateToPage(index);
    setState(() {});
  }

  bool getRouteAccessability(int index) =>
      widget.appModel.appRoutes[index].isAvailable.call();
}
