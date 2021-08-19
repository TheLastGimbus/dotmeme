import 'dart:async';

import 'package:mockito/mockito.dart';

import 'foreground_service_manager.dart';
import 'services/echo_foreground_service.dart';
import 'services/scan_foreground_service.dart';
import 'services/the_foreground_service.dart';

/// Mock that actually runs everything normally, just on same isolate
// Maybe if I would launch stuff on new isolate (don't know how Dart test would
// like it :/ ), we could also use it in production where foreground service
// is not available
class MockForegroundServiceManager extends Mock
    implements ForegroundServiceManager {
  final _receiveStreamCtrl = StreamController.broadcast();

  TheForegroundService? _currentService;

  @override
  Stream get receiveStream => _receiveStreamCtrl.stream;

  @override
  Future<void> dispose() async {
    await _currentService?.dispose();
    await _receiveStreamCtrl.close();
  }

  @override
  bool send(message) {
    if (_currentService != null) {
      _currentService!.input(message);
      return true;
    } else {
      return false;
    }
  }

  @override
  Future<bool> startEchoService() =>
      _startService(() => EchoForegroundService());

  @override
  Future<bool> startScanService() =>
      _startService(() => ScanForegroundService());

  Future<bool> _startService(TheForegroundService Function() create) async {
    // Matching real behavior
    if (_currentService != null) return true;
    _currentService = create();
    // Pipe output to receiveStream (without piping "closed" event)
    // and clear the service when it ends
    _currentService!.output.listen(
      _receiveStreamCtrl.add,
      onDone: () {
        _receiveStreamCtrl.add(null);
        _currentService = null;
      },
    );
    // WTF: Streams need to be listened to to close nicely later
    // They are very needy
    _currentService!.notificationUpdates.listen(null);
    return true;
  }

  @override
  Future<void> stopService() async {
    await _currentService?.dispose();
    _currentService = null;
  }
}
