import 'package:googleapis_auth/auth_io.dart';
import 'package:injectable/injectable.dart';
import 'package:push_by_token_tester/mock/google_auth/mock_google_auth_client.dart';

sealed class GoogleAuthClientRepository {
  const GoogleAuthClientRepository();

  Future<AuthClient> retrieveAuthClient(Map<String, dynamic> json);
}

@Injectable(as: GoogleAuthClientRepository)
@test
class MockGoogleAuthClientRepository extends GoogleAuthClientRepository {
  const MockGoogleAuthClientRepository();

  @override
  Future<AuthClient> retrieveAuthClient(Map<String, dynamic> json) =>
      Future.delayed(
        const Duration(milliseconds: 400),
        () => MockGoogleAuthClient(),
      );
}

@Injectable(as: GoogleAuthClientRepository)
@dev
class NetworkGoogleAuthClientRepository extends GoogleAuthClientRepository {
  static const _firebaseMessagingScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  const NetworkGoogleAuthClientRepository();

  @override
  Future<AuthClient> retrieveAuthClient(Map<String, dynamic> json) =>
      clientViaServiceAccount(ServiceAccountCredentials.fromJson(json), [
        _firebaseMessagingScope,
      ]);
}
