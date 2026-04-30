import 'package:flutter/material.dart';

class AppColors {
  // Official Design Tokens
  static const Color primary = Color(0xFF1A6FD4);
  static const Color primary2 = Color(0xFF00C896);
  static const Color primary3 = Color(0xFF1B1C1D);
  static const Color surface = Color(0xFFFFFFFF);
  
  static const Color textPrimary = Color(0xFF1B1C1D);
  static const Color textSecondary = Color(0xFF64676C);
  static const Color textTertiary = Color(0xFF8E9196); // Approximate from screenshot

  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  
  // Legacy/Helper Colors (Consider migrating to tokens above)
  static const Color splashGreen = Color(0xFF00C896);
  static const Color splashBlue = Color(0xFF1A6FD4);
  static const Color splashTeal = Color(0xFF00C897);
  
  // Existing colors if needed by other parts, or we can merge them
  static const Color primaryBlue = Color(0xFF1E74E9);
  static const Color inputBorder = Color(0xFFE0E0E0);
  static const Color otpBorderActive = Color(0xFF00C897);
}
