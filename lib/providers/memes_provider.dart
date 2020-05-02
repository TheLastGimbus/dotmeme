// This provider keeps sync of all memes list
import 'package:dotmeme/database/memebase.dart';
import 'package:flutter/widgets.dart';
import 'package:moor/moor.dart';
import 'package:moor_ffi/database.dart';
import 'package:photo_manager/photo_manager.dart';

/// This is the way you should access memes.
/// Get all of them, search them, get only from certain folder.
/// Also scan and sync them etc
///
/// This provider carries database object, and should be only one that has it
/// Maybe in future, I will divide this to different provider with one top
/// database provider.
class MemesProvider with ChangeNotifier {
  final db = Memebase();

  Future<List<Folder>> get getAllFolders => db.getAllFolders;

  Future<List<Meme>> get getAllMemes async {
    var watch = Stopwatch()..start();
    //await syncFolders();
    //await syncMemes();
    //var dbMemes = await db.getAllMemes;
    //for (var meme in dbMemes)
    //  memes.add(await AssetEntity.fromId(meme.id.toString()));

    var allMemes = await db.getAllMemes;
    print("Getting all memes took ${watch.elapsedMilliseconds}ms");
    return allMemes;
  }

  Future syncFolders() async {
    final watch = Stopwatch()..start();
    var folders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );
    for (AssetPathEntity fol in folders) {
      try {
        print('Folder: ${fol.name}, id: ${fol.id}, id to int: ${int.parse(fol.id)}');
        db.addFolder(
            FoldersCompanion.insert(
              id: int.parse(fol.id),
              scanningEnabled: false,
            ),
            ignoreFail: true);
      } on SqliteException catch (e) {
        // Already exists
        print("Folder ${fol.name} already exists");
      }
    }
    for (Folder fol in await db.getAllFolders) {
      if (!folders.map((f) => int.parse(f.id)).contains(fol.id)) {
        db.deleteFolder(fol.createCompanion(false));
      }
    }

    print('Folders sync finished in ${watch.elapsedMilliseconds}ms');
  }

  // THIS. DOESN'T. WORK
  // Shit. I need to find some other way around this :///
  Future syncMemes() async {
    var watch = Stopwatch()..start();
    var dbFolders = await db.getAllFoldersEnabled;
    var dbFoldersIds = dbFolders.map((f) => f.id);
    for (var folderId in dbFoldersIds) {
      var watch = Stopwatch()..start();
      var assFolder = await AssetPathEntity.fromId(folderId.toString());
      print("Getting ${assFolder.name} assFolder took ${watch.elapsedMilliseconds}ms");
      watch.reset();
      for (var assMeme in await assFolder.assetList) {
        db.addMeme(MemesCompanion.insert(
          id: int.parse(assMeme.id),
          folderId: int.parse(assFolder.id),
        ), ignoreFail: true);
      }
      print("Getting ${assFolder.name} all asses took ${watch.elapsedMilliseconds}ms");
    }

    print('Memes sync finished in ${watch.elapsedMilliseconds}ms');
  }

  Future setFolderSyncEnabled(Folder folder, bool enabled) async {
    await db.updateFolder(folder
        .createCompanion(false)
        .copyWith(scanningEnabled: Value(enabled)));
    notifyListeners();
  }
}
