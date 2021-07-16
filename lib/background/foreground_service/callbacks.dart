/// This file contains static global functions that will be passed to the plugin
///
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
import 'the_foreground_services.dart';

void echoServiceCallback() {
  _setupService(EchoForegroundService());
}

void scanServiceCallback() {
  _setupService(ScanForegroundService());
}

/// This functions sets everything up for given [service]
/// - lifecycle, communication with ui, etc
void _setupService(TheForegroundService service) {
  if (!di.isInitialized) {
    // We are in different isolate
    di.init(di.Environment.prod);
  }
  final log = GetIt.I<Logger>();
  ReceivePort? receivePort;
  FlutterForegroundTask.initDispatcher(
    (timestamp) async {
      // If not null then we're already set up
      if (receivePort != null) return;
      log.d("Initializing $service in foreground service");

      /// Send message to ui - returns false if port not found
      bool send(dynamic message) {
        final uiPort = IsolateNameServer.lookupPortByName(
            ForegroundServiceManager.uiPortName);
        if (uiPort != null) {
          uiPort.send(message);
          return true;
        } else {
          return false;
        }
      }

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

      // Pipe all received data to service
      // Logging and debugging etc is up to it, not here
      receivePort!.listen(service.input);

      // Don't worry, those will be closed with scanFService.dispose()
      service.output.listen(send);
      service.notificationUpdates.listen((event) {
        FlutterForegroundTask.update(
            notificationTitle: event.title, notificationText: event.text);
      });
    },
    onDestroy: (timestamp) async {
      await service.dispose();
      IsolateNameServer.removePortNameMapping(
          ForegroundServiceManager.servicePortName);
      receivePort?.close(); // This will also close all StreamSubscriptions
      log.d("Foreground service with $service was closed");
    },
  );
}
