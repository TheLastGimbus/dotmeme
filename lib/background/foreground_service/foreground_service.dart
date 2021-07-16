import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../di.dart' as di;

void _mainCallback() {
  ReceivePort? receivePort;
  FlutterForegroundTask.initDispatcher(
    (timestamp) async {
      if (receivePort != null) return;
      if (!di.isInitialized) {
        di.init(di.Environment.prod);
      }
      final log = GetIt.I<Logger>();
      log.d("Initializing ForegroundService");
      receivePort = ReceivePort(ForegroundServiceManager.servicePortName);
      receivePort!.listen((message) async {
        log.i("Received from service: $message");
        await FlutterForegroundTask.update(
          notificationTitle: "Receiving messages - last one:",
          notificationText: message.toString(),
        );
      });
      IsolateNameServer.registerPortWithName(
          receivePort!.sendPort, ForegroundServiceManager.servicePortName);
    },
    onDestroy: (timestamp) async {
      receivePort?.close(); // This will also close all StreamSubscriptions
    },
  );
}

class ForegroundServiceManager {
  static String uiPortName = "ui_isolate_port";
  static String servicePortName = "foreground_service_isolate_port";

  // TODO: Stream/Sink abstraction
  final _receivePort = ReceivePort(uiPortName);

  SendPort? get _serviceSendPort =>
      IsolateNameServer.lookupPortByName(servicePortName);

  /// Returns true if starting and connecting to service was successful or it
  /// already existed (meaning service is running and connected now)
  /// False when not (meaning service is not running)
  Future<bool> startService() async {
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
      callback: _mainCallback,
    );
    final conn = _serviceSendPort;
    if (conn != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> stopService() async {
    await FlutterForegroundTask.stop();
  }
}
