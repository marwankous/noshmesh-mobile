import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── noshmesh Unified — dark palette ────────────────────────────────────────
  static const _dBackground           = Color(0xFF131313);
  static const _dSurfaceContainer     = Color(0xFF201F1F);
  static const _dSurfaceContainerHigh = Color(0xFF2A2A2A);
  static const _dSurfaceContainerHighest = Color(0xFF353534);
  static const _dSurfaceContainerLow  = Color(0xFF1C1B1B);
  static const _dOnSurface            = Color(0xFFE5E2E1);
  static const _dOnSurfaceVariant     = Color(0xFFE4BEB4);
  static const _dOutline              = Color(0xFFAB8980);
  static const _dOutlineVariant       = Color(0xFF5B4039);
  static const _dError                = Color(0xFFFFB4AB);
  static const _dOnError              = Color(0xFF690005);
  static const _dErrorContainer       = Color(0xFF93000A);

  // ── Shared ────────────────────────────────────────────────────────────────
  static const _orange  = Color(0xFFFF5722);
  static const _onOrange = Color(0xFF5F1500);
  static const _white   = Color(0xFFFFFFFF);

  // ── Light palette (unchanged) ─────────────────────────────────────────────
  static const _lSurface          = Color(0xFFFFFFFF);
  static const _lSurfaceContainer = Color(0xFFF4F4F5);
  static const _lSurfaceHigh      = Color(0xFFE4E4E7);
  static const _lOnSurface        = Color(0xFF09090B);
  static const _lOnSurfaceVariant = Color(0xFF71717A);
  static const _lOutline          = Color(0xFFE4E4E7);
  static const _lError            = Color(0xFFEF4444);

  // ── Text themes ───────────────────────────────────────────────────────────
  static TextTheme _darkTextTheme() => GoogleFonts.hankenGroteskTextTheme(
        ThemeData.dark().textTheme,
      ).copyWith(
        displayLarge: GoogleFonts.hankenGrotesk(
            fontSize: 28, fontWeight: FontWeight.w700,
            height: 36 / 28, color: _dOnSurface),
        headlineMedium: GoogleFonts.hankenGrotesk(
            fontSize: 20, fontWeight: FontWeight.w600,
            height: 28 / 20, color: _dOnSurface),
        titleSmall: GoogleFonts.hankenGrotesk(
            fontSize: 16, fontWeight: FontWeight.w600,
            height: 24 / 16, color: _dOnSurface),
        bodyLarge: GoogleFonts.hankenGrotesk(
            fontSize: 16, fontWeight: FontWeight.w400,
            height: 24 / 16, color: _dOnSurface),
        bodyMedium: GoogleFonts.hankenGrotesk(
            fontSize: 14, fontWeight: FontWeight.w400,
            height: 20 / 14, color: _dOnSurface),
        labelMedium: GoogleFonts.hankenGrotesk(
            fontSize: 12, fontWeight: FontWeight.w500,
            height: 16 / 12, letterSpacing: 0.5, color: _dOnSurface),
        bodySmall: GoogleFonts.hankenGrotesk(
            fontSize: 13, fontWeight: FontWeight.w400,
            height: 18 / 13, color: _dOnSurfaceVariant),
      );

  static TextTheme _lightTextTheme() => GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.inter(
            fontSize: 20, fontWeight: FontWeight.w700,
            letterSpacing: -0.5, color: _lOnSurface),
        headlineMedium: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w700,
            letterSpacing: -0.3, color: _lOnSurface),
        titleSmall: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w600,
            letterSpacing: -0.1, color: _lOnSurface),
        bodyLarge: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w400, color: _lOnSurface),
        bodyMedium: GoogleFonts.inter(
            fontSize: 14, fontWeight: FontWeight.w400, color: _lOnSurface),
        labelMedium: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w500,
            letterSpacing: 0.5, color: _lOnSurfaceVariant),
        bodySmall: GoogleFonts.inter(
            fontSize: 12, fontWeight: FontWeight.w400, color: _lOnSurfaceVariant),
        labelSmall: GoogleFonts.inter(
            fontSize: 11, fontWeight: FontWeight.w600,
            letterSpacing: 0.5, color: _lOnSurfaceVariant),
      );

  // ── Shared ThemeData builder ───────────────────────────────────────────────
  static ThemeData _base({
    required Brightness brightness,
    required ColorScheme colorScheme,
    required TextTheme textTheme,
    required double cardRadius,
    required BorderSide cardBorder,
  }) {
    final primary = colorScheme.primary;
    final onSurface = colorScheme.onSurface;
    final onSurfaceVariant = colorScheme.onSurfaceVariant;
    final outline = colorScheme.outline;
    final surfaceContainerHigh = colorScheme.surfaceContainerHigh;

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: colorScheme.surface,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: colorScheme.surface,
        foregroundColor: onSurface,
        surfaceTintColor: Colors.transparent,
        iconTheme: IconThemeData(color: onSurface, size: 24),
        titleTextStyle: textTheme.displayLarge,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primary,
          foregroundColor: brightness == Brightness.dark ? _onOrange : _white,
          minimumSize: const Size(double.infinity, 52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: brightness == Brightness.dark
              ? GoogleFonts.hankenGrotesk(fontWeight: FontWeight.w600, fontSize: 16)
              : GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: onSurface,
          minimumSize: const Size(double.infinity, 52),
          side: BorderSide(color: outline),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainerHigh,
        hintStyle: TextStyle(color: onSurfaceVariant),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(cardRadius),
          side: cardBorder,
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colorScheme.surfaceContainer,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: colorScheme.surface,
        height: 64,
        indicatorColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return brightness == Brightness.dark
              ? GoogleFonts.hankenGrotesk(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: selected ? primary : onSurfaceVariant)
              : GoogleFonts.inter(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: selected ? primary : onSurfaceVariant);
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          return IconThemeData(
            color: selected ? primary : onSurfaceVariant,
            size: 24,
          );
        }),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: brightness == Brightness.dark ? _onOrange : _white,
      ),
      dividerTheme: DividerThemeData(
        thickness: 1,
        color: outline,
        space: 1,
      ),
      listTileTheme: ListTileThemeData(
        iconColor: onSurfaceVariant,
        titleTextStyle: brightness == Brightness.dark
            ? GoogleFonts.hankenGrotesk(
                fontSize: 14, fontWeight: FontWeight.w500, color: onSurface)
            : GoogleFonts.inter(
                fontSize: 14, fontWeight: FontWeight.w500, color: onSurface),
      ),
    );
  }

  // ── Public themes ─────────────────────────────────────────────────────────
  static ThemeData get darkTheme => _base(
    brightness: Brightness.dark,
    textTheme: _darkTextTheme(),
    cardRadius: 16,
    cardBorder: BorderSide.none,
    colorScheme: const ColorScheme.dark(
      primary: _orange,
      onPrimary: _onOrange,
      primaryContainer: _orange,
      onPrimaryContainer: _onOrange,
      secondary: Color(0xFFC8C6C5),
      onSecondary: Color(0xFF303030),
      secondaryContainer: Color(0xFF474746),
      onSecondaryContainer: Color(0xFFB7B5B4),
      surface: _dBackground,
      surfaceContainer: _dSurfaceContainer,
      surfaceContainerHigh: _dSurfaceContainerHigh,
      surfaceContainerHighest: _dSurfaceContainerHighest,
      surfaceContainerLow: _dSurfaceContainerLow,
      onSurface: _dOnSurface,
      onSurfaceVariant: _dOnSurfaceVariant,
      outline: _dOutline,
      outlineVariant: _dOutlineVariant,
      error: _dError,
      onError: _dOnError,
      errorContainer: _dErrorContainer,
      onErrorContainer: Color(0xFFFFDAD6),
      inverseSurface: _dOnSurface,
      onInverseSurface: Color(0xFF313030),
      inversePrimary: Color(0xFFB02F00),
      surfaceTint: Color(0xFFFFB5A0),
      scrim: Colors.black,
      shadow: Colors.black,
    ),
  );

  static ThemeData get lightTheme => _base(
    brightness: Brightness.light,
    textTheme: _lightTextTheme(),
    cardRadius: 8,
    cardBorder: const BorderSide(color: _lOutline),
    colorScheme: const ColorScheme.light(
      primary: _orange,
      onPrimary: _white,
      surface: _lSurface,
      surfaceContainer: _lSurfaceContainer,
      surfaceContainerHigh: _lSurfaceHigh,
      surfaceContainerHighest: Color(0xFFD4D4D8),
      onSurface: _lOnSurface,
      onSurfaceVariant: _lOnSurfaceVariant,
      outline: _lOutline,
      secondary: _lOnSurfaceVariant,
      onSecondary: _white,
      error: _lError,
      onError: _white,
    ),
  );
}
