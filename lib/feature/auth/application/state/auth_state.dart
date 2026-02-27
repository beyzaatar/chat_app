enum AuthStatus { initial, loading, success, error }

class AppAuthState {
  final AuthStatus status;
  final String? errorMessage;

  const AppAuthState({this.status = AuthStatus.initial, this.errorMessage});

  AppAuthState copyWith({AuthStatus? status, String? errorMessage}) {
    return AppAuthState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// initial → henüz bir şey olmadı,
// loading → Supabasee istek gitti bekliyoruz,
// success → işlem başarılı, error → bir şeyler ters gitti.
