// This provider keeps sync of all memes list
import 'dart:developer';

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

  Future<List<AssetEntity>> get getAllMemes async {
    await syncFolders();
    await syncMemes();
    var dbMemes = await db.getAllMemes;
    List<AssetEntity> memes = [];
    for (var meme in dbMemes) memes.add(await AssetEntity.fromId(meme.id.toString()));
    return memes;
  }

  Future syncFolders() async {
    final watch = Stopwatch()..start();
    var folders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );
    for (AssetPathEntity fol in folders) {
      try {
        log('Folder: ${fol.name}, id: ${fol.id}, id to int: ${int.parse(fol.id)}');
        db.addFolder(
            FoldersCompanion.insert(
              id: int.parse(fol.id),
              scanningEnabled: false,
            ),
            ignoreFail: true);
      } on SqliteException catch (e) {
        // Already exists
        log("Folder ${fol.name} already exists");
      }
    }
    for (Folder fol in await db.getAllFolders) {
      if (!folders.map((f) => int.parse(f.id)).contains(fol.id)) {
        db.deleteFolder(fol.createCompanion(false));
      }
    }

    log('Folders sync finished in ${watch.elapsedMilliseconds}ms');
  }

  // THIS. DOESN'T. WORK
  // Shit. I need to find some other way around this :///
  Future syncMemes() async {
    var watch = Stopwatch()..start();
    var assFolders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );
    var dbfolders = await db.getAllFolders;
    dbfolders.removeWhere((fol) => !fol.scanningEnabled);
    var enabledFoldersDb = dbfolders.map((fol) => fol.id);
    for (var fold in assFolders) {
      if (enabledFoldersDb.contains(int.parse(fold.id))) {
        var assets = await fold.assetList;
        assets.forEach(
          (ass) async {
            return await db.addMeme(
            MemesCompanion.insert(id: int.parse(ass.id), folderId: int.parse(fold.id)),
            ignoreFail: true,
          );
          },
        );
      }
      for (var meme in await db.getAllMemes) {
        if (!enabledFoldersDb.contains(meme.folderId)) {
          db.deleteMeme(meme.createCompanion(false));
        }
      }
    }

    log('Memes sync finished in ${watch.elapsedMilliseconds}ms');
  }

  Future setFolderSyncEnabled(Folder folder, bool enabled) async {
    await db.updateFolder(folder
        .createCompanion(false)
        .copyWith(scanningEnabled: Value(enabled)));
    notifyListeners();
  }
}
