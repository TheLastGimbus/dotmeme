import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Notifications {
  static initializePlugin() {
    FlutterLocalNotificationsPlugin().initialize(InitializationSettings(
      AndroidInitializationSettings('ic_launcher'),
      IOSInitializationSettings(),
    ));
  }

  static showNotification(String title, String text) {
    FlutterLocalNotificationsPlugin().show(
      1,
      title,
      text,
      NotificationDetails(
        AndroidNotificationDetails(
          'examples',
          'Examples',
          'This is just throwaway channel',
        ),
        IOSNotificationDetails(),
      ),
    );
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
      ),
    );
  }
}
