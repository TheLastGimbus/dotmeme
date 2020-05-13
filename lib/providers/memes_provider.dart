// This provider keeps sync of all memes list
import 'package:dotmeme/database/memebase.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';

/// This is the way you should access memes.
/// Get all of them, search them, get only from certain folder.
/// Also scan and sync them etc
///
/// This provider carries database object, and should be only one that has it
/// Maybe in future, I will divide this to different provider with one top
/// database provider.
///
/// It calls notifyListeners on top methods which could edit whole memes list
class MemesProvider with ChangeNotifier {
  final db = Memebase();

  Future<List<Folder>> get getAllFolders => db.getAllFolders;

  Future<List<Meme>> get getAllMemes async {
    var watch = Stopwatch()..start();
    var allMemes = await db.getAllMemes;
    print("Getting all memes took ${watch.elapsedMilliseconds}ms");
    return allMemes;
  }

  /// This also deletes memes from folders that stopped existing
  Future syncFolders() async {
    final watch = Stopwatch()..start();
    var dbFolders = await db.getAllFolders;
    var dbFoldersIds = dbFolders.map((f) => f.id).toSet();
    var assFolders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );
    var assFoldersIds = assFolders.map((f) => int.parse(f.id)).toSet();

    if (setEquals(dbFoldersIds, assFoldersIds)) return;

    var foldersToAdd = List<Folder>();
    for (var assFol in assFolders) {
      var assId = int.parse(assFol.id);
      if (!dbFoldersIds.contains(assId)) {
        foldersToAdd.add(Folder(
          id: assId,
          scanningEnabled: false,
        ));
      }
    }
    await db.addMultipleFolders(foldersToAdd);

    for (var dbFolder in dbFolders) {
      if (!assFoldersIds.contains(dbFolder.id)) {
        await db.deleteFolder(dbFolder);
        await db.deleteAllMemesFromFolder(dbFolder.id);
      }
    }

    print('Folders sync finished in ${watch.elapsedMilliseconds}ms');
  }

  /// THIS WORKS!!!
  // TODO: Sort by date
  Future syncMemes() async {
    var watch = Stopwatch()..start();
    var syncStartTime = DateTime.now();

    // This is used to optimize deleting
    var allAssFolders = List<AssetPathEntity>();

    var allDbFolders = await db.getAllFoldersEnabled;
    var allNewDbMemes = List<Meme>();

    var allDbUpdatedFolders = Set<Folder>();

    for (var dbFolder in allDbFolders) {
      var limitedAssFolder = await AssetPathEntity.fromId(
        dbFolder.id.toString(),
        filterOption: FilterOptionGroup()
          ..dateTimeCond = DateTimeCond(
            min: dbFolder.lastSync,
            max: DateTime.now(),
          ),
        type: RequestType.image,
      );

      allAssFolders.add(await AssetPathEntity.fromId(
        dbFolder.id.toString(),
        type: RequestType.image,
      ));

      // Quick fix for nulls
      // TODO: Change this is chinesee guy fixes it
      if (limitedAssFolder.assetCount == null ||
          limitedAssFolder.assetCount == 0) continue;

      allDbUpdatedFolders.add(dbFolder);

      var newAssFolderMemes = await limitedAssFolder.assetList;

      allNewDbMemes.addAll(
        newAssFolderMemes
            .map((m) => Meme(
                  id: int.parse(m.id),
                  folderId: int.parse(limitedAssFolder.id),
                ))
            .toList(),
      );
    }
    await db.addMultipleMemes(allNewDbMemes);

    // Delete all memes that are from folders that were disabled
    await db.deleteAllMemesFromDisabledFolders();

    // Delete all memes that were deleted from device
    for (var dbFol in allDbFolders) {
      // First - check if there is a difference in ".count()"
      var count = await db.getAllMemesCountInFolder(dbFol.id);
      var assFolder =
          allAssFolders.firstWhere((f) => int.parse(f.id) == dbFol.id);
      if (count != assFolder.assetCount) {
        // Delete all memes that are in database, but not in AssetPath
        // aka those who were deleted
        var allAssMemes = await assFolder.assetList;
        var assIds = allAssMemes.map((m) => int.parse(m.id)).toList();
        var dbMemes = await db.getAllMemesFromFolder(dbFol.id);

        // Sorry, I did not found any good way to do this DB-style
        // Just need to check every one myself
        for (var meme in dbMemes) {
          if (!assIds.contains(meme.id)) {
            await db.deleteMeme(meme);
          }
        }
      }
    }

    // Update folders' lastSync dates to when scanning begun
    var foldersWithUpdatedTimes = allDbUpdatedFolders
        .map(
          (f) => f.copyWith(lastSync: syncStartTime),
        )
        .toList();
    await db.updateMultipleFolders(foldersWithUpdatedTimes);

    print('Memes sync finished in ${watch.elapsedMilliseconds}ms');
    notifyListeners();
  }

  /// This is to sync only new memes in certain folder.
  /// Mainly to use with file watcher
  Future syncNewMemesInFolder(int folderId) async {
    var watch = Stopwatch()..start();
    var syncStartTime = DateTime.now();

    var allNewDbMemes = List<Meme>();
    var dbFolder = await db.getFolderById(folderId);

    var limitedAssFolder = await AssetPathEntity.fromId(
      dbFolder.id.toString(),
      filterOption: FilterOptionGroup()
        ..dateTimeCond = DateTimeCond(
          min: dbFolder.lastSync,
          max: DateTime.now(),
        ),
      type: RequestType.image,
    );

    // Quick fix for nulls
    // TODO: Change this is chinesee guy fixes it
    if (limitedAssFolder.assetCount == null || limitedAssFolder.assetCount == 0)
      return;

    var newAssFolderMemes = await limitedAssFolder.assetList;

    allNewDbMemes.addAll(
      newAssFolderMemes
          .map((m) => Meme(
                id: int.parse(m.id),
                folderId: int.parse(limitedAssFolder.id),
              ))
          .toList(),
    );
    await db.addMultipleMemes(allNewDbMemes);

    await db.updateFolder(dbFolder.copyWith(lastSync: syncStartTime));

    print('Memes NEW-ONLY sync finished in ${watch.elapsedMilliseconds}ms');
    notifyListeners();
  }

  /// This is to sync only deleted memes in certain folder.
  /// Mainly to use with file watcher
  Future syncDeletedMemesInFolder(int folderId) async {
    var assFolder = await AssetPathEntity.fromId(folderId.toString(),
        type: RequestType.image);
    // Delete all memes that are in database, but not in AssetPath
    // aka those who were deleted
    var allAssMemes = await assFolder.assetList;
    var assIds = allAssMemes.map((m) => int.parse(m.id)).toList();
    var dbMemes = await db.getAllMemesFromFolder(folderId);

    // Sorry, I did not found any good way to do this DB-style
    // Just need to check every one myself
    for (var meme in dbMemes) {
      if (!assIds.contains(meme.id)) {
        await db.deleteMeme(meme);
      }
    }
    notifyListeners();
  }

  Future deleteMemes(List<Meme> toDelete) async {
    db.deleteMultipleMemes(toDelete);
    notifyListeners();
  }

  Future setFolderSyncEnabled(Folder folder, bool enabled,
      {bool deleteIfDisabled = false}) async {
    await db.updateFolder(folder.copyWith(
      scanningEnabled: enabled,
      lastSync: DateTime.fromMillisecondsSinceEpoch(0),
    ));
    if (enabled) {
      await syncNewMemesInFolder(folder.id);
      // It already notified listeners
    } else {
      await db.deleteAllMemesFromFolder(folder.id);
      notifyListeners();
    }
  }
}
