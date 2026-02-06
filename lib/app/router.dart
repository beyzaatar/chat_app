import 'package:chat_app/core/widgets/splash_screen.dart';
import 'package:chat_app/feature/auth/presentation/pages/change_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/changed_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/forgot_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/login_or_signup_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/sign_up_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/verification_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashPage()),
      GoRoute(
        path: '/login-or-signup',
        builder: (context, state) => const LoginOrSignUpPage(),
      ),
      GoRoute(path: '/sign-in', builder: (context, state) => SignInPage()),
      GoRoute(path: '/sign-up', builder: (context, state) => SignUpPage()),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/verification',
        builder: (context, state) => const VerificationPage(),
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => ChangePasswordPage(),
      ),
      GoRoute(
        path: '/changed-password',
        builder: (context, state) => const ChangedPasswordPage(),
      ),
    ],
  );
});
