part of 'google_auth_bloc.dart';

@immutable
class GoogleAuthState extends BaseFormState {
  final AuthClient? authClient;
  final String? projectId;

  const GoogleAuthState({
    this.authClient,
    this.projectId,
    super.error,
    super.status,
  });

  factory GoogleAuthState.initial() =>
      const GoogleAuthState(authClient: null, projectId: null);
  factory GoogleAuthState.loading() => const GoogleAuthState(
    authClient: null,
    projectId: null,
    status: FormStatus.loading,
  );
  factory GoogleAuthState.successful({
    required AuthClient authClient,
    required String projectId,
  }) => GoogleAuthState(
    authClient: authClient,
    projectId: projectId,
    status: FormStatus.successful,
  );
  factory GoogleAuthState.rejected(String error) => GoogleAuthState(
    authClient: null,
    projectId: null,
    status: FormStatus.rejected,
    error: error,
  );
}
