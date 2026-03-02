import 'package:animations/animations.dart';
import 'package:chat_app/feature/call/presentation/pages/call_history_page.dart';
import 'package:chat_app/feature/chats/presentation/pages/chats_page.dart';
import 'package:chat_app/feature/contact/presentation/pages/contact_page.dart';
import 'package:chat_app/feature/profile/presentation/pages/profile_page.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_defaults.dart';
import '../widgets/app_navigation_bar.dart';

/// This page will contain all the bottom navigation tabs
class EntryPointUI extends StatefulWidget {
  const EntryPointUI({super.key});

  @override
  State<EntryPointUI> createState() => _EntryPointUIState();
}

class _EntryPointUIState extends State<EntryPointUI> {
  /// Current Page
  int currentIndex = 0;

  /// On labelLarge navigation tap
  void onBottomNavigationTap(int index) {
    currentIndex = index;
    setState(() {});
  }

  /// All the pages (add placeholders for missing pages)
  List<Widget> pages = [
    const ChatsPage(),
    const ContactPage(), // Placeholder for Contacts
    const CallHistoryPage(), // Placeholder for Calls
    const ProfilePage(), // Placeholder for Profile
  ];

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    return Scaffold(
      body: PageTransitionSwitcher(
        transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: colors.scaffoldBackground,
            child: child,
          );
        },
        duration: AppDefaults.duration,
        child: pages[currentIndex],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: currentIndex,
        onNavTap: onBottomNavigationTap,
      ),
    );
  }
}
