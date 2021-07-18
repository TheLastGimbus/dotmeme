import 'dart:async';

import 'package:mockito/mockito.dart';

import 'foreground_service_manager.dart';
import 'the_foreground_services.dart';

/// Mock that actually runs everything normally, just on same isolate
// Maybe if I would launch stuff on new isolate (don't know how Dart test would
// like it :/ ), we could also use it in production where foreground service
// is not available
class MockForegroundServiceManager extends Mock
    implements ForegroundServiceManager {
  final _receiveStreamCtrl = StreamController();

  TheForegroundService? _currentService;

  MockForegroundServiceManager() {
    receiveStream = _receiveStreamCtrl.stream.asBroadcastStream();
  }

  @override
  late final Stream receiveStream;

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
    _currentService!.output.pipe(_receiveStreamCtrl);
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
