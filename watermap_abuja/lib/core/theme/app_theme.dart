import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  AppColors._();
  static const Color primary = Color(0xFF0A84FF);
  static const Color primaryDark = Color(0xFF5E5CE6);
  static const Color success = Color(0xFF1FA971);
  static const Color warning = Color(0xFFE8A400);
  static const Color danger = Color(0xFFE5484D);
  static const Color background = Color(0xFFF3F2EF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceElevated = Color(0xFFFDFDFC);
  static const Color textPrimary = Color(0xFF17181C);
  static const Color textSecondary = Color(0xFF6B6D76);
  static const Color textTertiary = Color(0xFF9A9CA5);
  static const Color border = Color(0xFFE8E7E2);
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0A84FF), Color(0xFF5E5CE6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Soft drop shadow used across cards, buttons and banners to replace
  /// flat borders with a gentle sense of elevation.
  static List<BoxShadow> softShadow({double opacity = 0.06}) => [
        BoxShadow(
          color: const Color(0xFF17181C).withOpacity(opacity),
          blurRadius: 24,
          offset: const Offset(0, 8),
        ),
      ];
}

class AppTextStyles {
  AppTextStyles._();
  static TextStyle get displayLarge => GoogleFonts.inter(
      fontSize: 40,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.8,
      height: 1.05);
  static TextStyle get displayMedium => GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.6,
      height: 1.1);
  static TextStyle get displaySmall => GoogleFonts.inter(
      fontSize: 26, fontWeight: FontWeight.w700, letterSpacing: -0.4);
  static TextStyle get headlineLarge =>
      GoogleFonts.inter(fontSize: 22, fontWeight: FontWeight.w700);
  static TextStyle get headlineMedium =>
      GoogleFonts.inter(fontSize: 18, fontWeight: FontWeight.w700);
  static TextStyle get headlineSmall =>
      GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w700);
  static TextStyle get bodyLarge =>
      GoogleFonts.inter(fontSize: 17, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodyMedium =>
      GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get bodySmall =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w400, height: 1.5);
  static TextStyle get labelLarge =>
      GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600);
  static TextStyle get labelMedium =>
      GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600);
  static TextStyle get labelSmall => GoogleFonts.inter(
      fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.3);
}

class AppTheme {
  AppTheme._();
  static ThemeData get light => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.primary,
          surface: AppColors.surface,
          error: AppColors.danger,
          onPrimary: Colors.white,
          onSurface: AppColors.textPrimary,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: AppColors.background,
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          titleTextStyle: AppTextStyles.headlineMedium
              .copyWith(color: AppColors.textPrimary),
          iconTheme: const IconThemeData(color: AppColors.textPrimary),
        ),
        cardTheme: CardThemeData(
          color: AppColors.surface,
          elevation: 0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          margin: EdgeInsets.zero,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            minimumSize: const Size(double.infinity, 58),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            textStyle: AppTextStyles.headlineSmall,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18),
              borderSide: const BorderSide(color: AppColors.primary, width: 2)),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          hintStyle:
              AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        dividerTheme:
            const DividerThemeData(color: AppColors.border, thickness: 1),
      );

  /// Kept for compatibility with anything still referencing the old name.
  static ThemeData get dark => light;
}
