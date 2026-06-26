import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract final class AppTheme {
  static const Color _seed = Colors.deepPurple;

  static TextTheme get _lightTextTheme =>
      GoogleFonts.bricolageGrotesqueTextTheme(
        ThemeData(brightness: Brightness.light).textTheme,
      );

  static TextTheme get _darkTextTheme =>
      GoogleFonts.bricolageGrotesqueTextTheme(
        ThemeData(brightness: Brightness.dark).textTheme,
      );

  static ThemeData get light => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.light,
    ),
    textTheme: _lightTextTheme,
  );

  static ThemeData get dark => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: _seed,
      brightness: Brightness.dark,
    ),
    textTheme: _darkTextTheme,
  );
}
