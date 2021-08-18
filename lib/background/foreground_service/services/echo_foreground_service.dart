import 'dart:async';

import '../events.dart';
import 'the_foreground_service.dart';

/// Sample echo service
/// Used for... debugging, I guess?
class EchoForegroundService implements TheForegroundService {
  final _ctrl = StreamController();
  final _notifyCtrl = StreamController<FServiceNotificationData>();

  @override
  void input(message) {
    _ctrl.sink.add(message);
    _notifyCtrl.add(FServiceNotificationData("Echo", message.toString()));
    // Test of service closing itself
    if (message == "CLOSE") _ctrl.close();
  }

  @override
  Stream get output => _ctrl.stream;

  @override
  Stream<FServiceNotificationData> get notificationUpdates =>
      _notifyCtrl.stream;

  @override
  Future<void> dispose() async {
    await _ctrl.close();
    await _notifyCtrl.close();
  }
}
