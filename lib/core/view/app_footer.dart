part of 'app_layout.dart';

class AppFooter extends StatelessWidget {
  final AppState state;
  final void Function(int index) onNavItemTap;

  const AppFooter(this.state, {required this.onNavItemTap, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: const BoxDecoration(color: AppColors.blackXl),
      child: Center(
        child: ListView.separated(
          itemCount: NavItem.values.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          separatorBuilder: (context, index) => const SizedBox(width: 25),
          itemBuilder: (context, index) => buildPageIndicator(context, index),
        ),
      ),
    );
  }

  Widget buildPageIndicator(BuildContext context, int index) {
    return GestureDetector(
      key: ValueKey('app_nav_btn_$index'),
      onTap: () => onNavItemTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: state.getRouteAvailability(index)
              ? AppColors.pinkXxl
              : AppColors.purple,
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(
              color: index == state.selectedNavItem.index
                  ? AppColors.pinkL
                  : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
