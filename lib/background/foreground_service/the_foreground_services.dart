/// This file contains classes of different types of service, so you can easily
/// use one, or the other :)
///
/// Note that those are plugin-independent, so they can easily be tested!
///
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

/// Just a little class to hold info for notification
class _NotificationData {
  final String title;
  final String text;

  _NotificationData(this.title, this.text);
}

/// *Abstract* class to hold the concept of *foreground service*
/// Basically, I'm re-writing the Android API in Dart :sunglasses:
// TODO: Notification update
abstract class TheForegroundService {
  /// Anything that you want service to hear
  void input(dynamic message);

  /// Anything the service wants to say
  Stream get output;

  Stream<_NotificationData> get notificationUpdates;

  /// Pack your stuff
  Future<void> dispose();
}

/// Sample echo service
/// Used for... debugging, I guess?
class EchoForegroundService implements TheForegroundService {
  final _ctrl = StreamController();
  final _notifyCtrl = StreamController<_NotificationData>();

  @override
  void input(message) {
    _ctrl.sink.add(message);
    _notifyCtrl.add(_NotificationData("Echo", message.toString()));
  }

  @override
  Stream get output => _ctrl.stream;

  @override
  Stream<_NotificationData> get notificationUpdates => _notifyCtrl.stream;

  @override
  Future<void> dispose() async {
    await _ctrl.close();
    await _notifyCtrl.close();
  }
}

/// Service that will do all the scanning
/// For now, just OCR
// TODO: OCR scanning
class ScanForegroundService implements TheForegroundService {
  final _log = GetIt.I<Logger>();

  final _ctrl = StreamController();
  final _notifyCtrl = StreamController<_NotificationData>();

  @override
  void input(message) {
    _log.d("(SFS) Received message: $message");
  }

  @override
  Stream get output => _ctrl.stream;

  @override
  Stream<_NotificationData> get notificationUpdates => _notifyCtrl.stream;

  @override
  Future<void> dispose() async {
    await _ctrl.close();
    await _notifyCtrl.close();
  }
}
