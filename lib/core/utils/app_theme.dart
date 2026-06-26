import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static const Color _seed = Colors.deepPurple;

  static TextTheme _buildTextTheme(Brightness brightness) {
    final baseTheme = ThemeData(brightness: brightness).textTheme;
    return GoogleFonts.bricolageGrotesqueTextTheme(baseTheme).copyWith(
      displayLarge: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w900, color: brightness == Brightness.light ? Colors.black : Colors.white),
      displayMedium: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w900, color: brightness == Brightness.light ? Colors.black : Colors.white),
      displaySmall: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w900, color: brightness == Brightness.light ? Colors.black : Colors.white),
      headlineLarge: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w900, color: brightness == Brightness.light ? Colors.black : Colors.white),
      headlineMedium: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w800, color: brightness == Brightness.light ? Colors.black : Colors.white),
      headlineSmall: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w800, color: brightness == Brightness.light ? Colors.black : Colors.white),
      titleLarge: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w800, color: brightness == Brightness.light ? Colors.black : Colors.white),
      titleMedium: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.bold, color: brightness == Brightness.light ? Colors.black : Colors.white),
      titleSmall: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.bold, color: brightness == Brightness.light ? Colors.black : Colors.white),
      bodyLarge: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w600),
      bodyMedium: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w500),
      bodySmall: GoogleFonts.bricolageGrotesque(fontWeight: FontWeight.w500),
    );
  }

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor:Colors.purple.shade50 , 
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ).copyWith(
      outline: Colors.black,
    ),
    textTheme: _buildTextTheme(Brightness.light),
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ).copyWith(
      outline: Colors.white,
    ),
    textTheme: _buildTextTheme(Brightness.dark),
  );
}
