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
    return (selectOnly(memes)
          ..addColumns([exp])
          ..where(memes.id.equals(id)))
        .map((row) => row.read(exp))
        .getSingle();
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
