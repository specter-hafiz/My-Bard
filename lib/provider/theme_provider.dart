import 'package:flutter/material.dart';
import 'package:my_pa/theme/theme.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightTheme;
  ThemeData get themeData => _themeData;

  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  toggleTheme() {
    if (_themeData == lightTheme) {
      themeData = darkTheme;
    } else {
      themeData = lightTheme;
    }
  }
}
