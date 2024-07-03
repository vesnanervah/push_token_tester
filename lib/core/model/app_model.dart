import 'package:flutter/material.dart';
import 'package:push_by_token_tester/core/model/entities/nav_item.dart';

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
      ),
      AppRoute(
        navItem: NavItem.jsonPage,
        isAvailable: () => googleAuthJsonString != null,
      ),
      AppRoute(
        navItem: NavItem.pushContentPage,
        isAvailable: () => googleAuthJsonString != null && deviceToken != null,
      )
    ];
    isInitializedNotifier.value = true;
  }
}

class AppRoute {
  final NavItem navItem;
  final bool Function() isAvailable;

  AppRoute({
    required this.navItem,
    required this.isAvailable,
  });
}
