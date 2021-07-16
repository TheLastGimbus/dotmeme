import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../di.dart' as di;

// TODO: Shrink this as much as possible and move everything to
//  plugin-independent code (maybe another class with streams?)
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
      // If, for some weird reason, it wasn't un-registered
      if (IsolateNameServer.lookupPortByName(
              ForegroundServiceManager.servicePortName) !=
          null) {
        IsolateNameServer.removePortNameMapping(
            ForegroundServiceManager.servicePortName);
      }
      IsolateNameServer.registerPortWithName(
          receivePort!.sendPort, ForegroundServiceManager.servicePortName);
      receivePort!.listen((message) async {
        log.i("(Service) received from ui: $message");
        await FlutterForegroundTask.update(
          notificationTitle: "Receiving messages - last one:",
          notificationText: message.toString(),
        );
        if (message is String && message.startsWith("ECHO")) {
          final uiPort = IsolateNameServer.lookupPortByName(
              ForegroundServiceManager.uiPortName);
          if (uiPort != null) {
            uiPort.send(message);
          } else {
            log.w("(Service) UI Port not found!");
          }
        }
      });
    },
    onDestroy: (timestamp) async {
      IsolateNameServer.removePortNameMapping(
          ForegroundServiceManager.servicePortName);
      receivePort?.close(); // This will also close all StreamSubscriptions
    },
  );
}

class ForegroundServiceManager {
  static String uiPortName = "ui_isolate_port";
  static String servicePortName = "foreground_service_isolate_port";

  final _receivePort = ReceivePort(uiPortName);

  SendPort? get _serviceSendPort =>
      IsolateNameServer.lookupPortByName(servicePortName);

  ForegroundServiceManager() {
    if (IsolateNameServer.lookupPortByName(uiPortName) != null) {
      IsolateNameServer.removePortNameMapping(uiPortName);
    }
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, uiPortName);
  }

  /// Stream with data that service sent to ui
  Stream get receiveStream => _receivePort;

  /// Sends a message to Service. Returns true if service is up and message was
  /// sent, false otherwise
  bool send(dynamic message) {
    if (_serviceSendPort != null) {
      _serviceSendPort!.send(message);
      return true;
    } else {
      return false;
    }
  }

  /// Returns true if starting and connecting to service was successful or it
  /// already existed (meaning service is running and connected now)
  /// False when not (meaning service is not running)
  Future<bool> startService() async {
    if (_serviceSendPort != null) return true;
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
    try {
      await Stream.periodic(
        const Duration(milliseconds: 50),
        (_) => _serviceSendPort != null,
      ).firstWhere((e) => e).timeout(const Duration(seconds: 15));
      return true;
    } on TimeoutException catch (_) {
      return false;
    }
  }

  Future<void> stopService() async {
    await FlutterForegroundTask.stop();
  }

  Future<void> dispose() async {
    IsolateNameServer.removePortNameMapping(uiPortName);
    _receivePort.close();
  }
}
