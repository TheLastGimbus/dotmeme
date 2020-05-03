import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static initializePlugin() {
    FlutterLocalNotificationsPlugin().initialize(InitializationSettings(
      AndroidInitializationSettings('ic_launcher.png'),
      IOSInitializationSettings(),
    ));
  }

  var plugin = FlutterLocalNotificationsPlugin();
}
