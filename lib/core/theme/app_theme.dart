import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kidney_admin/core/constants/app_colors.dart';

ThemeData get appThemeData {
  final border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: AppColors.black.withValues(alpha: 0.1)),
  );
  final errorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(
      color: AppColors.red.withValues(alpha: 0.3),
      width: 0.8,
    ),
  );
  final focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(5),
    borderSide: BorderSide(color: AppColors.olive.withValues(alpha: 0.3)),
  );
  return ThemeData(
    primaryColor: AppColors.green,
    scaffoldBackgroundColor: AppColors.scaffoldBgColor,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.light(
      primary: AppColors.green,
      secondary: AppColors.cempedak,
      error: AppColors.red,
      surface: AppColors.white,
      onPrimary: AppColors.white,
      onSecondary: AppColors.black,
      onError: AppColors.white,
      onSurface: AppColors.black,
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.green,
      foregroundColor: AppColors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.green,
        foregroundColor: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        // primary: green,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        // primary: green,
        side: BorderSide(color: AppColors.green),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    textTheme: GoogleFonts.poppinsTextTheme().copyWith(
      displayLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      displayMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
        color: AppColors.black,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: AppColors.black),
      bodyMedium: TextStyle(fontSize: 14, color: AppColors.olive),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: border,
      enabledBorder: border,
      focusedBorder: focusBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      isDense: true,
      fillColor: AppColors.white,
      filled: true,
      contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      errorStyle: const TextStyle(height: 0.8, fontSize: 11.0),
      hintStyle: TextStyle(fontSize: 14.0, color: AppColors.gradient40),
    ),
    cardTheme: CardThemeData(
      color: AppColors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    ),
    dividerColor: AppColors.olive.withValues(alpha: 0.5),
  );
}
