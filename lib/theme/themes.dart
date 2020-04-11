import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    primaryColorLight: Colors.cyanAccent,
    primaryColorDark: Colors.indigo,
    accentColor: Colors.orange,
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    primaryColorLight: Colors.cyanAccent,
    primaryColorDark: Colors.indigo,
    accentColor: Colors.orange,
  );
}
