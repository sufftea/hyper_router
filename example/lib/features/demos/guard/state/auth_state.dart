class AuthState {
  const AuthState({
    this.authenticated = false,
  });

  final bool authenticated;

  AuthState copyWith({
    bool? authenticated,
  }) {
    return AuthState(
      authenticated: authenticated ?? this.authenticated,
    );
  }
}
