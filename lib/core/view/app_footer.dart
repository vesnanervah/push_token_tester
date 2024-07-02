import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/app_theme.dart';

class AppFooter extends StatefulWidget {
  final int navigationItemsLenght;
  final void Function(int index) onPageIndicatorClick;

  const AppFooter({
    required this.navigationItemsLenght,
    required this.onPageIndicatorClick,
    super.key,
  });

  @override
  State<StatefulWidget> createState() => _AppFooterState();
}

class _AppFooterState extends State<AppFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: const BoxDecoration(color: AppColors.blackXl),
      child: Center(
        child: ListView.separated(
          itemCount: widget.navigationItemsLenght,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(
            width: 25,
          ),
          itemBuilder: (context, index) => buildPageIndicator(context, index),
        ),
      ),
    );
  }

  Widget buildPageIndicator(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => widget.onPageIndicatorClick(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          color: AppColors.purple,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
