import 'package:chat_app/feature/auth/application/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Text(
                  "Account Settings",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "Update your settings like notifications, payments, profile edit etc.",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ProfileMenuCard(
                  icon: Icons.person_outline,
                  title: "Profile Information",
                  subTitle: "Change your account information",
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.lock_outline,
                  title: "Change Password",
                  subTitle: "Change your password",
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.credit_card,
                  title: "Payment Methods",
                  subTitle: "Add your credit & debit cards",
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.location_on_outlined,
                  title: "Locations",
                  subTitle: "Add or remove your delivery locations",
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.group_outlined,
                  title: "Add Social Account",
                  subTitle: "Add Facebook, Twitter etc ",
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.share_outlined,
                  title: "Refer to Friends",
                  subTitle: "Get \$10 for reffering friends",
                  press: () {},
                ),
                const SizedBox(height: 32),
                ProfileMenuCard(
                  icon: Icons.logout,
                  title: "Logout",
                  subTitle: "",
                  press: () async {
                    await ref.read(authNotifierProvider.notifier).signOut();
                    if (context.mounted) {
                      context.go('/login-with-email');
                    }
                  },
                  isLogout: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileMenuCard extends StatelessWidget {
  const ProfileMenuCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subTitle,
    required this.press,
    this.isLogout = false,
  });

  final IconData icon;
  final String title, subTitle;
  final VoidCallback? press;
  final bool isLogout;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        onTap: press,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: isLogout
                    ? theme.colorScheme.error
                    : theme.colorScheme.onSurface.withValues(alpha: 0.64),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: isLogout
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurface,
                        fontWeight: isLogout
                            ? FontWeight.bold
                            : FontWeight.w500,
                      ),
                    ),
                    if (subTitle.isNotEmpty) const SizedBox(height: 8),
                    if (subTitle.isNotEmpty)
                      Text(
                        subTitle,
                        maxLines: 1,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14,
                          color: isLogout
                              ? theme.colorScheme.error.withValues(alpha: 0.7)
                              : theme.colorScheme.onSurface.withValues(
                                  alpha: 0.54,
                                ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              if (!isLogout)
                const Icon(Icons.arrow_forward_ios_outlined, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
