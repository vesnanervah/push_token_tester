import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:push_by_token_tester/device_token_form/view/device_token_page.dart';
import 'package:push_by_token_tester/google_auth_form/view/google_auth_page.dart';
import 'package:push_by_token_tester/push_sender_form/view/push_sender_page.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  final pageViewController = PageController();
  // TODO(Zverev): do not hold pages in bloc
  late final appRoutes = [
    AppRoute(
      navItem: NavItem.jsonPage,
      isAvailable: () => true,
      body: const GoogleAuthFormPage(),
      faq:
          'Страница проекта в console.firebase.google.com > Project setting(шестиренка справа от Project Overview) > Manage Service Accounts > Кликаем на сервисный аккаунт из списка (обычно всего один) > Вкладка KEYS > Add Key > Создаем ключ в JSON, он нам и нужен',
    ),
    AppRoute(
      navItem: NavItem.deviceTokenPage,
      isAvailable: () => state.authClient != null,
      body: const DeviceTokenPage(),
      faq:
          'Формируется через метод firebaseMessaging.getToken, обычно генерируется при запуске приложения в залогиненом стейте.',
    ),
    AppRoute(
      navItem: NavItem.pushContentPage,
      isAvailable: () => state.authClient != null && state.deviceToken != null,
      body: const PushSenderPage(),
    ),
  ];

  AppRoute get currentRoute => appRoutes[state.selectedNavItem.index];

  // TODO(Zverev): persistent state
  AppBloc() : super(const AppState()) {
    on<AppNavigationChange>(onAppNavigationChange);
  }

  void onAppNavigationChange(
    AppNavigationChange event,
    Emitter<AppState> emit,
  ) {
    if (event.item == state.selectedNavItem) return;
    final index = event.item?.index ?? currentRoute.navItem.index + 1;
    if (index > NavItem.values.length - 1) return;
    if (!appRoutes[index].isAvailable()) return;
    // TODO(Zverev): there is already emission of NavItem which occures in state emission.
    // Listen NavItem changes of the state in View and make animation call there.
    pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
    emit(state.copyWith());
  }
}

// TODO(Zverev): separate inner navigation logic and bloc

class AppRoute {
  final NavItem navItem;
  final bool Function() isAvailable;
  final Widget body;
  final String? faq;

  AppRoute({
    required this.navItem,
    required this.isAvailable,
    required this.body,
    this.faq,
  });
}

enum NavItem {
  jsonPage('Вставьте содержимое json от сервисного аккаунта FirebaseMessaging'),
  deviceTokenPage('Вставьте device token'),
  pushContentPage('Заполните содержимое пуша');

  final String title;

  const NavItem(this.title);
}
