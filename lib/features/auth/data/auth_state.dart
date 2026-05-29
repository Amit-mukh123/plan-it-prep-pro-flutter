class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final String? refreshToken;
  final bool isLoading;

  AuthState({
    required this.isLoggedIn,
    this.accessToken,
    this.refreshToken,
    this.isLoading = false,
  });

  // Initial state
  factory AuthState.initial() {
    return AuthState(
      isLoggedIn: false,
      accessToken: null,
      refreshToken: null,
      isLoading: false,
    );
  }

  // Copy method (very important)
  AuthState copyWith({
    bool? isLoggedIn,
    String? accessToken,
    String? refreshToken,
    bool? isLoading,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
