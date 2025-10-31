import 'package:googleapis_auth/auth_io.dart';

class GoogleAuthClientRepository {
  static const _firebaseMessagingScope =
      'https://www.googleapis.com/auth/firebase.messaging';

  Future<AuthClient> retrieveAuthClient(Map<String, dynamic> json) =>
      clientViaServiceAccount(ServiceAccountCredentials.fromJson(json), [
        _firebaseMessagingScope,
      ]);
}
