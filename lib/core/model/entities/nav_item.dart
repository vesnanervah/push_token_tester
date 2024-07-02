import 'package:flutter/material.dart';

// TODO: link page
enum NavItem {
  jsonPage(
    'Вставьте содержимое json от сервисного аккаунта FirebaseMessaging',
    Text('страница 1'),
  ),
  deviceTokenPage(
    'Вставьте device token',
    Text('страница 2'),
  ),
  pushContentPage(
    'Заполните содержимое пуша',
    Text('страница 3'),
  );

  final String title;
  final Widget body;

  const NavItem(this.title, this.body);
}
