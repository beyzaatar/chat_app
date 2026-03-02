import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppLanguage {
  turkish('tr', 'Türkçe'),
  english('en', 'English');

  final String code;
  final String name;

  const AppLanguage(this.code, this.name);

  Locale get locale => Locale(code);

  static AppLanguage fromCode(String code) {
    return AppLanguage.values.firstWhere(
      (lang) => lang.code == code,
      orElse: () => AppLanguage.turkish, // Default Türkçe
    );
  }
}

class LocalizationNotifier extends StateNotifier<AppLanguage> {
  static const String _languageKey = 'app_language';

  LocalizationNotifier() : super(AppLanguage.turkish) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString(_languageKey);

      if (languageCode != null) {
        state = AppLanguage.fromCode(languageCode);
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, language.code);
      state = language;
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }

  void toggleLanguage() {
    if (state == AppLanguage.turkish) {
      setLanguage(AppLanguage.english);
    } else {
      setLanguage(AppLanguage.turkish);
    }
  }
}

final localizationProvider =
    StateNotifierProvider<LocalizationNotifier, AppLanguage>((ref) {
      return LocalizationNotifier();
    });

final currentLocaleProvider = Provider<Locale>((ref) {
  final language = ref.watch(localizationProvider);
  return language.locale;
});

final supportedLocalesProvider = Provider<List<Locale>>((ref) {
  return AppLanguage.values.map((lang) => lang.locale).toList();
});
