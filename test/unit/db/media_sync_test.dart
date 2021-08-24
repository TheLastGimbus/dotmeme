import 'dart:io';

import 'package:dotmeme/database/media_sync.dart';
import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/queries.dart';
import 'package:dotmeme/device_media/media_manager.dart';
import 'package:dotmeme/di.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:photo_manager/photo_manager.dart';

final getIt = GetIt.I;

void main() {
  late Logger log;
  final universeBegin = DateTime(1970);
  late Memebase db;
  late MediaManager mm;
  late List<AssetPathEntity> mediaPaths;
  setUp(() async {
    di.init(di.Environment.test);
    log = getIt<Logger>();
    db = getIt<Memebase>();
    mm = getIt<MediaManager>();
    await mm.requestPermissionExtend();
    mediaPaths = await MediaSync.getMediaFolders();
  });
  tearDown(() async {
    await getIt.reset();
  });

  /// This simultaneously tests if MediaSync works, but also if
  /// MockMediaManager is correctly parsing our test media repo
  /// (and if you've set it up correctly too!)
  group("Test syncing media from MediaManager to the database", () {
    /// Test if folders are good, have correct lastModified values and are
    /// properly sorted
    test("Folder sync", () async {
      await db.foldersSync(mediaPaths);
      final dbFolders = await db.allFolders.get();

      expect(
        dbFolders.map((e) => e.copyWith(lastModified: e.lastModified.toUtc())),
        [
          _folder(6654389, "Screenshots", false, _utc(2021, 07, 10, 20, 55, 32),
              universeBegin),
          _folder(254352, "Camera", false, _utc(2021, 07, 09, 17, 56, 27),
              universeBegin),
          _folder(876683, "Reddit", false, _utc(2021, 07, 09, 11, 34, 00),
              universeBegin),
        ],
      );
    });

    /// Sync folders and *all* memes (even not enabled), and asserts that all
    /// memes are there, in correct order
    test("All folders meme sync", () async {
      await db.foldersSync(mediaPaths);
      await db.allFoldersMemeSync(mediaPaths);

      // await db.foldersSync(mediaPaths);
      final allMemes = await db.allMemesLiteral.get();

      expect(
        allMemes.map((e) => e.copyWith(lastModified: e.lastModified.toUtc())),
        [
          _meme(4535342543728950, 6654389, 0, _utc(2021, 07, 10, 20, 55, 32)),
          _meme(34594327968326643, 6654389, 0, _utc(2021, 07, 10, 20, 54, 30)),
          _meme(4805385390543, 254352, 0, _utc(2021, 07, 09, 17, 56, 27)),
          _meme(1315402535634264, 876683, 0, _utc(2021, 07, 09, 11, 34, 00)),
          _meme(437854092489234, 876683, 0, _utc(2021, 07, 09, 10, 34, 00))
        ],
      );
    });

    /// Sync only enabled folders and assert that .allMemesLiteral spits out
    /// only memes and not everything (the sync actually skips not enabled)
    test("Enabled folders (Reddit) meme sync", () async {
      final memeStream = db.allMemesLiteral.watch();
      expect(
        memeStream.map((e) =>
            e.map((e) => e.copyWith(lastModified: e.lastModified.toUtc()))),
        emitsInOrder([
          [], // First there are no memes
          [], // Then Reddit is enabled but not synced yet
          [
            _meme(1315402535634264, 876683, 0, _utc(2021, 07, 09, 11, 34, 00)),
            _meme(437854092489234, 876683, 0, _utc(2021, 07, 09, 10, 34, 00))
          ], // And then after sync here they are
        ]),
      );
      await db.foldersSync(mediaPaths);
      await db.setFolderEnabled(
        (await db.allFolders.get()).firstWhere((f) => f.name == "Reddit").id,
        true,
      );
      await db.enabledFoldersMemeSync(mediaPaths);
      await Future.delayed(const Duration(milliseconds: 1)); // ¯\_(ツ)_/¯
    });

    // I know this is kinda dependent on machine, but I think running them 50
    // times is enough to be sure that one is faster :ok_hand:
    // Note: All other aspects of skipIfNotModified and it's potential bugs
    // should be already covered in other tests :ok_hand:
    test("skipIfNotModified=true is faster", () async {
      await db.foldersSync(mediaPaths);
      await db.allFoldersMemeSync(mediaPaths);
      final w = Stopwatch()..start();
      for (final _ in Iterable.generate(50)) {
        await db.allFoldersMemeSync(mediaPaths);
      }
      final skipped = w.elapsedMilliseconds;

      w.reset();
      for (final _ in Iterable.generate(50)) {
        await db.allFoldersMemeSync(mediaPaths, skipIfNotModified: false);
      }
      final notSkipped = w.elapsedMilliseconds;

      log.d("skipped: $skipped ; notSkipped: $notSkipped");
      expect(skipped < notSkipped, true);
    });

    /// Test if file watchers are watching :eyes:
    test("File watchers", () async {
      final memeStream = db.allMemesLiteral.watch();
      expect(
        memeStream.map((e) =>
            e.map((e) => e.copyWith(lastModified: e.lastModified.toUtc()))),
        emitsInOrder([
          [], // Initial nothingness
          [], // Pure folder-sync
          [
            _meme(1315402535634264, 876683, 0, _utc(2021, 07, 09, 11, 34, 00)),
            _meme(437854092489234, 876683, 0, _utc(2021, 07, 09, 10, 34, 00)),
          ], // Reddit sync triggered by watchers
        ]),
      );
      await db.foldersSync(mediaPaths);
      await db.setupFileWatchers(mediaPaths);
      // Get filesystem folder
      final redditFolder = (await (await mediaPaths
                  .firstWhere((f) => f.name == "Reddit")
                  .getAssetListRange(start: 0, end: 1))
              .first
              .file)!
          .parent;
      // Create a dummy file to trigger watchers
      final dummy = File(p.join(redditFolder.path, 'dummy.txt'));
      await dummy.exists() ? await dummy.delete() : await dummy.create();
      // Wait as much as watcher's buffer waits for "no more events" + margin
      // WTF: This for some reason takes real 3 seconds
      // Maybe fix it with some fake_async or something :/
      await Future.delayed(
          MediaSync.fileWatcherBufferWait + const Duration(seconds: 1));

      await db.closeFileWatchers();
      if (await dummy.exists()) await dummy.delete(); // Cleanup
      // Necessary bloat :/ but takes only ~60ms tho
      await Process.run("python3", [
        "scripts/_set_correct_test_media_timestamps.py",
        "test/_test_media"
      ]);
    });
  });
}

// Boilerplate helpers
_meme(int id, int folderId, int memeType, DateTime lastModified,
        [String? scannedText]) =>
    Meme(
      id: id,
      folderId: folderId,
      memeType: memeType,
      lastModified: lastModified,
      scannedText: scannedText,
    );

_folder(int id, String name, bool scanningEnabled, DateTime lastModified,
        DateTime lastSync) =>
    Folder(
      id: id,
      name: name,
      scanningEnabled: scanningEnabled,
      lastModified: lastModified,
      lastSync: lastSync,
    );

_utc(
  int year, [
  int month = 1,
  int day = 1,
  int hour = 0,
  int minute = 0,
  int second = 0,
  int millisecond = 0,
  int microsecond = 0,
]) =>
    DateTime.utc(
        year, month, day, hour, minute, second, millisecond, microsecond);
