import 'package:push_by_token_tester/google_auth_form/repository/google_auth_client_repository.dart';
import 'package:push_by_token_tester/push_sender_form/repository/push_repository.dart';

sealed class AppContainer {
  const AppContainer();

  abstract final GoogleAuthClientRepository googleAuthClientRepository;
  abstract final PushRepository pushRepository;
}

class MockAppContainer extends AppContainer {
  @override
  final googleAuthClientRepository = const MockGoogleAuthClientRepository();

  @override
  final pushRepository = const MockPushRepository();

  const MockAppContainer();
}

class RealAppContainer extends AppContainer {
  @override
  final googleAuthClientRepository = const NetworkGoogleAuthClientRepository();

  @override
  final pushRepository = const NetworkPushRepository();

  const RealAppContainer();
}
