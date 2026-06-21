import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  // Hero (dark section)
  static const Color heroBackground    = Color(0xFF1D2B2C);
  static const Color heroBlobA         = Color(0xFF2E4A40);
  static const Color heroBlobB         = Color(0xFF749080);
  static const Color heroAccent        = Color(0xFFC8BC88);
  static const Color heroText          = Color(0xFFF0EAE0);
  static const Color heroTextSecondary = Color(0xFF8A9890);

  // App background
  static const Color background    = Color(0xFFFDFAF6);
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF1D2B2C);
  static const Color textSecondary = Color(0xFF8A9890);
  static const Color divider       = Color(0xFFEDE4D8);

  // Feature colors
  static const Color fitness     = Color(0xFFE2CAC0);
  static const Color fitnessDark = Color(0xFF4A2018);
  static const Color diet        = Color(0xFFB8C4D4);
  static const Color dietDark    = Color(0xFF1A2848);
  static const Color beauty      = Color(0xFF9DB0A4);
  static const Color beautyDark  = Color(0xFF1A3028);
  static const Color todo             = Color(0xFFD8CE9C);
  static const Color todoDark         = Color(0xFF3A2E08);
  static const Color supplement       = Color(0xFFD4C8E0);
  static const Color supplementDark   = Color(0xFF3A2458);

  // Aliases for backward compat (used in many screens)
  static const Color lavender     = Color(0xFF9DB0A4);
  static const Color lavenderDark = Color(0xFF1A3028);
  static const Color peach        = Color(0xFFE2CAC0);
  static const Color peachDark    = Color(0xFF4A2018);
  static const Color mint         = Color(0xFF9DB0A4);
  static const Color mintDark     = Color(0xFF1A3028);
  static const Color blush        = Color(0xFFB8C4D4);
  static const Color blushDark    = Color(0xFF1A2848);
  static const Color sky          = Color(0xFFB8C4D4);
  static const Color cream        = Color(0xFFFDFAF6);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.heroBlobB,
        brightness: Brightness.light,
        surface: AppColors.surface,
      ),
      scaffoldBackgroundColor: AppColors.background,
      textTheme: GoogleFonts.poppinsTextTheme().copyWith(
        displayLarge: GoogleFonts.poppins(
          fontSize: 32,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        displayMedium: GoogleFonts.poppins(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        headlineMedium: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleLarge: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        titleMedium: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        bodyLarge: GoogleFonts.poppins(
          fontSize: 16,
          color: AppColors.textPrimary,
        ),
        bodyMedium: GoogleFonts.poppins(
          fontSize: 14,
          color: AppColors.textSecondary,
        ),
        labelLarge: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.background,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
        ),
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.lavenderDark,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: GoogleFonts.poppins(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.divider),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.lavenderDark, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
