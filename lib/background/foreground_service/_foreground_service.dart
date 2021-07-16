/// Everything in this file should be accessed only by
/// [ForegroundServiceManager] !!!
///
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../di.dart' as di;
import 'foreground_service_manager.dart';

// TODO: Shrink this as much as possible and move everything to
//  plugin-independent code (maybe another class with streams?)
void mainCallback() {
  ReceivePort? receivePort;
  FlutterForegroundTask.initDispatcher(
    (timestamp) async {
      if (receivePort != null) return;
      if (!di.isInitialized) {
        di.init(di.Environment.prod);
      }
      final log = GetIt.I<Logger>();
      log.d("(FService) Initializing ForegroundService");

      // Register the port for communication with UI
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
        log.d("(FService) received from ui: $message");

        // Do some logic here

        // Basic echo for testing
        if (message is String && message.startsWith("ECHO")) {
          final uiPort = IsolateNameServer.lookupPortByName(
              ForegroundServiceManager.uiPortName);
          if (uiPort != null) {
            uiPort.send(message);
          } else {
            log.e("(FService) UI Port not found when doing echo!");
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
