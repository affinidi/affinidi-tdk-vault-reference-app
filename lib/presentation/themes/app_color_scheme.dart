import 'package:flutter/material.dart';

class AppColorScheme {
  static final light = ColorScheme.fromSeed(seedColor: Colors.blue).copyWith(
    primary: Color(0xff007aff), // #040822
  );

  static final dark = ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
  ).copyWith(
    primary: Color(0xff007aff), // #040822
  );

  // Form field colors - Using dark theme
  static const Color formFieldBorderFocused = Color(0xff0467f1);
  static const Color formFieldBorderUnfocused = Color(0xff4A4A4A);

  // Text colors - Using dark theme
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFB0B0B0);

  // Background colors - Using dark theme
  static const Color backgroundLight = Color(0xFF1A1A1A);
  static const Color backgroundBlack = Color(0xff040822);
  static const Color backgroundWhite = Colors.white;
  static const Color backgroundDark = Color(0xFF1A1A1A);

  // Icon colors - Using dark theme
  static const Color iconInfo = Colors.white;

  // Divider colors - Using dark theme
  static const Color divider = Color(0xFF2A2A2A);

  // Error colors
  static const Color error = Colors.red;
}
