// This provider keeps sync of all memes list
import 'package:dotmeme/database/memebase.dart';
import 'package:flutter/widgets.dart';
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
    var dbFolders = await db.getAllFoldersEnabled;
    for (var dbFolder in dbFolders) {
      var syncStartTime = DateTime.now();
      var watch = Stopwatch()..start();
      var assFolder = await AssetPathEntity.fromId(
        dbFolder.id.toString(),
        filterOption: FilterOptionGroup()
          ..dateTimeCond = DateTimeCond(
            min: dbFolder.lastSync,
            max: DateTime.now(),
          ),
        type: RequestType.image,
      );
      print('Getting foler ${dbFolder.id} from ${dbFolder.lastSync} '
          'took ${watch.elapsedMilliseconds}ms');
      watch.reset();
      // Quick fix for nulls
      // TODO: Change this is chinesee guy fixes it
      if (assFolder.assetCount == null || assFolder.assetCount == 0) continue;
      var newAssMemes = await assFolder.assetList;

      var newDbMemes = newAssMemes.map((m) => MemesCompanion.insert(
            id: int.parse(m.id),
            folderId: int.parse(assFolder.id),
          )).toList();
      db.addMultipleMemes(newDbMemes);

      await db.updateFolder(dbFolder.copyWith(lastSync: syncStartTime));
      print(
          'Syncing folder ${dbFolder.id} took ${watch.elapsedMilliseconds}ms');
    }
    var w = Stopwatch()..start();
    for (var folder in await db.getAllFoldersDisabled) {
      await db.deleteAllMemesFromFolder(folder.id);
      await db.updateFolder(
        folder.copyWith(lastSync: DateTime.fromMillisecondsSinceEpoch(0)),
      );
    }
    print('Delete not used folders: ${w.elapsedMilliseconds}ms');

    print('Memes sync finished in ${watch.elapsedMilliseconds}ms');
  }

  Future setFolderSyncEnabled(Folder folder, bool enabled) async {
    await db.updateFolder(folder.copyWith(scanningEnabled: enabled));
    notifyListeners();
  }
}
