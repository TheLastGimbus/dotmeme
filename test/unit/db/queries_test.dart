import 'package:dotmeme/database/media_sync.dart';
import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/queries.dart';
import 'package:dotmeme/device_media/media_manager.dart';
import 'package:dotmeme/di.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.I;

void main() {
  group("Very basic queries", () {
    test("count queries", () async {
      di.init(di.Environment.test);
      final db = getIt<Memebase>();
      final mm = getIt<MediaManager>();
      await mm.requestPermissionExtend();
      final mediaPaths = await MediaSync.getMediaFolders();
      await db.foldersSync(mediaPaths);
      await db.allFoldersMemeSync(mediaPaths);

      // There is no memes
      expect(await db.allMemesCount, 0);
      expect(await db.scannedMemesCount, 0);
      await db.setMemeScannedText(1315402535634264, "Pre-set text :)", -1);
      // It's still 0 because folder is not enabled
      expect(await db.scannedMemesCount, 0);

      // Enable folder - 2 memes and 1 is scanned
      await db.setFolderEnabled(
        (await db.allFolders.get()).firstWhere((f) => f.name == "Reddit").id,
        true,
      );
      expect(await db.allMemesCount, 2);
      expect(await db.scannedMemesCount, 1);

      // Set all texts
      for (final meme in await db.allMemes.get()) {
        await db.setMemeScannedText(meme.id, "Pre-set text :)", -1);
      }
      expect(await db.scannedMemesCount, 2);

      // Disable folder - back to 0
      await db.setFolderEnabled(
        (await db.allFolders.get()).firstWhere((f) => f.name == "Reddit").id,
        false,
      );
      expect(await db.allMemesCount, 0);
      expect(await db.scannedMemesCount, 0);

      // Dispose db and stuff
      await getIt.reset();
    });
  });
}
