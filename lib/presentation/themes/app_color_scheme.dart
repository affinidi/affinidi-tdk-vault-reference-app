import 'package:flutter/material.dart';

class AppColorScheme {
  static final light = ColorScheme.fromSeed(seedColor: Colors.blue).copyWith(
    primary: Color.fromARGB(255, 255, 107, 60), // #ff6b3c
  );

  // Form field colors
  static const Color formFieldBorderFocused = Color(0xff0467f1);
  static const Color formFieldBorderUnfocused = Color(0xffcdced3);

  // Text colors
  static const Color textPrimary = Color(0xFF1D2138);
  static const Color textSecondary = Color(0xFF1D2138);

  // Background colors
  static const Color backgroundLight = Color(0xFFF5F5F5);
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundDark = Color(0xFF4A4A4A);

  // Icon colors
  static const Color iconInfo = Color(0xFF1D2138);

  // Divider colors
  static const Color divider = Color(0xFFE6E6E9);

  // Error colors
  static const Color error = Colors.red;
}
