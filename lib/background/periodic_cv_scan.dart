import 'package:dotmeme/analyze/ocr/ocr.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:fimber/fimber_base.dart';
import 'package:photo_manager/photo_manager.dart';

class PeriodicCvScan {
  static const TAG = 'periodic_cv_scan';

  static const TASK_NAME_OCR = 'task_ocr_scan';

  static Future ocrScan({String taskName}) async {
    final fim = FimberLog("PeriodicCVScan");

    fim.i("IMMM SCANNINGGGGG (REALLY!) Task name: $taskName");
    // TODO: Check for permission
    var memesProvider = MemesProvider();
    await memesProvider.syncFolders();
    await memesProvider.syncMemes();
    var memesToScan = await memesProvider.db.getNotScannedMemes;
    // Scan at max 20 memes at the time
    // So OS won't get mad for taking too long
    if (memesToScan.length > 20) {
      memesToScan.getRange(0, 19);
    }
    fim.d('Not scanned memes: \n $memesToScan');
    for (var meme in memesToScan) {
      try {
        // This doesn't work for now, because photo_manager uses some
        // Activity to get stuff
        var asset = await AssetEntity.fromId(meme.id.toString());
        if (asset.type != AssetType.image) {
          throw ("Asset is not image! "
              "Videos and others are not supported for now!");
        }
        var file = await asset.file;
        print('Scanning ${file.path}');
        var text = await Ocr.getText(imagePath: file.path);
        print('Text: $text');
        memesProvider.db.setMemeText(meme.id, text);
      } catch (e) {
        // Sadly, we can't catch fatal exceptions from Tesseract :c
        // I need to contribute some to it
        fim.e("Couldn't scan image ${meme.id}:");
        print(e);
      }
    }
  }
}
