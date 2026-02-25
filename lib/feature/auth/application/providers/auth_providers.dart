import 'package:chat_app/feature/auth/application/notifiers/auth_notifier.dart';
import 'package:chat_app/feature/auth/application/state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Supabase auth state stream — kullanıcı giriş/çıkış durumunu dinler
final authStateStreamProvider = StreamProvider<AppAuthState?>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange.map((event) {
    if (event.session != null) {
      return const AppAuthState(status: AuthStatus.success);
    }
    return const AppAuthState(status: AuthStatus.initial);
  });
});

// Auth notifier provider
final authNotifierProvider = StateNotifierProvider<AuthNotifier, AppAuthState>(
  (ref) => AuthNotifier(),
);
