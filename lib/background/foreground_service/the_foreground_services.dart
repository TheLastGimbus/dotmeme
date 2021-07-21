/// This file contains classes of different types of service, so you can easily
/// use one, or the other :)
///
/// Note that those are plugin-independent, so they can easily be tested!
///
import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:moor/moor.dart';

import '../../analysis/vision/ocr/ocr_scanner.dart';
import '../../database/media_sync.dart';
import '../../database/memebase.dart';
import '../../database/queries.dart';
import '../../device_media/media_manager.dart';

// Note: if we, some day, for some reason, want to start other services
// from other services (one gets the job done, but wants the other to finish it)
// (idk why we would want this), it seems like the current plugin supports
// something like this - we would need to change this class a bit...
// Tho I think, running multiple services *inside* other big daddy service
// - they are plugin independent! we can just pipe their streams into
// each other! - would be a better idea...
/// Just a little class to hold info for notification
class _NotificationData {
  final String title;
  final String text;

  _NotificationData(this.title, this.text);
}

/// *Abstract* class to hold the concept of *foreground service*
/// Basically, I'm re-writing the Android API in Dart :sunglasses:
abstract class TheForegroundService {
  /// Anything that you want service to hear
  void input(dynamic message);

  /// Anything the service wants to say
  /// When this finishes, that means service is all done and can be closed
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
    // Test of service closing itself
    if (message == "CLOSE") _ctrl.close();
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
  final _db = GetIt.I<Memebase>();
  final _mm = GetIt.I<MediaManager>();
  final _ocr = GetIt.I<OcrScanner>();
  final _log = GetIt.I<Logger>();

  final _ctrl = StreamController();
  final _notifyCtrl = StreamController<_NotificationData>();

  late final StreamSubscription _allMemesStream;
  StreamSubscription? _scanStream;

  ScanForegroundService() {
    _task();
  }

  Stream<MemesCompanion> scanMemes(Iterable<Meme> memes) async* {
    for (final meme in memes) {
      final ass = await _mm.assetEntityFromId(meme.id.toString());
      final file = await ass?.file;
      if (file == null) {
        _log.e("$meme returned null file - skipping scan");
        continue;
      }
      String? text;
      try {
        text = await _ocr.scan(file);
      } catch (e) {
        _log.e("Scanning $meme threw error: $e");
      }
      if (text == null) continue;
      yield MemesCompanion(id: Value(meme.id), scannedText: Value(text));
    }
  }

  void _task() async {
    // TODO: Check permission with other plugin
    await _mm.setIgnorePermissionCheck(true);
    _notifyCtrl.add(_NotificationData("dotmeme scanning", "Indexing memes..."));
    final deviceFolders = await MediaSync.getMediaFolders();
    await _db.foldersSync(deviceFolders);
    await _db.allFoldersMemeSync(deviceFolders);

    _allMemesStream = _db.allMemes.watch().listen((allMemes) {
      _scanStream?.cancel();
      // Scan oldest memes first
      _scanStream = scanMemes(allMemes.reversed).listen(
        (event) async {
          await _db.setMemeScannedText(
              event.id.value, event.scannedText.value!);
          final scanned = await _db.scannedMemesCount;
          _notifyCtrl.add(_NotificationData(
            "dotmeme scanning",
            "$scanned/${allMemes.length}",
          ));
        },
        onDone: _allMemesStream.cancel,
      );
    });

    await _allMemesStream.asFuture();

    await _ctrl.close();
  }

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
    await _allMemesStream.cancel();
    await _scanStream?.cancel();
    await _ctrl.close();
    await _notifyCtrl.close();
  }
}
