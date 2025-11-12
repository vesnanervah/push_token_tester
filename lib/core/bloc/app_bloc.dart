import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:push_by_token_tester/core/nav/nav_item.dart';

part 'app_state.dart';
part 'app_event.dart';

class AppBloc extends Bloc<AppEvent, AppState> {
  // TODO(Zverev): persistent state
  AppBloc() : super(const AppState()) {
    on<AppNavigationChange>(onAppNavigationChange);
    on<AppAuthClientChanged>(onAppAuthClientChanged);
    on<AppDeviceTokenSelected>(onAppDeviceTokenSelected);
  }

  void onAppNavigationChange(
    AppNavigationChange event,
    Emitter<AppState> emit,
  ) {
    if (event.item == state.selectedNavItem) return;
    final index = event.item?.index ?? state.selectedNavItem.index + 1;
    if (index > NavItem.values.length - 1) return;
    if (!state.getRouteAvailability(index)) return;
    emit(state.copyWith(selectedNavItem: NavItem.values[index]));
  }

  void onAppDeviceTokenSelected(
    AppDeviceTokenSelected event,
    Emitter<AppState> emit,
  ) {
    emit(state.copyWith(deviceToken: event.deviceToken));
  }

  void onAppAuthClientChanged(
    AppAuthClientChanged event,
    Emitter<AppState> emit,
  ) {
    emit(
      state.copyWith(authClient: event.authClient, projectId: event.projectId),
    );
  }
}
