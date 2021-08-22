import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:async/async.dart';
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

  /// Logic that decides how many threads we will use
  /// Currently, uses half of available processors
  // In future, it may use some SharedPreferences or other fancy stuff
  int _getThreadsNumber() {
    return max(1, Platform.numberOfProcessors ~/ 2);
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
    _allMemesStream = _db.allNotScannedMemes
        .watch()
        .where((e) => e.length != lastLength)
        .listen((notScannedMemes) {
      lastLength = notScannedMemes.length;
      _scanStream?.cancel();

      final divided = lastLength == 0
          ? [<Meme>[]]
          // Prevent dividing to more than there's elements
          : notScannedMemes.divideToParts(min(lastLength, _getThreadsNumber()));

      _scanStream =
          StreamGroup.merge([for (final sub in divided) scanMemes(sub)]).listen(
        (event) async {
          // The count will decrease when we do setText()
          lastLength--;
          await _db.setMemeScannedText(
            event.id.value,
            event.scannedText.value!,
            event.textScannerVersion.value!,
          );
          // TODO: Emit some states to UI with default stream
          final allCount = await _db.allMemesCount;
          _notifyCtrl.add(FServiceNotificationData(
            "dotmeme scanning",
            "${allCount - lastLength}/$allCount - $lastLength left",
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

extension _Util<E> on List<E> {
  /// Divides list to smaller list, but divided like "every N-th",
  /// not .sublist()
  /// This way, if you have ordered list, items will be more evenly spread:
  /// ```dart
  /// var list = [1, 2, 3, 4, 5, 6, 7, 8];
  /// list.divideToParts(2);
  /// >>> [[1, 3, 5, 7], [2, 4, 6, 8]]
  /// // But also:
  /// list.divideToParts(3);
  /// >>> [[1, 4], [2, 5], [3, 6, 7, 8]]
  /// ```
  /// ...you get what I mean
  /// It took me 2 hours to write this beauty <3
  List<List<E>> divideToParts(int parts) {
    assert(parts <= length);
    final normalSize = length ~/ parts;
    final rest = length % parts;
    final lastSize = normalSize + rest;
    return List.generate(
      parts,
      (listN) => List.generate(
        listN == parts - 1 ? lastSize : normalSize,
        (i) {
          // Offset index (every N-th)
          var idx = listN + (i * parts);
          // If it's out of range, than we proceed to pick up the rest normally
          if (idx >= length) {
            // Iterate over last left (unevenly cut) values
            var newI = i - normalSize;
            idx = (length - rest) + newI;
          }
          return this[idx];
        },
      ),
    );
  }
}
