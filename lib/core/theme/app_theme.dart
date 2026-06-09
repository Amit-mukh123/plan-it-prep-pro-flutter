import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Primary
  static const primary = Color(0xFF22C55E);
  static const primaryDark = Color(0xFF16A34A);
  static const primaryContainer = Color(0xFFDCFCE7);

  // Secondary
  static const secondary = Color(0xFF0EA5E9);
  static const secondaryContainer = Color(0xFFE0F2FE);

  // Backgrounds
  static const bg = Color(0xFFFAFAFA);
  static const surface = Color(0xFFFFFFFF);
  static const surfaceVariant = Color(0xFFF3F4F6);
  static const surface2 = Color(0xFFF8F9FA);

  // Borders
  static const outline = Color(0xFFE5E7EB);
  static const outlineStrong = Color(0xFFD1D5DB);

  // Text
  static const textPrimary = Color(0xFF111827);
  static const textSecondary = Color(0xFF6B7280);
  static const textTertiary = Color(0xFF9CA3AF);

  // Semantic
  static const error = Color(0xFFDC2626);
  static const errorContainer = Color(0xFFFEE2E2);
  static const success = Color(0xFF16A34A);
  static const warning = Color(0xFFF59E0B);
  static const warningContainer = Color(0xFFFEF3C7);

  // Nutrition badge colors
  static const calBg = Color(0xFFFEF3C7);
  static const calText = Color(0xFFB45309);
  static const proBg = Color(0xFFEDE9FE);
  static const proText = Color(0xFF6D28D9);
  static const carbBg = Color(0xFFE0F2FE);
  static const carbText = Color(0xFF0369A1);
  static const fatBg = Color(0xFFFFE4E6);
  static const fatText = Color(0xFFBE123C);
}

class AppTheme {
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.bg,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          primaryContainer: AppColors.primaryContainer,
          secondary: AppColors.secondary,
          secondaryContainer: AppColors.secondaryContainer,
          surface: AppColors.surface,
          error: AppColors.error,
        ),
        textTheme: GoogleFonts.dmSansTextTheme().copyWith(
          displayLarge: GoogleFonts.dmSerifDisplay(
            fontSize: 32,
            height: 1.2,
            color: AppColors.textPrimary,
          ),
          headlineMedium: GoogleFonts.dmSans(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          headlineSmall: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleLarge: GoogleFonts.dmSans(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          titleMedium: GoogleFonts.dmSans(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          bodyLarge: GoogleFonts.dmSans(
            fontSize: 15,
            color: AppColors.textPrimary,
            height: 1.5,
          ),
          bodyMedium: GoogleFonts.dmSans(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.5,
          ),
          bodySmall: GoogleFonts.dmSans(
            fontSize: 12,
            color: AppColors.textTertiary,
          ),
          labelMedium: GoogleFonts.dmSans(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.05,
            color: AppColors.textSecondary,
          ),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.bg,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
          titleTextStyle: GoogleFonts.dmSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          iconTheme:
              const IconThemeData(color: AppColors.textPrimary, size: 22),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          shadowColor: Colors.black.withValues(alpha: 0.07),
        ),
        dividerTheme: const DividerThemeData(
          color: AppColors.outline,
          thickness: 1,
          space: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.outlineStrong, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.outlineStrong, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide:
                const BorderSide(color: AppColors.primary, width: 1.5),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          labelStyle:
              GoogleFonts.dmSans(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: const StadiumBorder(),
            minimumSize: const Size(double.infinity, 48),
            textStyle: GoogleFonts.dmSans(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primaryDark,
            side: const BorderSide(color: AppColors.outlineStrong, width: 1.5),
            shape: const StadiumBorder(),
            minimumSize: const Size(double.infinity, 48),
            textStyle: GoogleFonts.dmSans(
                fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? Colors.white
                  : Colors.white),
          trackColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.primary
                  : AppColors.outlineStrong),
          trackOutlineColor:
              WidgetStateProperty.all(Colors.transparent),
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: AppColors.surface,
          selectedItemColor: AppColors.primaryDark,
          unselectedItemColor: AppColors.textSecondary,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      );
}
