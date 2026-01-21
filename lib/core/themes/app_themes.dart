import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get defaultTheme {
    return ThemeData(
      colorSchemeSeed: AppColors.primary,
      fontFamily: 'DM Sans',
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.scaffoldBackground,

      /* <----------- TEXT THEME ------------> */
      textTheme: const TextTheme(
        // BODY
        bodyLarge: TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),

        // TITLES
        titleLarge: TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w600, // SemiBold
          letterSpacing: 0.4,
          color: Colors.white,
        ),
        titleMedium: TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
          color: Colors.white,
        ),

        // BUTTON / CTA
        labelLarge: TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w500, // Medium
          letterSpacing: 0.6,
          color: Colors.black,
        ),

        // SMALL / STATUS (DM Mono)
        labelSmall: TextStyle(
          fontFamily: 'DM Mono',
          fontWeight: FontWeight.w400,
          letterSpacing: 1.1,
          color: AppColors.textSecondary,
        ),
      ),

      /* <----------- APP BAR ------------> */
      appBarTheme: const AppBarTheme(
        elevation: 0.3,
        backgroundColor: AppColors.scaffoldBackground,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          fontFamily: 'DM Sans',
          fontWeight: FontWeight.w600,
          letterSpacing: 0.4,
          fontSize: 18,
          color: Colors.white,
        ),
      ),

      /* <----------- BUTTONS ------------> */
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.black,
          elevation: 3,
          shadowColor: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
            fontSize: 16,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.5),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.6,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'DM Sans',
            fontWeight: FontWeight.w500,
            letterSpacing: 0.4,
          ),
        ),
      ),

      /* <----------- INPUTS ------------> */
      inputDecorationTheme: defaultInputDecorationTheme,

      /* <----------- SLIDER ------------> */
      sliderTheme: const SliderThemeData(
        showValueIndicator: ShowValueIndicator.alwaysVisible,
        thumbColor: Colors.white,
      ),

      // /* <----------- TABS ------------> */
      // tabBarTheme: const TabBarTheme(
      //   labelColor: AppColors.primary,
      //   unselectedLabelColor: AppColors.textSecondary,
      //   indicatorSize: TabBarIndicatorSize.label,
      //   labelStyle: TextStyle(
      //     fontFamily: 'DM Sans',
      //     fontWeight: FontWeight.w600,
      //   ),
      //   unselectedLabelStyle: TextStyle(
      //     fontFamily: 'DM Sans',
      //     fontWeight: FontWeight.w500,
      //   ),
      //   indicator: UnderlineTabIndicator(
      //     borderSide: BorderSide(color: AppColors.primary, width: 2),
      //   ),
      // ),

      // /* <----------- CARDS ------------> */
      // cardTheme: CardTheme(
      //   color: AppColors.cardColor,
      //   elevation: 3,
      //   shadowColor: Colors.black,
      //   shape: RoundedRectangleBorder(
      //     borderRadius: BorderRadius.circular(18),
      //   ),
      // ),
    );
  }

  /* <---- Input Decorations Theme -----> */
  static const defaultInputDecorationTheme = InputDecorationTheme(
    fillColor: AppColors.textInputBackground,
    filled: true,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: AppColors.primary, width: 1.2),
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    suffixIconColor: AppColors.placeholder,
  );
}
