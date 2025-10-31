enum FormStatus {
  notSended,
  loading,
  successful,
  rejected;

  bool get isSuccessful => this == FormStatus.successful;
}
