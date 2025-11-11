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
          itemCount: context.read<AppBloc>().appRoutes.length,
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
      onTap: () => context.read<AppBloc>().add(
        AppNavigationChange(item: NavItem.values[index]),
      ),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          // TODO(Zverev): contain accessibility of routes in state
          color: context.read<AppBloc>().appRoutes[index].isAvailable()
              ? AppColors.pinkXxl
              : AppColors.purple,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
