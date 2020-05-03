import 'package:dotmeme/analyze/ocr/ocr.dart';
import 'package:dotmeme/notifications/notifications.dart';
import 'package:dotmeme/providers/memes_provider.dart';
import 'package:photo_manager/photo_manager.dart';

class PeriodicScan {
  static const TASK_ID = 'periodic_scan';

  static void backgroundScan(String taskId) async {
    print("IMMM SCANNINGGGGG (REALLY!)");
    Notifications.showExampleNotification();
    var memesProvider = MemesProvider();
    await memesProvider.syncFolders();
    await memesProvider.syncMemes();
    var memesToScan = await memesProvider.db.getNotScannedMemes;
    print('Not scanned memes: \n $memesToScan');
    for (var meme in memesToScan) {
      try {
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
        print("Couldn't scan image ${meme.id}:");
        print(e);
      }
    }
  }
}
