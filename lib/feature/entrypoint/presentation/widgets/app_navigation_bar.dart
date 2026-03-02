import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_defaults.dart';
import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'bottom_app_bar_item.dart';

class AppBottomNavigationBar extends StatelessWidget {
  const AppBottomNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onNavTap,
  });

  final int currentIndex;
  final void Function(int) onNavTap;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<AppColors>()!;
    final local = AppLocalizations.of(context)!;
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: AppDefaults.margin,
      color: colors.scaffoldBackground,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BottomAppBarItem(
            name: local.t('homeChats'),
            iconLocation: Icons.chat_bubble_outline,
            isActive: currentIndex == 0,
            onTap: () => onNavTap(0),
          ),
          BottomAppBarItem(
            name: local.t('homeContacts'),
            iconLocation: Icons.people_outline,
            isActive: currentIndex == 1,
            onTap: () => onNavTap(1),
          ),
          BottomAppBarItem(
            name: local.t('homeCalls'),
            iconLocation: Icons.call_outlined,
            isActive: currentIndex == 2,
            onTap: () => onNavTap(2),
          ),
          BottomAppBarItem(
            name: local.t('profileTitle'),
            iconLocation: Icons.person_outline,
            isActive: currentIndex == 3,
            onTap: () => onNavTap(3),
          ),
        ],
      ),
    );
  }
}
