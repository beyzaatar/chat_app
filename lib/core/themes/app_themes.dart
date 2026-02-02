import 'package:chat_app/core/constants/app_colors.dart';
import 'package:chat_app/core/constants/app_defaults.dart';
import 'package:flutter/material.dart';

class AppThemes {
  static ThemeData lightTheme = _baseTheme(
    colors: AppColors.light,
    brightness: Brightness.light,
  );

  static ThemeData darkTheme = _baseTheme(
    colors: AppColors.dark,
    brightness: Brightness.dark,
  );

  static ThemeData _baseTheme({
    required AppColors colors,
    required Brightness brightness,
  }) {
    return ThemeData(
      brightness: brightness,
      fontFamily: 'Inter',
      scaffoldBackgroundColor: colors.scaffoldBackground,
      useMaterial3: true,

      // 🎨 COLOR SCHEME
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.primaryButton,
        onPrimary: Colors.white,
        secondary: colors.secondaryButton,
        onSecondary: Colors.white,
        error: colors.dangerColor,
        onError: Colors.white,
        surface: colors.scaffoldBackground,
        onSurface: colors.textPrimary,
      ),

      // 📝 TEXT THEME - Base definitions
      textTheme: TextTheme(
        displayLarge: TextStyle(
          fontSize: 57,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),
        displayMedium: TextStyle(
          fontSize: 45,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),
        displaySmall: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),

        headlineLarge: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),

        titleLarge: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          fontFamily: 'Inter',
        ),

        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: colors.textPrimary,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          fontFamily: 'Inter',
          letterSpacing: 0.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: colors.textSecondary,
          fontFamily: 'Inter',
          letterSpacing: 0.4,
        ),

        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          fontFamily: 'Inter',
          letterSpacing: 0.1,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: colors.textPrimary,
          fontFamily: 'Inter',
          letterSpacing: 0.5,
        ),
      ),

      // 🧭 APP BAR
      appBarTheme: AppBarTheme(
        elevation: 0.5,
        backgroundColor: colors.scaffoldBackground,
        iconTheme: IconThemeData(color: colors.iconColor),
        titleTextStyle: TextStyle(
          fontFamily: 'Inter',
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: colors.textPrimary,
        ),
      ),

      // 🔘 PRIMARY BUTTON
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primaryButton,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 48),
          padding: const EdgeInsets.symmetric(
            horizontal: AppDefaults.padding * 1.5,
            vertical: AppDefaults.padding,
          ),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // ⭕ OUTLINED BUTTON
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primaryButton,
          minimumSize: const Size(double.infinity, 48),
          side: BorderSide(color: colors.primaryButton),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // 📝 INPUT DECORATION
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.never,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: colors.primaryButton, width: 1.5),
        ),
        hintStyle: TextStyle(color: colors.placeholder),
      ),

      // 🃏 CARD
      cardTheme: CardThemeData(
        color: colors.cardColor,
        elevation: 2,
        shadowColor: Colors.black.withValues(alpha: 0.15),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),

      iconTheme: IconThemeData(color: colors.iconColor),

      extensions: <ThemeExtension<dynamic>>[colors],
    );
  }
}

// =====================================================
// 📝 EXTENSION - Text Styles + Icon Sizes (COMPLETE)
// =====================================================

extension ResponsiveTextStyles on BuildContext {
  /// Get responsive text style - theme'den al ve scale et
  TextStyle _scaleTextStyle(TextStyle baseStyle) {
    final scaleFactor = _getScaleFactor();
    final baseFontSize = baseStyle.fontSize ?? 14;
    return baseStyle.copyWith(fontSize: baseFontSize * scaleFactor);
  }

  double _getScaleFactor() {
    final width = MediaQuery.of(this).size.width;
    if (width < 600) return 1.0; // Mobile - no scaling
    if (width < 1024) return 1.1; // Tablet
    return 1.2; // Desktop
  }

  // ──────────────────────────────────
  // 📝 TEXT STYLES (Responsive)
  // ──────────────────────────────────

  TextStyle get displayLarge =>
      _scaleTextStyle(Theme.of(this).textTheme.displayLarge!);
  TextStyle get displayMedium =>
      _scaleTextStyle(Theme.of(this).textTheme.displayMedium!);
  TextStyle get displaySmall =>
      _scaleTextStyle(Theme.of(this).textTheme.displaySmall!);

  TextStyle get headlineLarge =>
      _scaleTextStyle(Theme.of(this).textTheme.headlineLarge!);
  TextStyle get headlineMedium =>
      _scaleTextStyle(Theme.of(this).textTheme.headlineMedium!);
  TextStyle get headlineSmall =>
      _scaleTextStyle(Theme.of(this).textTheme.headlineSmall!);

  TextStyle get titleLarge =>
      _scaleTextStyle(Theme.of(this).textTheme.titleLarge!);
  TextStyle get titleMedium =>
      _scaleTextStyle(Theme.of(this).textTheme.titleMedium!);
  TextStyle get titleSmall =>
      _scaleTextStyle(Theme.of(this).textTheme.titleSmall!);

  TextStyle get bodyLarge =>
      _scaleTextStyle(Theme.of(this).textTheme.bodyLarge!);
  TextStyle get bodyMedium =>
      _scaleTextStyle(Theme.of(this).textTheme.bodyMedium!);
  TextStyle get bodySmall =>
      _scaleTextStyle(Theme.of(this).textTheme.bodySmall!);

  TextStyle get labelLarge =>
      _scaleTextStyle(Theme.of(this).textTheme.labelLarge!);
  TextStyle get labelMedium =>
      _scaleTextStyle(Theme.of(this).textTheme.labelMedium!);
  TextStyle get labelSmall =>
      _scaleTextStyle(Theme.of(this).textTheme.labelSmall!);

  double get iconXS => 12 * _getScaleFactor(); // Extra small (badges)
  double get iconSM => 16 * _getScaleFactor(); // Small (small buttons)
  double get iconMD => 24 * _getScaleFactor(); // Medium (most common) ⭐
  double get iconLG => 32 * _getScaleFactor(); // Large (app bars, etc)
  double get iconXL => 48 * _getScaleFactor(); // Extra large (hero icons)
}
