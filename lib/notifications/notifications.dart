import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static initializePlugin() {
    FlutterLocalNotificationsPlugin().initialize(InitializationSettings(
      AndroidInitializationSettings('ic_launcher'),
      IOSInitializationSettings(),
    ));
  }

  static showExampleNotification() {
    FlutterLocalNotificationsPlugin().show(
        0,
        'Example',
        'This is example notification',
        NotificationDetails(
          AndroidNotificationDetails(
            'examples',
            'Examples',
            'This is just throwaway channel',
          ),
          IOSNotificationDetails(),
        ));
  }
}
