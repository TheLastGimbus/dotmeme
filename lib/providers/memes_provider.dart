// This provider keeps sync of all memes list
import 'dart:async';

import 'package:dotmeme/database/memebase.dart';
import 'package:fimber/fimber.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watcher/watcher.dart';

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
  final fim = FimberLog('MemesProvider');

  /// Map of file watchers' steams. Key is folder id.
  Map<String, StreamSubscription<WatchEvent>> _folderWatchSubscriptions = {};

  /// Set up file watchers that will call re-sync functions when some changes
  /// in enabled folders will be detected.
  ///
  /// This function is pretty bad, and will take some time, so call it once,
  /// or never :)
  ///
  /// As always - I'm waiting for Chinese guy to implement this in library
  Future<void> setupWatchers() async {
    // TODO: Check if PhotoManager.addChangeCallback is better
    var timer = Stopwatch()..start();
    fim.v("Setting up file watchers");
    // Add file watchers

    var assFolders = await PhotoManager.getAssetPathList(
      hasAll: false,
      type: RequestType.image,
    );

    for (var folder in await db.getAllFolders) {
      var assPath = assFolders.firstWhere((e) => e.id == folder.id.toString());
      var singleAss = (await assPath.getAssetListRange(start: 0, end: 1)).first;
      // We can't do our hackery thing if there is no single asset
      if (singleAss == null) continue;

      var newSyncGoing = false;
      var newSyncScheduled = false;
      var deleteSyncGoing = false;
      var deleteSyncScheduled = false;

      newSync() async {
        if (newSyncGoing) {
          newSyncScheduled = true;
          return;
        }
        newSyncGoing = true;
        fim.v('NewSync running...');
        // It calls notifyListeners
        await syncNewMemesInFolder(folder.id);
        newSyncGoing = false;
        if (newSyncScheduled) {
          newSyncScheduled = false;
          newSync();
        }
      }

      deleteSync() async {
        if (deleteSyncGoing) {
          deleteSyncScheduled = true;
          return;
        }
        deleteSyncGoing = true;
        fim.v('DeleteSync running...');
        // It calls notifyListeners
        await syncDeletedMemesInFolder(folder.id);
        deleteSyncGoing = false;
        if (deleteSyncScheduled) {
          deleteSyncScheduled = false;
          deleteSync();
        }
      }

      // TODO: THIS SHOULD NOT BE HERE
      // THIS WON'T WORK FOR PEOPLE WITH SD CARD
      // CHANGE THIS IF CHINESE GUY DOES SOMETHING ABOUT THIS
      final folderPath = "/storage/emulated/0/" + singleAss.relativePath;
      fim.v("Setting folder: $folderPath");

      var watcher = DirectoryWatcher(folderPath);
      _folderWatchSubscriptions[folder.id.toString()] =
          (watcher.events.listen((event) async {
        fim.v(event.toString());
        if (event.type == ChangeType.ADD) {
          newSync();
        } else if (event.type == ChangeType.REMOVE) {
          deleteSync();
        } else {
          newSync();
          deleteSync();
        }
      }));
      if (!folder.scanningEnabled) {
        _folderWatchSubscriptions[folder.id.toString()].pause();
      }
    }
    fim.d("Setting up watchers took ${timer.elapsedMilliseconds}ms");
  }

  Future<List<Folder>> get getAllFolders => db.getAllFolders;

  Future<List<Meme>> get getAllMemes async {
    var watch = Stopwatch()..start();
    var allMemes = await db.getAllMemes;
    fim.v("Getting all memes took ${watch.elapsedMilliseconds}ms");
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

    var deleted = false;
    for (var dbFolder in dbFolders) {
      if (!assFoldersIds.contains(dbFolder.id)) {
        await db.deleteFolder(dbFolder);
        await db.deleteAllMemesFromFolder(dbFolder.id);
        deleted = true;
      }
    }
    if (deleted) notifyListeners();

    fim.v('Folders sync finished in ${watch.elapsedMilliseconds}ms');
  }

  /// THIS WORKS!!!
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
                  modificationDate: m.modifiedDateTime,
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

    fim.v('Memes sync finished in ${watch.elapsedMilliseconds}ms');
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
                modificationDate: m.modifiedDateTime,
              ))
          .toList(),
    );
    await db.addMultipleMemes(allNewDbMemes);

    await db.updateFolder(dbFolder.copyWith(lastSync: syncStartTime));

    fim.v('Memes NEW-ONLY sync finished in ${watch.elapsedMilliseconds}ms');
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

  Future<int> getScannedMemesCount(int folderId) async {
    var watch = Stopwatch()..start();
    var c = await db.getAllMemesScannedCountInFolder(folderId);
    fim.v('Counting took ${watch.elapsedMilliseconds}ms, counted: $c');
    return c;
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
    } else if (deleteIfDisabled) {
      await db.deleteAllMemesFromFolder(folder.id);
      notifyListeners();
    }

    /// See _setupWatchers()
    if (enabled)
      _folderWatchSubscriptions[folder.id.toString()].resume();
    else
      _folderWatchSubscriptions[folder.id.toString()].pause();
  }
}
