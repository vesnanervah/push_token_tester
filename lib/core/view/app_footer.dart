part of 'app_layout.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
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
    final appBloc = context.read<AppBloc>();
    final isSelected = index == appBloc.state.selectedNavItem.index;
    return GestureDetector(
      onTap: () =>
          appBloc.add(AppNavigationChange(item: NavItem.values[index])),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: appBloc.state.getRouteAvailability(index)
              ? AppColors.pinkXxl
              : AppColors.purple,
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(
              color: isSelected ? AppColors.pinkL : Colors.transparent,
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}
