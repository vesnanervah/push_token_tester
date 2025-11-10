part of 'app_layout.dart';

class AppHeader extends StatelessWidget {
  final bool shouldDisplayHelpBtn;

  const AppHeader({this.shouldDisplayHelpBtn = true, super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = context.watch<AppBloc>().currentRoute;

    return Container(
      height: 80,
      decoration: const BoxDecoration(color: AppColors.blackXl),
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Stack(
        children: [
          if (currentRoute.faq != null)
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
                        currentRoute.faq!,
                        style: AppText.header.copyWith(color: AppColors.blackL),
                      ),
                    ),
                  );
                },
                child: const Text('где искать?', style: AppText.btnText),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 192),
            child: Align(
              alignment: Alignment.center,
              child: AutoSizeText(
                currentRoute.navItem.title,
                style: AppText.header,
                maxLines: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
