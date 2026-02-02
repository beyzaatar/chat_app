import 'package:chat_app/core/themes/app_theme_notifier.dart';
import 'package:flutter_riverpod/legacy.dart';

enum AppThemeMode { system, light, dark } //uygulmada kullanılacak tema modları

final themeModeProvider =
    StateNotifierProvider<ThemeModeNotifier, AppThemeMode>(
      (ref) => ThemeModeNotifier(),
    );
