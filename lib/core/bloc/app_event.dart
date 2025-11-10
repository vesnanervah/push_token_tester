part of 'app_bloc.dart';

sealed class AppEvent {
  const AppEvent();
}

class AppNavigationChange extends AppEvent {
  final NavItem? item;

  /// If [item] is not specified, then navigator will try to select next page
  const AppNavigationChange({this.item});
}

class AppDeviceTokenSelected extends AppEvent {
  final String? deviceToken;

  const AppDeviceTokenSelected(this.deviceToken);
}

class AppAuthClientChanged extends AppEvent {
  final String? projectId;
  final AuthClient? authClient;

  const AppAuthClientChanged({this.authClient, this.projectId});
}
