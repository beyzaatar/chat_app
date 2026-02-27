import 'package:chat_app/core/widgets/splash_screen.dart';
import 'package:chat_app/feature/auth/presentation/pages/change_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/changed_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/forgot_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/login_or_signup_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/login_with_email.dart';
import 'package:chat_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/onboarding_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/verification_page.dart';
import 'package:chat_app/feature/call/presentation/pages/audio_call_page.dart';
import 'package:chat_app/feature/chats/presentation/pages/chats_page.dart';
import 'package:chat_app/feature/chats/presentation/pages/message_search_page.dart';
import 'package:chat_app/feature/contact/presentation/pages/contact_search_page.dart';
import 'package:chat_app/feature/entrypoint/presentation/pages/entrypoint_ui.dart';
import 'package:chat_app/feature/chats/presentation/pages/messages_page.dart';
import 'package:chat_app/feature/settings/presentation/pages/settings_page.dart';
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
      GoRoute(
        path: '/login-with-email',
        builder: (context, state) => LoginWithEmail(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/verification',
        builder: (context, state) {
          final email = state.extra as String;
          return VerificationPage(email: email);
        },
      ),
      GoRoute(
        path: '/change-password',
        builder: (context, state) => ChangePasswordPage(),
      ),
      GoRoute(
        path: '/changed-password',
        builder: (context, state) => const ChangedPasswordPage(),
      ),
      GoRoute(path: '/chats', builder: (context, state) => const ChatsPage()),
      GoRoute(
        path: '/entry-point',
        builder: (context, state) => EntryPointUI(),
      ),
      GoRoute(
        path: '/message-search',
        builder: (context, state) => const MessageSearchPage(),
      ),
      GoRoute(
        path: '/messages',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return MessagesPage(
            conversationId: extra['conversationId'],
            otherUserName: extra['otherUserName'],
            otherUserAvatar: extra['otherUserAvatar'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/audio-call',
        builder: (context, state) => const AudioCallingPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/contact-search',
        builder: (context, state) => const ContactSearchPage(),
      ),
    ],
  );
});
