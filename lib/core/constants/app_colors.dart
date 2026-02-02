import 'package:flutter/material.dart';

@immutable
class AppColors extends ThemeExtension<AppColors> {
  // 🎯 Brand & Actions
  final Color primaryButton;
  final Color secondaryButton;
  final Color dangerColor;
  final Color buttonText;

  // 🧱 Layout
  final Color scaffoldBackground;
  final Color cardColor;
  final Color inputBackground;

  // 📝 Text
  final Color textPrimary;
  final Color textSecondary;
  final Color placeholder;

  // 🎛 Icons & overlays
  final Color iconColor;
  final Color overlay;

  const AppColors({
    required this.primaryButton,
    required this.secondaryButton,
    required this.dangerColor,
    required this.buttonText,
    required this.scaffoldBackground,
    required this.cardColor,
    required this.inputBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.placeholder,
    required this.iconColor,
    required this.overlay,
  });

  @override
  AppColors copyWith({
    Color? primaryButton,
    Color? secondaryButton,
    Color? dangerColor,
    Color? buttonText,
    Color? scaffoldBackground,
    Color? cardColor,
    Color? inputBackground,
    Color? textPrimary,
    Color? textSecondary,
    Color? placeholder,
    Color? iconColor,
    Color? overlay,
  }) {
    return AppColors(
      primaryButton: primaryButton ?? this.primaryButton,
      secondaryButton: secondaryButton ?? this.secondaryButton,
      dangerColor: dangerColor ?? this.dangerColor,
      buttonText: buttonText ?? this.buttonText,
      scaffoldBackground: scaffoldBackground ?? this.scaffoldBackground,
      cardColor: cardColor ?? this.cardColor,
      inputBackground: inputBackground ?? this.inputBackground,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      placeholder: placeholder ?? this.placeholder,
      iconColor: iconColor ?? this.iconColor,
      overlay: overlay ?? this.overlay,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      primaryButton: Color.lerp(primaryButton, other.primaryButton, t)!,
      secondaryButton: Color.lerp(secondaryButton, other.secondaryButton, t)!,
      dangerColor: Color.lerp(dangerColor, other.dangerColor, t)!,
      buttonText: Color.lerp(buttonText, other.buttonText, t)!,
      scaffoldBackground: Color.lerp(
        scaffoldBackground,
        other.scaffoldBackground,
        t,
      )!,
      cardColor: Color.lerp(cardColor, other.cardColor, t)!,
      inputBackground: Color.lerp(inputBackground, other.inputBackground, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      placeholder: Color.lerp(placeholder, other.placeholder, t)!,
      iconColor: Color.lerp(iconColor, other.iconColor, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
    );
  }

  // 🌞 LIGHT THEME – Nature / Fresh / Clean
  static const light = AppColors(
    // 🎯 Actions
    primaryButton: Color(0xFF1F4D2B), // primary
    secondaryButton: Color(0xFFD6A436), // gold accent
    dangerColor: Color(0xFFD9534F),
    buttonText: Colors.white,

    // 🧱 Layout
    scaffoldBackground: Color(0xFFF4F7F5),
    cardColor: Colors.white,
    inputBackground: Color(0xFFE6EFE9),

    // 📝 Text
    textPrimary: Color(0xFF132E1D),
    textSecondary: Color(0xFF3E5A4B),
    placeholder: Color(0xFF8FA89A),

    // 🎛 Icons & overlay
    iconColor: Color(0xFF1F4D2B),
    overlay: Color.fromRGBO(0, 0, 0, 0.25),
  );

  // 🌙 DARK THEME – Forest / Premium / Calm
  static const dark = AppColors(
    // 🎯 Actions
    primaryButton: Color(0xFF3A7D44), // primaryLight
    secondaryButton: Color(0xFFD6A436),
    dangerColor: Color(0xFFD9534F),
    buttonText: Color(0xFFF4F7F5),

    // 🧱 Layout
    scaffoldBackground: Color(0xFF0E1A14),
    cardColor: Color(0xFF1B3324),
    inputBackground: Color(0xFF1A2F23),

    // 📝 Text
    textPrimary: Color(0xFFF4F7F5),
    textSecondary: Color(0xFFB8C5BD),
    placeholder: Color(0xFF8FA89A),

    // 🎛 Icons & overlay
    iconColor: Color(0xFFF4F7F5),
    overlay: Color.fromRGBO(0, 0, 0, 0.45),
  );
}
