import 'package:flutter/material.dart';

class AppColors {
  // ========================
  // Base Colors
  // ========================
  static const Color surface = Color(0xFFFFFFFF);

  // ========================
  // Primary Colors
  // ========================
  static const Color primary = Color(0xFF1E5EFF); // Blue
  /// Filled buttons, switches, and other primary CTAs (same hue as [primary]).
  static const Color ctaBlue = primary;
  static const Color primary2 = Color(0xFF1EB980); // Green
  static const Color primary3 = Color(0xFF0A1F44); // Dark Blue

  static const Color primaryLight = Color(0xFFD6E4FF);

  // Splash (reference: green top/mid, blue lower-left, teal lower-right)
  static const Color splashGreen = Color(0xFF00C897);
  static const Color splashBlue = Color(0xFF2072D2);
  static const Color splashTeal = Color(0xFF00BFA5);

  // ========================
  // Secondary
  // ========================
  static const Color secondary = Color(0xFFF5A623); // Orange

  // ========================
  // Text Colors
  // ========================
  static const Color textPrimary = Color(0xFF1C1C1E);
  static const Color textSecondary = Color(0xFF6E6E73);
  static const Color textTertiary = Color(0xFF8E8E93);

  // ========================
  // Borders
  // ========================
  static const Color borderDark = Color(0xFF2C2C2E);
  static const Color borderPrimary = Color(0xFFD1D1D6);
  static const Color borderSecondary = Color(0xFFE5E5EA);

  // ========================
  // Background
  // ========================
  static const Color bgPrimary = Color(0xFFF2F2F7);
  /// Main shell behind scroll content (`#FAFAFA`).
  static const Color screenBackgroundSoft = Color(0xFFFAFAFA);

  // ========================
  // Basic Colors
  // ========================
  static const Color black = Color(0xFF000000);

  // ========================
  // Overlays
  // ========================
  static const Color overlayBlack40 = Color(0x66000000); // 40%
  static const Color overlayWhite80 = Color(0xCCFFFFFF); // 80%
  static const Color overlayWhite60 = Color(0x99FFFFFF); // 60%
  static const Color overlayWhite20 = Color(0x33FFFFFF); // 20%

  // ========================
  // Driver / platform linking (reference UI)
  // ========================
  /// Profile-style blue for driver “Link” and AYRO badge (`#2D60FF`).
  static const Color driverAccentBlue = Color(0xFF2D60FF);
  /// Linked / “Connected” state on driver dashboard.
  static const Color driverConnectedGreen = Color(0xFF34C759);
  static const Color platformUberBlack = Color(0xFF111111);
  static const Color platformLyftMagenta = Color(0xFFEA2D8C);

  /// Driver earnings dashboard: selected platform row (e.g. AYRO “Today”).
  static const Color driverEarningsRowHighlight = Color(0xFFEEF4FF);
  /// $/hr pill on earnings rows (same hue as [splashTeal]).
  static const Color driverEarningsRateTeal = splashTeal;
  /// Light track behind proportional hourly bars on driver earnings rows.
  static const Color driverEarningsTrack = Color(0xFFEDEDF0);

  // ========================
  // Accent Colors
  // ========================
  static const Color accentYellow = Color(0xFFFFC107);
  static const Color accentGreen = Color(0xFF28A745);
  static const Color accentCustom1 = Color(0xFFC86C2D);
  static const Color accentCustom2 = Color(0xFF9AD6B7);
  static const Color accentRed = Color(0xFFE53935);
  static const Color accentBlue = Color(0xFF2962FF);

  // ========================
  // Dark Mode
  // ========================
  static const Color darkBackground1 = Color(0xFF121212);
  static const Color darkStroke1 = Color(0xFF2C2C2E);
}

