import 'package:dotmeme/route_generator.dart';
import 'package:dotmeme/theme/themes.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dotmeme',
      theme: lightTheme(),
      darkTheme: darkTheme(),
      // TODO: Add settings for this
      themeMode: ThemeMode.dark,
      initialRoute: '/',
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
