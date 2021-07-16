import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import '_foreground_service.dart' as fservice;

class ForegroundServiceManager {
  static String uiPortName = "ui_isolate_port";
  static String servicePortName = "foreground_service_isolate_port";

  final _receivePort = ReceivePort(uiPortName);

  SendPort? get _serviceSendPort =>
      IsolateNameServer.lookupPortByName(servicePortName);

  ForegroundServiceManager() {
    // If .dispose() wasn't called properly
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
      callback: fservice.mainCallback,
    );
    // We need to wait a little for service to connect
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

  /// You *probably* can not call this, but it would be a lot cooler if you did
  Future<void> dispose() async {
    IsolateNameServer.removePortNameMapping(uiPortName);
    _receivePort.close();
  }
}
