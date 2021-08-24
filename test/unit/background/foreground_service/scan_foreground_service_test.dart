import 'package:dotmeme/analysis/vision/ocr/terminal_ocr_scanner.dart';
import 'package:dotmeme/background/foreground_service/foreground_service_manager.dart';
import 'package:dotmeme/database/media_sync.dart';
import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/queries.dart';
import 'package:dotmeme/di.dart' as di;
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:photo_manager/photo_manager.dart';

void main() {
  late Memebase db;
  late List<AssetPathEntity> deviceFolders;
  // Sets up full database with memes synced and Reddit enabled
  setUp(() async {
    di.init(di.Environment.test);
    db = GetIt.I<Memebase>();
    deviceFolders = await MediaSync.getMediaFolders();
    await db.foldersSync(deviceFolders);
    await db.allFoldersMemeSync(deviceFolders);
    await db.setFolderEnabled(
      (await db.allFolders.get()).firstWhere((f) => f.name == "Reddit").id,
      true,
    );
  });
  tearDown(() async {
    await GetIt.I.reset();
  });
  group("ScanForegroundService", () {
    /// memeId <-> text that ocr is expected to spit out
    const _texts = {
      437854092489234: " \n\f",
      1315402535634264:
          "Me leaving the apple\nstore with an Ban\n12 in my mouth:\n\na\n\n \n\f",
    };
    late ForegroundServiceManager fsm;
    setUp(() => fsm = GetIt.I<ForegroundServiceManager>());
    tearDown(() async => await fsm.dispose());

    test("basic check if memes are being scanned", () async {
      await fsm.startScanService();
      await fsm.receiveStream.firstWhere((e) => e == null);

      for (final m in await db.allMemes.get()) {
        expect(m.scannedText, _texts[m.id]);
      }
    });

    test("don't re-scan memes if they have text already", () async {
      // Set text ourselves before scan service does it
      for (final id in _texts.keys) {
        await db.setMemeScannedText(
          id,
          "Pre-set text here :)",
          TerminalOcrScanner().version,
        );
      }

      await fsm.startScanService();
      await fsm.receiveStream.firstWhere((e) => e == null);

      // Text didn't change
      for (final m in await db.allMemes.get()) {
        expect(m.scannedText, "Pre-set text here :)");
      }
    });
  });
}
