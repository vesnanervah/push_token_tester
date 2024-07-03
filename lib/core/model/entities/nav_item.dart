import 'package:flutter/material.dart';
import 'package:push_by_token_tester/device_token_form/view/device_token_form_page.dart';
import 'package:push_by_token_tester/google_auth_form/view/gooogle_auth_form_page.dart';

// TODO: link page
enum NavItem {
  jsonPage(
    'Вставьте содержимое json от сервисного аккаунта FirebaseMessaging',
    GoogleAuthFormPage(),
  ),
  deviceTokenPage(
    'Вставьте device token',
    DeviceTokenFormPage(),
  ),
  pushContentPage(
    'Заполните содержимое пуша',
    Text('страница 3'),
  );

  final String title;
  final Widget body;

  const NavItem(this.title, this.body);
}
