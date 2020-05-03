import 'package:dotmeme/notifications/notifications.dart';

class PeriodicScan {
  static const TASK_ID = 'periodic_scan';

  static void backgroundScan(String taskId) async {
    print("IMMM SCANNINGGGGG (not really)");
    Notifications.showExampleNotification();
  }
}
