import 'package:chat_app/core/widgets/splash_screen.dart';
import 'package:chat_app/feature/auth/presentation/pages/change_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/changed_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/forgot_password_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/login_or_signup_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/login_with_email.dart';
import 'package:chat_app/feature/auth/presentation/pages/sign_in_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/onboarding_page.dart';
import 'package:chat_app/feature/auth/presentation/pages/verification_page.dart';
import 'package:chat_app/feature/call/presentation/pages/call_page.dart';
import 'package:chat_app/feature/call/presentation/pages/call_search_page.dart';
import 'package:chat_app/feature/chats/presentation/pages/chats_page.dart';
import 'package:chat_app/feature/chats/presentation/pages/message_search_page.dart';
import 'package:chat_app/feature/contact/presentation/pages/contact_search_page.dart';
import 'package:chat_app/feature/entrypoint/presentation/pages/entrypoint_ui.dart';
import 'package:chat_app/feature/chats/presentation/pages/messages_page.dart';
import 'package:chat_app/feature/profile/presentation/pages/edit_profile_page.dart';
import 'package:chat_app/feature/settings/presentation/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
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
          final extra = state.extra as Map<String, dynamic>?;
          if (extra == null) {
            // If extra is null, return to entry point
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.go('/entry-point');
            });
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          return MessagesPage(
            conversationId: extra['conversationId'] ?? '',
            otherUserId: extra['otherUserId'] ?? '',
            otherUserName: extra['otherUserName'] ?? '',
            otherUserAvatar: extra['otherUserAvatar'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/call',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return CallPage(
            callId: extra['callId'],
            roomName: extra['roomName'],
            token: extra['token'],
            isVideo: extra['isVideo'],
            callerName: extra['callerName'] ?? '',
            callerImage: extra['callerImage'] ?? '',
          );
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/contact-search',
        builder: (context, state) => const ContactSearchPage(),
      ),
      GoRoute(
        path: '/call-search',
        builder: (context, state) => const CallSearchPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) => const EditProfilePage(),
      ),
    ],
  );
});
