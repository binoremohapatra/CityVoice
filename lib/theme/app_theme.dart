import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A class that contains all theme configurations for the civic engagement application.
class AppTheme {
  AppTheme._();

  // --- NEW SOFT AESTHETIC PALETTE (Based on provided image) ---

  // Base Identity Colors (Muted and subtle)
  static const Color primaryBlue = Color(0xFF2E3B59); // Dark blue remains for text/icons
  static const Color accentTeal = Color(0xFF4DD0E1); // Light Teal/Aqua for secondary actions (new)
  static const Color accentPink = Color(0xFFFFCCBC); // Soft Pink for tertiary/highlight (new)

  // Core Theme Colors
  static const Color backgroundLight = Color(0xFFF5F7FA); // Very light blue-gray background (Tricolor base)
  static const Color surfaceLight = Color(0xFFFFFFFF); // Pure white surfaces/cards (Glassmorphism base)
  static const Color onSurfaceLight = Color(0xFF212121);
  static const Color onBackgroundLight = Color(0xFF4A4A4A); // Slightly softer dark text
  static const Color errorLight = Color(0xFFD32F2F);

  static const Color backgroundDark = Color(0xFF212121); // Keep dark mode dark
  static const Color surfaceDark = Color(0xFF424242);
  static const Color onSurfaceDark = Color(0xFFF5F5F5);
  static const Color onBackgroundDark = Color(0xFFF5F5F5);
  static const Color errorDark = Color(0xFFEF9A9A);

  // Custom Utility Colors
  static const Color successLight = Color(0xFF66BB6A); // Soft Green
  static const Color warningLight = Color(0xFFFFB74D); // Soft Orange
  static const Color successDark = Color(0xFF81C784);
  static const Color warningDark = Color(0xFFFFD54F);

  // UI Components
  static const Color dialogLight = Color(0xFFFFFFFF);
  static const Color dialogDark = Color(0xFF334155);
  static const Color shadowLight = Color(0x10000000); // More visible shadow
  static const Color shadowDark = Color(0x20000000);

  // *** Colors needed for backward compatibility and various components ***
  static const Color neutralGray = Color(0xFFE0E0E0); // Light gray background
  static const Color neutralGrayDark = Color(0xFF424242); // Darker gray for dark mode

  // Border and divider colors - very light for modern aesthetic
  static const Color borderLight = Color(0xFFE0E0E0);
  static const Color borderDark = Color(0xFF374151);

  // Text colors
  static const Color textPrimaryLight = Color(0xFF212121);
  static const Color textSecondaryLight = Color(0xFF757575);
  static const Color textDisabledLight = Color(0xFFBDBDBD);

  static const Color textPrimaryDark = Color(0xFFF5F5F5);
  static const Color textSecondaryDark = Color(0xFFBDBDBD);
  static const Color textDisabledDark = Color(0xFF64748B);

  /// Light theme optimized for the soft, airy modern look
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: primaryBlue, // Used for important actions/icons
      onPrimary: Colors.white,
      secondary: accentTeal, // Soft secondary action color
      onSecondary: primaryBlue, // Dark text on light accent
      tertiary: accentPink, // Soft tertiary color
      error: errorLight,
      onError: Colors.white,
      surface: surfaceLight,
      onSurface: onSurfaceLight,
      background: backgroundLight,
      onBackground: onBackgroundLight,
      surfaceVariant: textSecondaryLight,
      outline: borderLight, // Light border color
      shadow: shadowLight,
    ),

    scaffoldBackgroundColor: backgroundLight,

    appBarTheme: AppBarTheme(
      backgroundColor: surfaceLight, // White App Bar
      foregroundColor: onBackgroundLight, // Dark icons/text
      elevation: 4, // Subtle elevation
      shadowColor: shadowLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: onBackgroundLight, // App bar text is dark
        letterSpacing: -0.02,
      ),
      iconTheme: IconThemeData(color: onBackgroundLight, size: 24),
      actionsIconTheme: IconThemeData(color: onBackgroundLight, size: 24),
    ),

    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: surfaceLight,
      selectedItemColor: primaryBlue, // Primary icon color
      unselectedItemColor: textDisabledLight,
      type: BottomNavigationBarType.fixed,
      elevation: 8,
      selectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.4,
      ),
      unselectedLabelStyle: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
      ),
    ),

    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surfaceLight,
      indicatorColor: accentTeal.withOpacity(0.2),
      labelTextStyle: MaterialStateProperty.resolveWith((states) {
        final style = GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          color: textSecondaryLight,
          letterSpacing: 0.4,
        );
        if (states.contains(MaterialState.selected)) {
          return style.copyWith(
            fontWeight: FontWeight.w500,
            color: primaryBlue,
          );
        }
        return style;
      }),
      iconTheme: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return const IconThemeData(color: primaryBlue, size: 24);
        }
        return IconThemeData(color: textSecondaryLight, size: 24);
      }),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryBlue, // Dark button for contrast
      foregroundColor: Colors.white,
      elevation: 6.0,
      focusElevation: 8.0,
      hoverElevation: 8.0,
      highlightElevation: 12.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16.0)),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: primaryBlue,
        disabledForegroundColor: textDisabledLight,
        disabledBackgroundColor: neutralGray,
        elevation: 2.0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryBlue,
        disabledForegroundColor: textDisabledLight,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        side: const BorderSide(color: borderLight, width: 1.5), // Lighter border
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue,
        disabledForegroundColor: textDisabledLight,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textStyle: GoogleFonts.inter(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),

    textTheme: _buildTextTheme(isLight: true),

    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceLight,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: borderLight, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: accentTeal, width: 2), // Focus border uses light accent
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorLight, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorLight, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledLight,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorLight,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),

    switchTheme: SwitchThemeData(
      thumbColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryBlue;
        }
        return const Color(0xFFE2E8F0);
      }),
      trackColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryBlue.withOpacity(0.5);
        }
        return neutralGray;
      }),
    ),

    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryBlue;
        }
        return Colors.transparent;
      }),
      checkColor: MaterialStateProperty.all(Colors.white),
      side: const BorderSide(color: borderLight, width: 2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4),
      ),
    ),

    radioTheme: RadioThemeData(
      fillColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.selected)) {
          return primaryBlue;
        }
        return borderLight;
      }),
    ),

    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: primaryBlue,
      linearTrackColor: borderLight,
      circularTrackColor: borderLight,
    ),

    sliderTheme: SliderThemeData(
      activeTrackColor: primaryBlue,
      thumbColor: primaryBlue,
      overlayColor: primaryBlue.withOpacity(0.2),
      inactiveTrackColor: borderLight,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    ),

    tooltipTheme: TooltipThemeData(
      decoration: BoxDecoration(
        color: const Color(0xFF1F2937).withOpacity(0.9),
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: GoogleFonts.inter(
        color: const Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    snackBarTheme: SnackBarThemeData(
      backgroundColor: primaryBlue,
      contentTextStyle: GoogleFonts.inter(
        color: const Color(0xFFFFFFFF),
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      actionTextColor: accentTeal,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),

    chipTheme: ChipThemeData(
      backgroundColor: backgroundLight,
      selectedColor: accentTeal.withOpacity(0.3),
      disabledColor: borderLight.withOpacity(0.5),
      labelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimaryLight,
      ),
      secondaryLabelStyle: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: primaryBlue,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: primaryBlue, // Using City Voice Blue
    scaffoldBackgroundColor: backgroundDark,
    textTheme: GoogleFonts.interTextTheme().apply(
      bodyColor: onSurfaceDark,
      displayColor: onSurfaceDark,
    ),
    colorScheme: ColorScheme.dark(
      primary: primaryBlue, // Using City Voice Blue
      onPrimary: Colors.white,
      secondary: accentTeal, // Using City Voice Orange
      onSecondary: Colors.white,
      tertiary: accentPink, // Using City Voice Purple
      background: backgroundDark,
      onBackground: onBackgroundDark,
      surface: surfaceDark,
      onSurface: onSurfaceDark,
      error: errorDark,
      onError: Colors.white,
      outline: neutralGrayDark, // Uses the newly defined neutralGrayDark
      surfaceVariant: textSecondaryDark,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: primaryBlue, // Using City Voice Blue
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, // Updated for contrast
        backgroundColor: primaryBlue, // Using City Voice Blue
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryBlue, // Using City Voice Blue
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: primaryBlue,
      foregroundColor: Colors.white,
    ),
    inputDecorationTheme: InputDecorationTheme(
      fillColor: surfaceDark,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: neutralGrayDark, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: neutralGrayDark, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: accentTeal, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorDark, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.0),
        borderSide: const BorderSide(color: errorDark, width: 2),
      ),
      labelStyle: GoogleFonts.inter(
        color: textSecondaryDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      hintStyle: GoogleFonts.inter(
        color: textDisabledDark,
        fontSize: 16,
        fontWeight: FontWeight.w400,
      ),
      errorStyle: GoogleFonts.inter(
        color: errorDark,
        fontSize: 12,
        fontWeight: FontWeight.w400,
      ),
    ),
  );

  /// Helper method to build text theme using Inter font family
  static TextTheme _buildTextTheme({required bool isLight}) {
    final Color textPrimary = isLight ? onSurfaceLight : onSurfaceDark;
    final Color textSecondary = isLight ? textSecondaryLight : textSecondaryDark;
    final Color textDisabled = isLight ? textDisabledLight : textDisabledDark;

    return TextTheme(
      // Display styles for large headings
      displayLarge: GoogleFonts.inter(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: -0.25,
        height: 1.12,
      ),
      displayMedium: GoogleFonts.inter(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.16,
      ),
      displaySmall: GoogleFonts.inter(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.22,
      ),

      // Headline styles for section headers
      headlineLarge: GoogleFonts.inter(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.25,
      ),
      headlineMedium: GoogleFonts.inter(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.29,
      ),
      headlineSmall: GoogleFonts.inter(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.33,
      ),

      // Title styles for cards and dialogs
      titleLarge: GoogleFonts.inter(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: 0,
        height: 1.27,
      ),
      titleMedium: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.15,
        height: 1.50,
      ),
      titleSmall: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),

      // Body styles for content
      bodyLarge: GoogleFonts.inter(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.50,
      ),
      bodyMedium: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textPrimary,
        letterSpacing: 0.25,
        height: 1.43,
      ),
      bodySmall: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textSecondary,
        letterSpacing: 0.4,
        height: 1.33,
      ),

      // Label styles for buttons and form elements
      labelLarge: GoogleFonts.inter(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.1,
        height: 1.43,
      ),
      labelMedium: GoogleFonts.inter(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textPrimary,
        letterSpacing: 0.5,
        height: 1.33,
      ),
      labelSmall: GoogleFonts.inter(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: textDisabled,
        letterSpacing: 0.5,
        height: 1.45,
      ),
    );
  }
}
