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

  // TODO: THIS
  Future syncFolders() async {
    final watch = Stopwatch()..start();
    var folders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );
    for (AssetPathEntity fol in folders) {
      try {
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
  // TODO: THIS
  Future syncMemes() async {
    var watch = Stopwatch()..start();
    var dbFoldersIds = (await db.getAllFoldersEnabled).map((f) => f.id);
    for (var folderId in dbFoldersIds) {
      var assFolder = await AssetPathEntity.fromId(folderId.toString());
      var allAssMemesIds =
          (await assFolder.assetList).map((f) => int.parse(f.id));
      for (var assId in allAssMemesIds) {
        try {
          db.addMeme(
              MemesCompanion.insert(
                id: assId,
                folderId: int.parse(assFolder.id),
              ),
              ignoreFail: true);
        } on SqliteException catch (e) {}
      }

      var allDbMemesIds =
          (await db.getAllMemesFromFolder(int.parse(assFolder.id)))
              .map((m) => m.folderId);
      for (var id in allDbMemesIds) {
        if (!allAssMemesIds.contains(id)) {
          db.deleteMeme(MemesCompanion(id: Value(id)));
        }
      }
    }
    for(var folder in await db.getAllFoldersDisabled){
      db.deleteAllMemesFromFolder(folder.id);
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
