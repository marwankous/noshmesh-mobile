import 'package:flutter/material.dart';

extension AppColorScheme on ColorScheme {
  // Status semantic colors — published/draft/SEO pass-warn-fail indicators.
  // Choosing by brightness so both dark (OLED) and light themes get legible values.
  Color get statusSuccess => brightness == Brightness.dark
      ? const Color(0xFF66BB6A) // Green 400 — legible on #131313
      : const Color(0xFF4CAF50); // Green 500

  Color get statusWarning => brightness == Brightness.dark
      ? const Color(0xFFFFB74D) // Amber 300 — distinct from primary orange
      : const Color(0xFFFF9800); // Orange 500

  Color get statusCritical => error;
}
