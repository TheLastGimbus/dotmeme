import 'dart:isolate';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

void method() async {
  FlutterForegroundTask.initDispatcher(
    (timestamp) async {
      print('yay: ${Isolate.current.debugName} : ${Isolate.current.hashCode}');
      await FlutterForegroundTask.update(
          notificationTitle: "dotmeme scannin",
          notificationText: timestamp.second.toString());
    },
    onDestroy: (timestamp) async {
      print('onDestroy D:');
    },
  );
  // await Stream.periodic(Duration(seconds: 1)).listen((event) {
  //   print('yaayyy ${DateTime.now().second}');
  // }).asFuture();
}

Future<void> startService() async {
  await FlutterForegroundTask.init(
    notificationOptions: const NotificationOptions(
      channelId: 'test',
      channelName: 'Test channel',
    ),
    foregroundTaskOptions: const ForegroundTaskOptions(interval: 5000),
    printDevLog: true,
  );
  await FlutterForegroundTask.start(
    notificationTitle: "dotmeme scanning",
    notificationText: "1/100",
    callback: method,
  );
}

Future<void> stopService() async {
  await FlutterForegroundTask.stop();
}
