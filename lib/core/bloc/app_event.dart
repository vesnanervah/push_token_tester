part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

class AppNavigationChange extends AppEvent {
  final NavItem? item;

  /// If [item] is not specified, then navigator will try to select next page
  const AppNavigationChange({this.item});
}
