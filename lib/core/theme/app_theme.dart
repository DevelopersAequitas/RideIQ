import 'package:flutter/material.dart';

import 'package:rideiq/core/theme/app_colors.dart';

/// Shared outline radius for text fields (reference: ~12).
const double kRideInputBorderRadius = 12;

/// [ThemeData] built from [AppColors]. Use with [MaterialApp.theme] / [darkTheme].
abstract final class AppTheme {
  static InputDecorationTheme get _inputDecorationLight {
    final baseSide = BorderSide(color: AppColors.borderPrimary, width: 1);
    final focusedSide = BorderSide(color: AppColors.borderDark, width: 1.5);
    final errorSide = BorderSide(color: AppColors.accentRed, width: 1);
    final r = BorderRadius.circular(kRideInputBorderRadius);
    return InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      border: OutlineInputBorder(borderRadius: r, borderSide: baseSide),
      enabledBorder: OutlineInputBorder(borderRadius: r, borderSide: baseSide),
      focusedBorder: OutlineInputBorder(borderRadius: r, borderSide: focusedSide),
      errorBorder: OutlineInputBorder(borderRadius: r, borderSide: errorSide),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(color: AppColors.accentRed, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(color: AppColors.borderSecondary, width: 1),
      ),
      labelStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      hintStyle: TextStyle(
        color: AppColors.textSecondary.withValues(alpha: 0.85),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
      errorStyle: const TextStyle(
        color: AppColors.accentRed,
        fontSize: 12,
        height: 1.3,
      ),
    );
  }

  static InputDecorationTheme get _inputDecorationDark {
    final baseSide = BorderSide(color: AppColors.darkStroke1, width: 1);
    final focusedSide = BorderSide(color: AppColors.borderDark, width: 1.5);
    final errorSide = BorderSide(color: AppColors.accentRed, width: 1);
    final r = BorderRadius.circular(kRideInputBorderRadius);
    return InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF2C2C2E),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      floatingLabelAlignment: FloatingLabelAlignment.start,
      border: OutlineInputBorder(borderRadius: r, borderSide: baseSide),
      enabledBorder: OutlineInputBorder(borderRadius: r, borderSide: baseSide),
      focusedBorder: OutlineInputBorder(borderRadius: r, borderSide: focusedSide),
      errorBorder: OutlineInputBorder(borderRadius: r, borderSide: errorSide),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(color: AppColors.accentRed, width: 1.5),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: r,
        borderSide: BorderSide(color: AppColors.darkStroke1.withValues(alpha: 0.5), width: 1),
      ),
      labelStyle: const TextStyle(
        color: AppColors.textTertiary,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
      floatingLabelStyle: const TextStyle(
        color: AppColors.surface,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        height: 1.0,
      ),
      hintStyle: TextStyle(
        color: AppColors.textTertiary.withValues(alpha: 0.9),
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.2,
      ),
      errorStyle: const TextStyle(
        color: AppColors.accentRed,
        fontSize: 12,
        height: 1.3,
      ),
    );
  }

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      inputDecorationTheme: _inputDecorationLight,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.surface,
        primaryContainer: AppColors.primaryLight,
        onPrimaryContainer: AppColors.primary3,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        onSurfaceVariant: AppColors.textSecondary,
        outline: AppColors.borderPrimary,
        outlineVariant: AppColors.borderSecondary,
        error: AppColors.accentRed,
        onError: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.bgPrimary,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      dividerColor: AppColors.borderSecondary,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primary,
        selectionHandleColor: AppColors.primary,
      ),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      inputDecorationTheme: _inputDecorationDark,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: AppColors.surface,
        primaryContainer: AppColors.primary3,
        onPrimaryContainer: AppColors.primaryLight,
        secondary: AppColors.secondary,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.darkBackground1,
        onSurface: AppColors.surface,
        onSurfaceVariant: AppColors.textTertiary,
        outline: AppColors.darkStroke1,
        outlineVariant: AppColors.borderDark,
        error: AppColors.accentRed,
        onError: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.darkBackground1,
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.darkBackground1,
        foregroundColor: AppColors.surface,
        elevation: 0,
        scrolledUnderElevation: 0.5,
      ),
      dividerColor: AppColors.darkStroke1,
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.surface,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: AppColors.primaryLight,
        selectionHandleColor: AppColors.primaryLight,
      ),
    );
  }
}
