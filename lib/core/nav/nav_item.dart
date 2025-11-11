enum NavItem {
  jsonPage('Вставьте содержимое json от сервисного аккаунта FirebaseMessaging'),
  deviceTokenPage('Вставьте device token'),
  pushContentPage('Заполните содержимое пуша');

  final String title;

  const NavItem(this.title);
}

extension GetFaq on NavItem {
  String? get faq => switch (this) {
    NavItem.jsonPage =>
      'Страница проекта в console.firebase.google.com > Project setting(шестиренка справа от Project Overview) > Manage Service Accounts > Кликаем на сервисный аккаунт из списка (обычно всего один) > Вкладка KEYS > Add Key > Создаем ключ в JSON, он нам и нужен',
    NavItem.deviceTokenPage =>
      'Формируется через метод firebaseMessaging.getToken, обычно генерируется при запуске приложения в залогиненом стейте.',
    NavItem.pushContentPage => null,
  };
}
