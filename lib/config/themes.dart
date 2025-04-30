import 'package:flutter/material.dart';

class AppThemes {
  // Light Theme Colors
  static const Color _lightPrimaryColor = Color(0xFF1565C0);
  static const Color _lightSecondaryColor = Color(0xFF2196F3);
  static const Color _lightBackgroundColor = Color(0xFFFAFAFA);
  static const Color _lightErrorColor = Color(0xFFD32F2F);
  static const Color _lightSurfaceColor = Color(0xFFFFFFFF);
  static const Color _lightTextColor = Color(0xFF212121);
  static const Color _lightTextSecondaryColor = Color(0xFF757575);
  
  // Dark Theme Colors
  static const Color _darkPrimaryColor = Color(0xFF1976D2);
  static const Color _darkSecondaryColor = Color(0xFF42A5F5);
  static const Color _darkBackgroundColor = Color(0xFF121212);
  static const Color _darkErrorColor = Color(0xFFEF5350);
  static const Color _darkSurfaceColor = Color(0xFF1E1E1E);
  static const Color _darkTextColor = Color(0xFFE0E0E0);
  static const Color _darkTextSecondaryColor = Color(0xFFB0B0B0);
  
  // Custom App Colors
  static const Color successColor = Color(0xFF4CAF50);
  static const Color warningColor = Color(0xFFFFC107);
  static const Color infoColor = Color(0xFF03A9F4);
  static const Color dangerColor = Color(0xFFF44336);
  
  // Light Theme
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.light,
        primary: _lightPrimaryColor,
        onPrimary: Colors.white,
        secondary: _lightSecondaryColor,
        onSecondary: Colors.white,
        error: _lightErrorColor,
        onError: Colors.white,
        background: _lightBackgroundColor,
        onBackground: _lightTextColor,
        surface: _lightSurfaceColor,
        onSurface: _lightTextColor,
      ),
      scaffoldBackgroundColor: _lightBackgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: _lightPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _lightTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        headlineMedium: TextStyle(
          color: _lightTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        headlineSmall: TextStyle(
          color: _lightTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        titleLarge: TextStyle(
          color: _lightTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        bodyLarge: TextStyle(
          color: _lightTextColor,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        bodyMedium: TextStyle(
          color: _lightTextColor,
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
        labelLarge: TextStyle(
          color: _lightTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: _lightPrimaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _lightPrimaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: _lightPrimaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _lightPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _lightSurfaceColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightErrorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _lightErrorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: _lightTextSecondaryColor),
        hintStyle: TextStyle(color: Colors.grey.shade400),
      ),
      fontFamily: 'Poppins',
    );
  }
  
  // Dark Theme
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme(
        brightness: Brightness.dark,
        primary: _darkPrimaryColor,
        onPrimary: Colors.white,
        secondary: _darkSecondaryColor,
        onSecondary: Colors.white,
        error: _darkErrorColor,
        onError: Colors.white,
        background: _darkBackgroundColor,
        onBackground: _darkTextColor,
        surface: _darkSurfaceColor,
        onSurface: _darkTextColor,
      ),
      scaffoldBackgroundColor: _darkBackgroundColor,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        color: _darkSurfaceColor,
        iconTheme: IconThemeData(color: _darkTextColor),
        titleTextStyle: TextStyle(
          color: _darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
      ),
      textTheme: const TextTheme(
        headlineLarge: TextStyle(
          color: _darkTextColor,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        headlineMedium: TextStyle(
          color: _darkTextColor,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        headlineSmall: TextStyle(
          color: _darkTextColor,
          fontSize: 20,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins',
        ),
        titleLarge: TextStyle(
          color: _darkTextColor,
          fontSize: 18,
          fontWeight: FontWeight.w600,
          fontFamily: 'Poppins',
        ),
        bodyLarge: TextStyle(
          color: _darkTextColor,
          fontSize: 16,
          fontFamily: 'Poppins',
        ),
        bodyMedium: TextStyle(
          color: _darkTextColor,
          fontSize: 14,
          fontFamily: 'Poppins',
        ),
        labelLarge: TextStyle(
          color: _darkTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
        ),
      ),
      buttonTheme: ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: _darkPrimaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: _darkPrimaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          side: const BorderSide(color: _darkPrimaryColor),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      cardTheme: CardTheme(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: _darkSurfaceColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Color(0xFF2C2C2C),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade700),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkPrimaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkErrorColor, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: _darkErrorColor, width: 2),
        ),
        labelStyle: const TextStyle(color: _darkTextSecondaryColor),
        hintStyle: TextStyle(color: Colors.grey.shade600),
      ),
      fontFamily: 'Poppins',
    );
  }
} 