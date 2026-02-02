import 'package:chat_app/core/themes/app_theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorageHelper {
  static const _key = 'app_theme';

  static Future<void> saveTheme(AppThemeMode theme) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, theme.toString());
  }

  static Future<AppThemeMode?> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final themeStr = prefs.getString(_key);

    if (themeStr == null) return null;

    return AppThemeMode.values.firstWhere(
      (e) => e.toString() == themeStr,
      orElse: () => AppThemeMode.system,
    );
  }
}
