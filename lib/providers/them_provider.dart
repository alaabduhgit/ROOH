// import 'package:flutter/material.dart';

// class ThemeProvider with ChangeNotifier {
//   ThemeMode _themeMode = ThemeMode.light;

//   ThemeMode get themeMode => _themeMode;

//   bool get isDarkMode {
//     return _themeMode == ThemeMode.dark;
//   }

//   void setThemeMode(ThemeMode themeMode) {
//     if (_themeMode == themeMode) return;

//     _themeMode = themeMode;
//     notifyListeners();
//   }

//   void toggleTheme() {
//     _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
//     notifyListeners();
//   }
// }
