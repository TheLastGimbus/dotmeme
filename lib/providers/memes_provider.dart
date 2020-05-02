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
    var watch = Stopwatch()..start();
    //await syncFolders();
    //await syncMemes();
    //var dbMemes = await db.getAllMemes;
    //for (var meme in dbMemes)
    //  memes.add(await AssetEntity.fromId(meme.id.toString()));

    var allMemes = await db.getAllMemes;
    print("Getting memes from db took ${watch.elapsedMilliseconds}ms");
    var allAssMemes = List<AssetEntity>();
    for (var meme in allMemes) {
      allAssMemes.add(await AssetEntity.fromId(meme.id.toString()));
    }
    print("Getting all memes took ${watch.elapsedMilliseconds}ms");
    return allAssMemes;
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
    log("Getting asset paths took ${watch.elapsedMilliseconds}ms");
    var dbFolders = await db.getAllFoldersEnabled;
    var dbFoldersIds = dbFolders.map((f) => f.id);
    log("Getting all folders ids took ${watch.elapsedMilliseconds}ms");
    assFolders.removeWhere((f) => !dbFoldersIds.contains(f.id));
    log("Removing not scannable asses took ${watch.elapsedMilliseconds}ms");
    var assMemes = List<AssetEntity>();
    for (var assFolder in assFolders) {
      assMemes.addAll(await assFolder.assetList);
    }
    log("Getting memes to list took ${watch.elapsedMilliseconds}ms");

    log('Memes sync finished in ${watch.elapsedMilliseconds}ms');
  }

  Future setFolderSyncEnabled(Folder folder, bool enabled) async {
    await db.updateFolder(folder
        .createCompanion(false)
        .copyWith(scanningEnabled: Value(enabled)));
    notifyListeners();
  }
}
