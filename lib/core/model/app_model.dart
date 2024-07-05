import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/entities/nav_item.dart';
import 'package:push_by_token_tester/device_token_form/view/device_token_form_page.dart';
import 'package:push_by_token_tester/google_auth_form/view/gooogle_auth_form_page.dart';
import 'package:push_by_token_tester/push_sender_form/view/push_sender_form_page.dart';

class AppModel {
  String? googleAuthJsonString;
  String? googleAuthToken;
  String? deviceToken;
  final selectedNavItemNotifier = ValueNotifier(NavItem.jsonPage);
  final pageViewController = PageController();
  final isInitializedNotifier = ValueNotifier(false);
  List<AppRoute>? appRoutes;

  AppModel() {
    appRoutes = <AppRoute>[
      AppRoute(
        navItem: NavItem.jsonPage,
        isAvailable: () => true,
        body: const GoogleAuthFormPage(),
      ),
      AppRoute(
        navItem: NavItem.deviceTokenPage,
        isAvailable: () =>
            googleAuthJsonString != null && googleAuthToken != null,
        body: const DeviceTokenFormPage(),
      ),
      AppRoute(
        navItem: NavItem.pushContentPage,
        isAvailable: () =>
            googleAuthJsonString != null &&
            googleAuthToken != null &&
            deviceToken != null,
        body: const PushSenderFormPage(),
      )
    ];
    isInitializedNotifier.value = true;
  }

  void continueToNextStep() {
    if (selectedNavItemNotifier.value.index == appRoutes!.length - 1) return;
    selectedNavItemNotifier.value =
        NavItem.values[selectedNavItemNotifier.value.index + 1];
    pageViewController.animateToPage(
      selectedNavItemNotifier.value.index,
      duration: const Duration(milliseconds: 200),
      curve: Curves.bounceIn,
    );
  }
}

class AppRoute {
  final NavItem navItem;
  final bool Function() isAvailable;
  final Widget body;

  AppRoute({
    required this.navItem,
    required this.isAvailable,
    required this.body,
  });
}
