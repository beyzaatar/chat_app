import 'dart:developer';

import 'package:chat_app/feature/auth/application/state/auth_state.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthNotifier extends StateNotifier<AppAuthState> {
  AuthNotifier() : super(const AppAuthState());

  final _supabase = Supabase.instance.client;

  Future<void> sendOtp(String email) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      await _supabase.auth.signInWithOtp(email: email);
      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> verifyOtp(String email, String otp) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final response = await _supabase.auth.verifyOTP(
        email: email,
        token: otp,
        type: OtpType.email,
      );
      log('verifyOtp response: ${response.session}');
      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      log('verifyOtp error: $e');
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    state = const AppAuthState();
  }

  Future<void> createProfile({
    required String fullName,
    required String username,
  }) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('Kullanıcı bulunamadı');

      await _supabase.from('profiles').insert({
        'id': user.id,
        'email': user.email,
        'full_name': fullName,
        'username': username,
      });

      state = state.copyWith(status: AuthStatus.success);
    } catch (e) {
      state = state.copyWith(
        status: AuthStatus.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<bool> hasProfile() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) return false;

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();
      return response != null;
    } catch (e) {
      return false;
    }
  }
}
