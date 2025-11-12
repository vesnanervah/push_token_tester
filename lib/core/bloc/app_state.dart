part of 'app_bloc.dart';

class AppState extends Equatable {
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

  AppState copyWithoutDeviceToken({
    String? projectId,
    AuthClient? authClient,
    NavItem? selectedNavItem,
  }) => AppState(
    projectId: projectId ?? this.projectId,
    authClient: authClient ?? this.authClient,
    selectedNavItem: selectedNavItem ?? this.selectedNavItem,
  );

  bool getRouteAvailability(int index) => switch (NavItem.values[index]) {
    NavItem.jsonPage => true,
    NavItem.deviceTokenPage => hasAuthData,
    NavItem.pushContentPage => authClient != null && hasDeviceData,
  };

  bool get hasAuthData => authClient != null && projectId != null;
  bool get hasDeviceData => deviceToken != null;

  @override
  List<Object?> get props => [
    projectId,
    authClient,
    deviceToken,
    selectedNavItem,
  ];
}
