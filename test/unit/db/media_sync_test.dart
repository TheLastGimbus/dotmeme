import 'package:dotmeme/database/media_sync.dart';
import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/queries.dart';
import 'package:dotmeme/device_media/media_manager.dart';
import 'package:dotmeme/di.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.I;

void main() {
  /// This simultaneously tests if MediaSync works, but also if
  /// MockMediaManager is correctly parsing our test media repo
  /// (and if you've set it up correctly too!)
  // All of those should be able to run in independently in random order
  // - so please use `await getIt.reset()` at the end of each one
  group("Test syncing media from MediaManager to the database", () {
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
    _folder(int id, String name, bool scanningEnabled, DateTime lastModified) =>
        Folder(
          id: id,
          name: name,
          scanningEnabled: scanningEnabled,
          lastModified: lastModified,
        );

    /// Test if folders are good, have correct lastModified values and are
    /// properly sorted
    test("Folder sync", () async {
      // This is also boilerplate that will repeat for most test in this group
      di.init(di.Environment.test);
      final db = getIt<Memebase>();
      final mm = getIt<MediaManager>();

      await mm.requestPermissionExtend();
      final mediaPaths = await MediaSync.getMediaFolders();

      await db.foldersSync(mediaPaths);
      final dbFolders = await db.allFolders.get();

      expect(
        dbFolders,
        [
          _folder(6654389, "Screenshots", false,
              DateTime(2021, 07, 10, 22, 55, 32)),
          _folder(254352, "Camera", false, DateTime(2021, 07, 09, 19, 56, 27)),
          _folder(876683, "Reddit", false, DateTime(2021, 07, 09, 13, 34, 00)),
        ],
      );
      // Reset DI (mainly db) after each test
      await getIt.reset();
    });

    /// Sync folders and *all* memes (even not enabled), and asserts that all
    /// memes are there, in correct order
    test("All folders meme sync", () async {
      di.init(di.Environment.test);
      final db = getIt<Memebase>();
      final mm = getIt<MediaManager>();
      await mm.requestPermissionExtend();
      final mediaPaths = await MediaSync.getMediaFolders();
      await db.foldersSync(mediaPaths);
      await db.allFoldersMemeSync(mediaPaths);

      // await db.foldersSync(mediaPaths);
      final allMemes = await db.allMemesLiteral.get();

      expect(allMemes, [
        _meme(4535342543728950, 6654389, 0, DateTime(2021, 07, 10, 22, 55, 32)),
        _meme(
            34594327968326643, 6654389, 0, DateTime(2021, 07, 10, 22, 54, 30)),
        _meme(4805385390543, 254352, 0, DateTime(2021, 07, 09, 19, 56, 27)),
        _meme(1315402535634264, 876683, 0, DateTime(2021, 07, 09, 13, 34, 00)),
        _meme(437854092489234, 876683, 0, DateTime(2021, 07, 09, 12, 34, 00))
      ]);

      await getIt.reset();
    });

    /// Sync only enabled folders and assert that .allMemesLiteral spits out
    /// only memes and not everything (the sync actually skips not enabled)
    test("Enabled folders (Reddit) meme sync", () async {
      di.init(di.Environment.test);
      final db = getIt<Memebase>();
      final mm = getIt<MediaManager>();
      await mm.requestPermissionExtend();
      final mediaPaths = await MediaSync.getMediaFolders();
      await db.foldersSync(mediaPaths);
      final memeStream = db.allMemesLiteral.watch();
      expect(
        memeStream,
        emitsInOrder([
          [], // First there are no memes
          [], // Then Reddit is enabled but not synced yet
          [
            _meme(1315402535634264, 876683, 0,
                DateTime(2021, 07, 09, 13, 34, 00)),
            _meme(
                437854092489234, 876683, 0, DateTime(2021, 07, 09, 12, 34, 00))
          ], // And then after sync here they are
        ]),
      );
      await db.setFolderEnabled(
        (await db.allFolders.get()).firstWhere((f) => f.name == "Reddit").id,
        true,
      );
      await db.enabledFoldersMemeSync(mediaPaths);

      await getIt.reset();
    });
  });
}
