import 'package:dotmeme/background/foreground_service/foreground_service_manager.dart';
import 'package:dotmeme/database/media_sync.dart';
import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/queries.dart';
import 'package:dotmeme/di.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

void main() {
  group("Scan foreground service", () {
    /// memeId <-> text that ocr is expected to spit out
    const _texts = {
      437854092489234: " \n\f",
      1315402535634264:
          "Me leaving the apple\nstore with an Ban\n12 in my mouth:\n\na\n\n \n\f",
    };

    test("basic check if memes are being scanned", () async {
      di.init(di.Environment.test);
      // Init stuff and enable "Reddit"
      final db = GetIt.I<Memebase>();
      final deviceFolders = await MediaSync.getMediaFolders();
      await db.foldersSync(deviceFolders);
      await db.setFolderEnabled(
        (await db.allFolders.get()).firstWhere((f) => f.name == "Reddit").id,
        true,
      );

      final fsm = GetIt.I<ForegroundServiceManager>();
      await fsm.startScanService();
      await fsm.receiveStream.listen((event) {}).asFuture();

      for (final m in await db.allMemes.get()) {
        expect(m.scannedText, _texts[m.id]);
      }
    });
  });
}
