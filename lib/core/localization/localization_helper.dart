import 'package:chat_app/core/localization/app_localizations.dart';
import 'package:flutter/material.dart';

/// BuildContext extension for easy access to localizations
extension LocalizationExtension on BuildContext {
  /// Get AppLocalizations instance
  AppLocalizations get l10n => AppLocalizations.of(this)!;

  /// Get current locale
  Locale get currentLocale => Localizations.localeOf(this);

  /// Check if current language is Turkish
  bool get isTurkish => currentLocale.languageCode == 'tr';

  /// Check if current language is English
  bool get isEnglish => currentLocale.languageCode == 'en';
}

/// String extension for translation with parameters
extension TranslationExtension on String {
  /// Replace placeholders in translation string
  /// Usage: "Hello {name}".tr({'name': 'John'})
  String tr(Map<String, String> params) {
    String result = this;
    params.forEach((key, value) {
      result = result.replaceAll('{$key}', value);
    });
    return result;
  }
}

/// Localization utility class
class LocalizationHelper {
  LocalizationHelper._();

  /// List of supported locales
  static const List<Locale> supportedLocales = [
    Locale('tr'), // Turkish - Default
    Locale('en'), // English
  ];

  /// Default locale
  static const Locale defaultLocale = Locale('tr');

  /// Get locale from language code
  static Locale getLocaleFromCode(String code) {
    return supportedLocales.firstWhere(
      (locale) => locale.languageCode == code,
      orElse: () => defaultLocale,
    );
  }

  /// Get language name from locale
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return 'Türkçe';
      case 'en':
        return 'English';
      default:
        return 'Türkçe';
    }
  }

  /// Get native language name from locale
  static String getNativeLanguageName(Locale locale) {
    return getLanguageName(locale);
  }

  /// Check if locale is supported
  static bool isLocaleSupported(Locale locale) {
    return supportedLocales.any((l) => l.languageCode == locale.languageCode);
  }

  /// Get flag emoji from locale
  static String getFlagEmoji(Locale locale) {
    switch (locale.languageCode) {
      case 'tr':
        return '🇹🇷';
      case 'en':
        return '🇺🇸';
      default:
        return '🇹🇷';
    }
  }
}
