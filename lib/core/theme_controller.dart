import 'package:flutter/material.dart';

class ThemeController extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  ThemeData get currentTheme =>
      _themeMode == ThemeMode.light ? lightTheme : darkTheme;

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.light(
      primary: Colors.blue,
      secondary: Colors.amber,
      surface: Colors.white,
      onSurface: Colors.black,
      surfaceContainerHighest: Colors.grey[200]!,
      onSurfaceVariant: Colors.grey[600]!,
    ),
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
    ),
    cardTheme: CardTheme(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );

  final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.dark(
      primary: Colors.blue[800]!,
      secondary: Colors.amber,
      surface: Colors.grey[900]!,
      onSurface: Colors.white,
      surfaceContainerHighest: Colors.grey[800]!,
      onSurfaceVariant: Colors.grey[400]!,
    ),
    primarySwatch: Colors.blue,
    scaffoldBackgroundColor: Colors.grey[900],
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.grey[900],
      foregroundColor: Colors.white,
    ),
    cardTheme: CardTheme(
      color: Colors.grey[800],
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
  );
}
