import 'package:flutter/material.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:push_by_token_tester/core/base_form/bloc/base_form_bloc.dart';
import 'package:push_by_token_tester/core/model/entities/nav_item.dart';
import 'package:push_by_token_tester/device_token_form/view/device_token_form_page.dart';
import 'package:push_by_token_tester/google_auth_form/view/gooogle_auth_form_page.dart';
import 'package:push_by_token_tester/push_sender_form/view/push_sender_form_page.dart';

class AppModel extends ChangeNotifier {
  AuthClient? authClient;
  String? projectId;
  String? deviceToken;
  NavItem selectedNavItem = NavItem.jsonPage;
  final pageViewController = PageController();
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
      isAvailable: () => authClient != null,
      body: const DeviceTokenFormPage(),
      faq:
          'Формируется через метод firebaseMessaging.getToken, обычно генерируется при запуске приложения в залогиненом стейте.',
    ),
    AppRoute(
      navItem: NavItem.pushContentPage,
      isAvailable: () => authClient != null && deviceToken != null,
      body: const PushSenderFormPage(),
    ),
  ];

  AppRoute get currentRoute => appRoutes[selectedNavItem.index];

  void continueToNextStep() {
    if (selectedNavItem.index == appRoutes.length - 1) return;
    selectedNavItem = NavItem.values[selectedNavItem.index + 1];
    animateToPage(selectedNavItem.index);
    notify();
  }

  void notify() => notifyListeners();

  void animateToPage(int index) {
    pageViewController.animateToPage(
      index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
  }
}

class AppRoute {
  final NavItem navItem;
  final bool Function() isAvailable;
  final Widget body;
  final String? faq;
  FormStatus status;

  AppRoute({
    required this.navItem,
    required this.isAvailable,
    required this.body,
    this.faq,
    this.status = FormStatus.initial,
  });
}
