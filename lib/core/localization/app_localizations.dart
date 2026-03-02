import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  final Map<String, String> _localizedStrings = {};

  Future<bool> load() async {
    final langCode = locale.languageCode;

    final categories = [
      'common',
      'home',
      'login',
      'notification',
      'profile',
      'settings',
    ];

    for (final category in categories) {
      try {
        final jsonString = await rootBundle.loadString(
          'assets/lang/$category/$langCode.json',
        );
        final Map<String, dynamic> jsonMap = json.decode(jsonString);

        jsonMap.forEach((key, value) {
          _localizedStrings[key] = value.toString();
        });
      } catch (e) {
        debugPrint('Error loading $category/$langCode.json: $e');
      }
    }

    return true;
  }

  /// Çeviri anahtarına göre string döner
  /// Kullanım: context.l10n.t('commonOk')
  String t(String key) => _localizedStrings[key] ?? key;

  /// Parametreli çeviri
  /// Kullanım: context.l10n.tp('welcomeMessage', {'name': 'Ali'})
  /// JSON: "welcomeMessage": "Hoş geldin {name}"
  String tp(String key, Map<String, String> params) {
    String result = t(key);
    params.forEach((k, v) {
      result = result.replaceAll('{$k}', v);
    });
    return result;
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['tr', 'en'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    final localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
