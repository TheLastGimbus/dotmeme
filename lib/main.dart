import 'package:flutter/material.dart';

import 'ui/common/theme/theme.dart' as theme;
import 'ui/pages/home/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: theme.lightTheme,
      home: HomePage(),
    );
  }
}