import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:chat_app/core/localization/localization_provider.dart';
import 'package:chat_app/feature/auth/application/providers/auth_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  void _showLanguageDialog(BuildContext context, WidgetRef ref) {
    final local = AppLocalizations.of(context)!;
    final currentLanguage = ref.read(localizationProvider);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(local.t('settingsSelectLanguage')),
        content: RadioGroup<AppLanguage>(
          groupValue: currentLanguage,
          onChanged: (value) {
            if (value != null) {
              ref.read(localizationProvider.notifier).setLanguage(value);
              Navigator.of(context).pop();
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.values.map((language) {
              return RadioListTile<AppLanguage>(
                title: Text(language.name),
                value: language,
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final local = AppLocalizations.of(context);
    final currentLanguage = ref.watch(localizationProvider);
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
                  local!.t('settingsAccountSettings'),
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  local.t('settingsAccountSettingsDesc'),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
                  ),
                ),
                const SizedBox(height: 24),
                ProfileMenuCard(
                  icon: Icons.person_outline,
                  title: local.t('settingsProfileInfo'),
                  subTitle: local.t('settingsProfileInfoDesc'),
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.lock_outline,
                  title: local.t('settingsChangePassword'),
                  subTitle: local.t('settingsChangePasswordDesc'),
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.credit_card,
                  title: local.t('settingsPaymentMethods'),
                  subTitle: local.t('settingsPaymentMethodsDesc'),
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.location_on_outlined,
                  title: local.t('settingsLocations'),
                  subTitle: local.t('settingsLocationsDesc'),
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.group_outlined,
                  title: local.t('settingsAddSocialAccount'),
                  subTitle: local.t('settingsAddSocialAccountDesc'),
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.share_outlined,
                  title: local.t('settingsReferFriends'),
                  subTitle: local.t('settingsReferFriendsDesc'),
                  press: () {},
                ),
                ProfileMenuCard(
                  icon: Icons.language,
                  title: local.t('settingsLanguageChange'),
                  subTitle: currentLanguage.name,
                  press: () => _showLanguageDialog(context, ref),
                ),
                const SizedBox(height: 32),
                ProfileMenuCard(
                  icon: Icons.logout,
                  title: local.t('settingsLogout'),
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
