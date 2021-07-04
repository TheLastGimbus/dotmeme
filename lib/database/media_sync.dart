import 'package:get_it/get_it.dart';
import 'package:moor/moor.dart';
import 'package:photo_manager/photo_manager.dart';

import '../device_media/media_manager.dart';
import 'memebase.dart';
import 'tables/folders.dart';
import 'tables/memes.dart';

final _mm = GetIt.I<MediaManager>();

// TODO: Optimize communication with media_manager with some batching
/// This extension syncs index of media from device to db
/// Note that those operations may take a while (some 500ms!),
/// and simultaneously, are super important for good experience
/// - use with caution and awareness
extension MediaSync on Memebase {
  Future<void> fullSync() async {}

  Future<void> enabledFoldersMemeSync() async {
    final enabled = await (select(folders)
          ..where((tbl) => tbl.scanningEnabled.equals(true)))
        .get();
    final fs = <Future>[];
    for (final f in enabled) {
      fs.add(folderMemeSync(f.id));
    }
    await Future.wait(fs);
  }

  Future<void> folderMemeSync(int id) async {
    final path = await _mm.assetPathEntityFromId(
      id.toString(),
      type: RequestType.common,
    );
    final assets = await path.assetList;
    final newMemes = assets.map((e) => Meme(
          id: int.parse(e.id),
          folderId: id,
          memeType: e.type.toMemeType().index,
        ));
    await batch((b) {
      b.insertAllOnConflictUpdate(memes, newMemes.toList());
      b.deleteWhere(
        memes,
        (Memes tbl) => tbl.id.isNotIn(assets.map((e) => int.parse(e.id))),
      );
    });
  }

  /// Sync device folders both ways (create new ones and delete non-existing)
  /// Also deletes memes from non-existing folders
  /// Returns new folders ids - might be useful for "new folder" notification
  Future<List<int>> foldersSync() async {
    final paths = await _mm.getAssetPathList(
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
    final pathIds = paths.map((e) => int.parse(e.id));
    final dbIds = (await (selectOnly(folders)..addColumns([folders.id])).get())
        .map((e) => e.read(folders.id)!);
    // Folders that are on device but on in db
    final foldersToAdd = paths.map((e) => FoldersCompanion.insert(
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
