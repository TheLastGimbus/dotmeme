/// This file contains classes of different types of service, so you can easily
/// use one, or the other :)
///
/// Note that those are plugin-independent, so they can easily be tested!
///
import 'dart:async';

import '../events.dart';

/// *Abstract* class to hold the concept of *foreground service*
/// Basically, I'm re-writing the Android API in Dart :sunglasses:
abstract class TheForegroundService {
  /// Anything that you want service to hear
  void input(dynamic message);

  /// Anything the service wants to say
  /// When this finishes, that means service is all done and can be closed
  Stream get output;

  Stream<FServiceNotificationData> get notificationUpdates;

  /// Pack your stuff
  Future<void> dispose();
}
