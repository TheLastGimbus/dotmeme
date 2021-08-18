import 'dart:async';

import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:moor/moor.dart';

import '../../../analysis/vision/ocr/ocr_scanner.dart';
import '../../../database/media_sync.dart';
import '../../../database/memebase.dart';
import '../../../database/queries.dart';
import '../../../device_media/media_manager.dart';
import '../events.dart';
import 'the_foreground_service.dart';

/// Service that will do all the scanning
/// For now, just OCR
class ScanForegroundService implements TheForegroundService {
  final _db = GetIt.I<Memebase>();
  final _mm = GetIt.I<MediaManager>();
  final _ocr = GetIt.I<OcrScanner>();
  final _log = GetIt.I<Logger>();

  final _ctrl = StreamController();
  final _notifyCtrl = StreamController<FServiceNotificationData>();

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
      yield MemesCompanion(
        id: Value(meme.id),
        scannedText: Value(text),
        textScannerVersion: Value(_ocr.version),
      );
    }
  }

  void _task() async {
    // TODO: Check permission with other plugin
    await _mm.setIgnorePermissionCheck(true);
    _notifyCtrl
        .add(FServiceNotificationData("dotmeme scanning", "Indexing memes..."));
    final deviceFolders = await MediaSync.getMediaFolders();
    await _db.foldersSync(deviceFolders);
    await _db.allFoldersMemeSync(deviceFolders);

    //.watch() watches everything - so it will run each time we call .setText()
    // (omg Native Android PTSD) - so we check if length is same.
    // Of course, this isn't very safe, but it's best we can do and will work
    // 99.999% of times
    int lastLength = -1;
    // Actually - I don't know if re-running allMemes query *every time* is good
    _allMemesStream = _db.allNotScannedMemes.watch().listen((allMemes) {
      if (lastLength == allMemes.length) return;
      lastLength = allMemes.length;
      _scanStream?.cancel();
      _scanStream = scanMemes(allMemes).listen(
        (event) async {
          await _db.setMemeScannedText(
            event.id.value,
            event.scannedText.value!,
            event.textScannerVersion.value!,
          );
          final scanned = await _db.scannedMemesCount;
          // TODO: Emit some states to UI with default stream
          _notifyCtrl.add(FServiceNotificationData(
            "dotmeme scanning",
            "$scanned/${allMemes.length}",
          ));
        },
        onDone: () async {
          await _allMemesStream.cancel();
          await _ctrl.close();
        },
      );
    });
  }

  @override
  void input(message) {
    _log.d("(SFS) Received message: $message");
  }

  @override
  Stream get output => _ctrl.stream;

  @override
  Stream<FServiceNotificationData> get notificationUpdates =>
      _notifyCtrl.stream;

  @override
  Future<void> dispose() async {
    await _allMemesStream.cancel();
    await _scanStream?.cancel();
    await _ctrl.close();
    await _notifyCtrl.close();
  }
}
