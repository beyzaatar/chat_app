import 'package:chat_app/core/themes/app_theme_provider.dart';
import 'package:chat_app/core/themes/theme_storage_helper.dart';
import 'package:flutter_riverpod/legacy.dart';

class ThemeModeNotifier extends StateNotifier<AppThemeMode> {
  ThemeModeNotifier() : super(AppThemeMode.system) {
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final savedTheme = await ThemeStorageHelper.getTheme();
    if (savedTheme != null) {
      state = savedTheme;
    }
  }

  void setTheme(AppThemeMode theme) {
    state = theme;
    ThemeStorageHelper.saveTheme(theme);
  }
}
