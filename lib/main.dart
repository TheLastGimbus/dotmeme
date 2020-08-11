import 'package:dotmeme/background/work_manager_utils.dart';
import 'package:dotmeme/notifications/notifications.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:dotmeme/providers/shared_preferences_provider.dart';
import 'package:dotmeme/route_generator.dart';
import 'package:dotmeme/theme/themes.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  Fimber.plantTree(DebugTree(
    logLevels: ["D", "I", "W", "E", "V"],
    useColors: true,
  ));
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SharedPreferencesProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.microtask(() {
      WorkManagerUtils.initialize();
      Notifications.initializePlugin();
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomePageProvider()),
        ChangeNotifierProvider(create: (_) => MemesProvider()),
      ],
      child: MaterialApp(
        title: 'Dotmeme',
        theme: lightTheme(),
        darkTheme: darkTheme(),
        themeMode: Provider.of<SharedPreferencesProvider>(context).getThemeMode,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
