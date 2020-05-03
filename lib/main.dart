import 'package:background_fetch/background_fetch.dart';
import 'package:dotmeme/background/periodic_scan.dart';
import 'package:dotmeme/notifications/notifications.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:dotmeme/route_generator.dart';
import 'package:dotmeme/theme/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    BackgroundFetch.scheduleTask(TaskConfig(
      taskId: PeriodicScan.TASK_ID,
      delay: 0,
      stopOnTerminate: false,
      periodic: true,
      requiresBatteryNotLow: true,
    ));

    Future.microtask((){
      Notifications.initializePlugin();
      PeriodicScan.backgroundScan(PeriodicScan.TASK_ID);
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
        // TODO: Add settings for this
        themeMode: ThemeMode.dark,
        initialRoute: '/',
        onGenerateRoute: RouteGenerator.generateRoute,
      ),
    );
  }
}
