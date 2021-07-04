import 'package:moor/moor.dart';

import 'memebase.dart';

extension Queries on Memebase {
  // ############ Folders ############

  MultiSelectable<Folder> get allFolders => select(folders);

  MultiSelectable<Folder> get enabledFolders =>
      (select(folders)..where((tbl) => tbl.scanningEnabled.equals(true)));

  Future<void> setFolderEnabled(int id, bool enabled) async =>
      (update(folders)..where((tbl) => tbl.id.equals(id)))
          .write(FoldersCompanion(scanningEnabled: Value(enabled)));

  Future<int> folderMemesCount(int id) async {
    final exp = memes.id.count();
    final res = await (selectOnly(memes)
          ..addColumns([exp])
          ..where(memes.folderId.equals(id)))
        .getSingle();
    return res.read(exp);
  }

  /// Batch of folders meme counts
  /// Returns a Map<folderId, memeCount>
  Future<Map<int, int>> foldersMemeCounts(List<int> ids) async {
    final res = await customSelect(
      "SELECT folder_id, COUNT(id) "
      "FROM memes WHERE folder_id IN (${ids.join(",")}) "
      "GROUP BY (folder_id);",
      readsFrom: {memes},
    ).get();
    return {
      for (final row in res) row.read<int>("folder_id"): row.read("COUNT(id)")
    };
  }

  // ############ Memes ############

  /// All memes from enabled folders
  MultiSelectable<Meme> get allMemes {
    final q = (select(memes).join([
      innerJoin(folders, folders.id.equalsExp(memes.folderId)),
    ]));
    q.where(folders.scanningEnabled.equals(true));
    return q.map((row) => row.readTable(memes));
  }
}
