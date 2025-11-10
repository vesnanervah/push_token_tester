part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

class AppNavigationChange extends AppEvent {
  final NavItem item;

  const AppNavigationChange(this.item);
}
