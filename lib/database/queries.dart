import 'package:moor/moor.dart';

import 'memebase.dart';

extension Queries on Memebase {
  // ############ Folders ############

  Future<List<Folder>> get allFolders => select(folders).get();

  Future<Folder> getFolder(int id) =>
      (select(folders)..where((tbl) => tbl.id.equals(id))).getSingle();

  Future<void> addFolder(Folder newFolder) => into(folders).insert(newFolder);

  Future<void> addFolders(List<Folder> newFolders) =>
      batch((b) => b.insertAll(folders, newFolders));

  Future<void> deleteFolder(int id) async =>
      (delete(folders)..where((tbl) => tbl.id.equals(id))).go();

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

  Future<void> addMeme(Meme newMeme) => into(memes).insert(newMeme);

  Future<void> addMemes(List<Meme> newMemes) =>
      batch((b) => b.insertAll(memes, newMemes));

  Future<void> deleteMeme(int id) async =>
      (delete(memes)..where((tbl) => tbl.id.equals(id))).go();
}
