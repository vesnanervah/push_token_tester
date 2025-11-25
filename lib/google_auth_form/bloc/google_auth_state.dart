part of 'google_auth_bloc.dart';

class GoogleAuthState extends BaseFormState {
  final AuthClient? authClient;
  final String? projectId;
  final String jsonValue;

  const GoogleAuthState({
    this.authClient,
    this.projectId,
    super.error,
    super.status,
    this.jsonValue = '',
  });

  factory GoogleAuthState.initial() =>
      const GoogleAuthState(authClient: null, projectId: null);

  GoogleAuthState copyWith({
    AuthClient? authClient,
    String? projectId,
    String? jsonValue,
    String? error,
    FormStatus? status,
  }) => GoogleAuthState(
    authClient: authClient ?? this.authClient,
    projectId: projectId ?? this.projectId,
    jsonValue: jsonValue ?? this.jsonValue,
    error: error ?? this.error,
    status: status ?? this.status,
  );

  GoogleAuthState copyAsError(String error) =>
      copyWith(status: FormStatus.rejected, error: error);

  @override
  List<Object?> get props => [authClient, projectId, jsonValue, ...super.props];
}
