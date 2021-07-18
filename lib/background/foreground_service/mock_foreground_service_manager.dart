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
  Future<bool> startEchoService() async {
    // Matching real behavior
    if (_currentService != null) return true;
    _currentService = EchoForegroundService();
    _currentService!.output.listen(_receiveStreamCtrl.sink.add);
    return true;
  }

  @override
  Future<bool> startScanService() async {
    // Matching real behavior
    if (_currentService != null) return true;
    _currentService = ScanForegroundService();
    _currentService!.output.pipe(_receiveStreamCtrl);
    return true;
  }

  @override
  Future<void> stopService() async {
    await _currentService?.dispose();
    _currentService = null;
  }
}
