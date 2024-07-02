import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/app_theme.dart';

class AppFooter extends StatefulWidget {
  final int navigationItemsLenght;

  const AppFooter({
    required this.navigationItemsLenght,
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
          itemBuilder: (context, index) => buildPageIndicator(),
        ),
      ),
    );
  }

  Widget buildPageIndicator() {
    return GestureDetector(
      onTap: () {
        // navigate
      },
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
