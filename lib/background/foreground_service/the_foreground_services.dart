/// This file contains classes of different types of service, so you can easily
/// use one, or the other :)
///
/// Note that those are plugin-independent, so they can easily be tested!
///
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

/// *Abstract* class to hold the concept of *foreground service*
/// Basically, I'm re-writing the Android API in Dart :sunglasses:
// TODO: Notification update
abstract class TheForegroundService {
  /// Anything that you want service to hear
  void input(dynamic message);

  /// Anything the service wants to say
  Stream get output;

  /// Pack your stuff
  Future<void> dispose();
}

/// Sample echo service
/// Used for... debugging, I guess?
class EchoForegroundService implements TheForegroundService {
  @override
  Future<void> dispose() async {}

  @override
  void input(message) {
    _ctrl.sink.add(message);
  }

  final StreamController _ctrl = StreamController();

  @override
  Stream get output => _ctrl.stream;
}

/// Service that will do all the scanning
/// For now, just OCR
// TODO: OCR scanning
class ScanForegroundService implements TheForegroundService {
  final _log = GetIt.I<Logger>();

  @override
  void input(message) {
    _log.d("(SFS) Received message: $message");
  }

  final StreamController _outputCtrl = StreamController();

  @override
  Stream get output => _outputCtrl.stream;

  @override
  Future<void> dispose() async {
    await _outputCtrl.close();
  }
}
