import 'package:flutter/material.dart';

ThemeData lightTheme() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    primaryColorLight: Colors.cyanAccent,
    primaryColorDark: Colors.indigo,
    accentColor: Colors.orange,
    textTheme: TextTheme(body1: TextStyle(fontSize: 16)),
  );
}

ThemeData darkTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    primaryColorLight: Colors.cyanAccent,
    primaryColorDark: Colors.indigo,
    accentColor: Colors.orange,
    textTheme: TextTheme(body1: TextStyle(fontSize: 16)),
  );
}
