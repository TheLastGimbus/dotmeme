import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:watcher/watcher.dart';

import '../device_media/media_manager.dart';
import 'memebase.dart';
import 'tables/folders.dart';
import 'tables/memes.dart';

final _mm = GetIt.I<MediaManager>();
final _log = GetIt.I<Logger>();
final _dirWatchers = <StreamSubscription<WatchEvent>>[];
CancelableOperation? _fileWatcherBufferFlush;

/// Await this to make sure file watchers are all done
Future<void>? _fileWatcherBufferFlushing;

/// This extension syncs index of media from device to db
/// Note that those operations may take a while (some 500ms!),
/// and simultaneously, are super important for good experience
/// - use with caution and awareness
extension MediaSync on Memebase {
  Future<void> fullSync() => throw UnimplementedError("Idk if this will exist");

  // This should be done otherwise
  // But i don't have better idea for now, just put it in BenchmarkPage
  Future<void> allFoldersMemeSync(List<AssetPathEntity> deviceFolders) async =>
      await _foldersMemeSync(await select(folders).get(), deviceFolders);

  Future<void> enabledFoldersMemeSync(
      List<AssetPathEntity> deviceFolders) async {
    final enabled = await (select(folders)
          ..where((tbl) => tbl.scanningEnabled.equals(true)))
        .get();
    await _foldersMemeSync(enabled, deviceFolders);
  }

  Future<void> disabledFoldersMemeSync(
      List<AssetPathEntity> deviceFolders) async {
    final enabled = await (select(folders)
          ..where((tbl) => tbl.scanningEnabled.equals(false)))
        .get();
    await _foldersMemeSync(enabled, deviceFolders);
  }

  Future<void> _foldersMemeSync(
      List<Folder> dbFolders, List<AssetPathEntity> deviceFolders) async {
    await batch((b) async {
      for (final f in dbFolders) {
        final assets = await deviceFolders
            .firstWhere((e) => int.parse(e.id) == f.id)
            .assetList;
        final newMemes = assets.map((e) => Meme(
              id: int.parse(e.id),
              folderId: f.id,
              memeType: e.type.toMemeType().index,
              lastModified: e.modifiedDateTime,
            ));

        b.insertAllOnConflictUpdate(memes, newMemes.toList());
        b.deleteWhere(
          memes,
          (Memes tbl) => (tbl.folderId.equals(f.id) &
              tbl.id.isNotIn(assets.map((e) => int.parse(e.id)))),
        );
      }
    });
  }

  /// Sync device folders both ways (create new ones and delete non-existing)
  /// Also deletes memes from non-existing folders
  /// Returns new folders ids - might be useful for "new folder" notification
  Future<List<int>> foldersSync(List<AssetPathEntity> deviceFolders) async {
    final pathIds = deviceFolders.map((e) => int.parse(e.id));
    final dbIds = (await (selectOnly(folders)..addColumns([folders.id])).get())
        .map((e) => e.read(folders.id)!);
    // Folders that are on device but on in db
    final foldersToAdd = deviceFolders.map((e) => FoldersCompanion.insert(
          id: Value(int.parse(e.id)),
          name: e.name,
          lastModified: Value(e.lastModified ?? DateTime.now()),
        ));
    // Folders that are in db but not on device (they were deleted by user)
    final foldersToDelete = dbIds.where((e) => !pathIds.contains(e));
    await batch((b) {
      b.insertAllOnConflictUpdate(folders, foldersToAdd.toList());
      // Also clean up memes
      b.deleteWhere(memes, (Memes tbl) => tbl.folderId.isIn(foldersToDelete));
      b.deleteWhere(folders, (Folders tbl) => tbl.id.isIn(foldersToDelete));
    });
    return foldersToAdd.map((e) => e.id.value).toList();
  }

  // TODO: Integration tests for this :pray:
  // TODO someday: "New folder" watcher - isn't urgent tho
  /// Set up system file watchers that will auto-sync db whenever some media
  /// are added/moved/deleted
  Future<void> setupFileWatchers(List<AssetPathEntity> deviceFolders) async {
    // Okay, how this beauty works:
    // File move operations are often than on multiple files (user moves N files
    // instead of just one)
    // Also, with every "file moved", two events come:
    // DELETE in one and ADD in the other
    // But our DirWatcher stream emits events as-is
    // So we hold those for some time in those two sets

    // Keeps track of which folders have to be refreshed (something was added)
    final devFoldersToRefresh = <AssetPathEntity>{};
    // Keeps track of what folders to sync in general
    final foldersToSync = <int>{};

    // This function is called after events stop coming for some time
    Future<void> flushEvents() async {
      _log.d("Flushing changeEvent buffer - \n"
          "devFolders to refresh: $devFoldersToRefresh ; \n"
          "folders to sync: $foldersToSync");
      for (final ass in devFoldersToRefresh) {
        await ass.refreshPathProperties();
      }
      await _foldersMemeSync(
        await (select(folders)..where((tbl) => tbl.id.isIn(foldersToSync)))
            .get(),
        deviceFolders,
      );
      devFoldersToRefresh.clear();
      foldersToSync.clear();
    }

    // Duration here is the time in which we will execute flushEvents() when
    // events stop coming
    getFlushFuture() => CancelableOperation.fromFuture(
        Future.delayed(const Duration(milliseconds: 2000)))
      ..value.then((_) => _fileWatcherBufferFlushing = flushEvents());

    for (final devFol in deviceFolders) {
      final ass = await devFol.getAssetListRange(start: 0, end: 1);
      final file = await ass.first.file;
      if (file == null) {
        _log.e("Can't watch $devFol because first file is null!");
        continue;
      }
      final dirWatcher = DirectoryWatcher(file.parent.path,
          pollingDelay: const Duration(milliseconds: 500));
      _dirWatchers.add(
        dirWatcher.events
            // Not recursive
            .where((e) => File(e.path).parent.path == file.parent.path)
            .listen((e) async {
          _log.d(e);
          // When new events come, add them to buffer and reset the
          // Future.delayed()
          await _fileWatcherBufferFlush?.cancel();
          if (e.type == ChangeType.ADD) devFoldersToRefresh.add(devFol);
          switch (e.type) {
            case ChangeType.ADD:
            case ChangeType.REMOVE:
              foldersToSync.add(int.parse(devFol.id));
          }
          _fileWatcherBufferFlush = getFlushFuture();
        }),
      );
    }
  }

  /// Close all file watchers. Remember to call this to avoid leaks
  Future<void> closeFileWatchers() async {
    await _fileWatcherBufferFlush?.cancel();
    await _fileWatcherBufferFlushing; // Will wait until syncing is done
    for (final dw in _dirWatchers) {
      await dw.cancel();
    }
    _dirWatchers.clear();
  }

  static Future<List<AssetPathEntity>> getMediaFolders() =>
      _mm.getAssetPathList(
        hasAll: false,
        type: RequestType.image,
        // IDEA: Make this faster - "only folders newer than newest in db"
        // Tho this requires extra table field (folder creation date),
        // and assumes we didn't break anything (highly unlikely)
        filterOption: FilterOptionGroup(
          containsPathModified: true,
          containsEmptyAlbum: true,
          imageOption: const FilterOption(
            sizeConstraint: SizeConstraint(ignoreSize: true),
          ),
        ),
      );
}

// Maybe move this to media_manager ?
extension _Help on AssetType {
  MemeType toMemeType() {
    if (this == AssetType.image) {
      return MemeType.image;
    } else if (this == AssetType.video) {
      return MemeType.video;
    } else {
      throw UnsupportedError("Unsupported asset type - not a meme");
    }
  }
}
