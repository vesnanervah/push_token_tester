part of 'app_bloc.dart';

class AppState {
  final String? projectId;
  final String? deviceToken;
  final AuthClient? authClient;
  final NavItem selectedNavItem;

  const AppState({
    this.projectId,
    this.deviceToken,
    this.authClient,
    this.selectedNavItem = NavItem.jsonPage,
  });

  AppState copyWith({
    String? projectId,
    String? deviceToken,
    AuthClient? authClient,
    NavItem? selectedNavItem,
  }) => AppState(
    projectId: projectId ?? this.projectId,
    deviceToken: deviceToken ?? this.deviceToken,
    authClient: authClient ?? this.authClient,
    selectedNavItem: selectedNavItem ?? this.selectedNavItem,
  );
}
