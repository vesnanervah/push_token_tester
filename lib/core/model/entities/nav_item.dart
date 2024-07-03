enum NavItem {
  jsonPage(
    'Вставьте содержимое json от сервисного аккаунта FirebaseMessaging',
  ),
  deviceTokenPage(
    'Вставьте device token',
  ),
  pushContentPage(
    'Заполните содержимое пуша',
  );

  final String title;

  const NavItem(this.title);
}
