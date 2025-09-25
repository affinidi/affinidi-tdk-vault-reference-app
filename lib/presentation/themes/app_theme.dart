import 'package:flutter/material.dart';

import 'app_color_scheme.dart';

class AppTheme {
  static final colorScheme = AppColorScheme.light;

  static final light = ThemeData(
    useMaterial3: true,
    colorScheme: colorScheme,
    fontFamily: 'Figtree',
    progressIndicatorTheme: ProgressIndicatorThemeData(
      color: colorScheme.primary,
      circularTrackColor: colorScheme.primaryContainer,
    ),
    textTheme: const TextTheme(
      // Caption styles
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.normal,
      ),

      // Body styles
      bodySmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.normal,
      ),

      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.normal,
      ),

      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),

      // Button styles
      labelLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.25,
        letterSpacing: 0.6,
      ),

      // Heading styles
      titleSmall: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
      ),

      titleMedium: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w800,
        letterSpacing: -0.2,
      ),

      titleLarge: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        height: 1.0,
        letterSpacing: -0.2,
      ),

      headlineMedium: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        height: 1.05,
        letterSpacing: -0.4,
      ),
    ),
  );

  // Legacy static accessors for backward compatibility during migration

  static const TextStyle headingMedium = TextStyle(
    fontFamily: 'Figtree',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    color: AppColorScheme.textPrimary,
  );

  static const TextStyle dialogTitle = TextStyle(
    fontFamily: 'Figtree',
    fontSize: 20,
    fontWeight: FontWeight.w800,
    letterSpacing: -0.2,
    color: AppColorScheme.textPrimary,
  );

  static const TextStyle headingLarge = TextStyle(
    fontFamily: 'Figtree',
    fontSize: 24,
    fontWeight: FontWeight.w800,
    color: AppColorScheme.textPrimary,
  );

  static const TextStyle heading = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w800,
    fontFamily: 'Figtree',
    height: 1.0,
    letterSpacing: -0.2,
  );

  static const TextStyle headingXLarge = TextStyle(
    fontFamily: 'Figtree',
    fontSize: 40,
    fontWeight: FontWeight.w800,
    height: 1.05,
    letterSpacing: -0.4,
    color: AppColorScheme.textPrimary,
  );

  // Keep the old main theme for backward compatibility
  static final main = light;
}
