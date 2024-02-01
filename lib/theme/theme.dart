import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    cardTheme: CardTheme(color: Colors.blue.shade400),
    colorScheme: ColorScheme.light(
      primary: Colors.blue.shade400,
    ));
ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    cardTheme: CardTheme(color: Colors.blue.shade900),
    colorScheme: ColorScheme.dark(
      primary: Colors.blue.shade900,
    ));
