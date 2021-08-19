import 'dart:async';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'callbacks.dart' as callbacks;

class ForegroundServiceManager {
  static String uiPortName = "ui_isolate_port";
  static String servicePortName = "foreground_service_isolate_port";

  final _receivePort = ReceivePort(uiPortName);

  SendPort? get _serviceSendPort =>
      IsolateNameServer.lookupPortByName(servicePortName);

  ForegroundServiceManager() {
    receiveStream = _receivePort.asBroadcastStream();
    // If .dispose() wasn't called properly
    if (IsolateNameServer.lookupPortByName(uiPortName) != null) {
      IsolateNameServer.removePortNameMapping(uiPortName);
    }
    IsolateNameServer.registerPortWithName(_receivePort.sendPort, uiPortName);
  }

  /// Stream with data that service sent to ui
  ///
  /// It just directly pipes output of current service - except, when it closes,
  /// it emits a null instead of closing itself too - thus, please do not emit
  /// nulls when implementing [TheForegroundService] yourself :)
  late final Stream receiveStream;

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

  /// Waits 15 seconds for service to connect, then returns false
  Future<bool> _serviceConnected() async {
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

  /// Returns true if starting and connecting to service was successful or it
  /// already existed (meaning service is running and connected now)
  /// False when not (meaning service is not running)
  ///
  /// Note that some other service (not one you want) may be running and this
  /// still returns true.
  // IDEA: Maybe some way to check what type of service is running?
  Future<bool> startScanService() async {
    if (_serviceSendPort != null) return true;
    await FlutterForegroundTask.init(
      androidNotificationOptions: const AndroidNotificationOptions(
        channelId: "foreground_service.scan",
        channelName: "Scanning service",
        channelDescription: "Foreground service that scans memes",
        channelImportance: NotificationChannelImportance.LOW,
        priority: NotificationPriority.LOW,
        playSound: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: const ForegroundTaskOptions(interval: 5000),
      printDevLog: true,
    );
    await FlutterForegroundTask.start(
      notificationTitle: "dotmeme is scanning memes",
      notificationText: "Syncing...",
      callback: callbacks.scanServiceCallback,
    );
    return _serviceConnected();
  }

  Future<bool> startEchoService() async {
    if (_serviceSendPort != null) return true;
    await FlutterForegroundTask.init(
      androidNotificationOptions: const AndroidNotificationOptions(
        channelId: "foreground_service.echo",
        channelName: "Echo service",
        channelDescription: "Sample debug service that echos everything",
        channelImportance: NotificationChannelImportance.DEFAULT,
        priority: NotificationPriority.DEFAULT,
        playSound: false,
      ),
      iosNotificationOptions: const IOSNotificationOptions(),
      foregroundTaskOptions: const ForegroundTaskOptions(interval: 5000),
      printDevLog: true,
    );
    await FlutterForegroundTask.start(
      notificationTitle: "Echo service",
      notificationText: "Waiting for first message...",
      callback: callbacks.echoServiceCallback,
    );
    return _serviceConnected();
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
