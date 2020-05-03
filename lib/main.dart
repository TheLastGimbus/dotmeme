import 'package:dotmeme/background/work_manager_utils.dart';
import 'package:dotmeme/notifications/notifications.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:dotmeme/route_generator.dart';
import 'package:dotmeme/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => HomePageProvider()),
          ChangeNotifierProvider(create: (_) => MemesProvider()),
        ],
        child: MyApp(),
      ),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      WorkManagerUtils.initialize();
      Notifications.initializePlugin();
    });

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
