import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFF1565C0);
  static const Color primaryDark = Color(0xFF0D47A1);
  static const Color primaryLight = Color(0xFF42A5F5);
  static const Color surface = Color(0xFFF8FAFC);
  static const Color cardBackground = Colors.white;
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF9A825);
  static const Color error = Color(0xFFC62828);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primary,
        primary: primary,
        secondary: primaryLight,
        surface: surface,
        error: error,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: const Color(0xFF1E293B),
        onError: Colors.white,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: surface,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: primary,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: Colors.black26,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: cardBackground,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: error),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: cardBackground,
        selectedItemColor: primary,
        unselectedItemColor: Color(0xFF64748B),
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),
    );
  }
}
