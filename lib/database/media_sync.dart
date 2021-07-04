import 'package:get_it/get_it.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';

import '../device_media/media_manager.dart';
import 'memebase.dart';
import 'tables/folders.dart';
import 'tables/memes.dart';

final _mm = GetIt.I<MediaManager>();

/// This extension syncs index of media from device to db
/// Note that those operations may take a while (some 500ms!),
/// and simultaneously, are super important for good experience
/// - use with caution and awareness
extension MediaSync on Memebase {
  Future<void> fullSync() => throw UnimplementedError("Idk if this will exist");

  // This should be done otherwise
  // But i don't have better idea for now, just put it in BenchmarkPage
  Future<void> allFoldersMemeSync(List<AssetPathEntity> deviceFolders) async =>
      _foldersMemeSync(await select(folders).get(), deviceFolders);

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
