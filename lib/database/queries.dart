import 'memebase.dart';

extension Queries on Memebase {
  // ############ Folders ############

  Future<List<Folder>> get allFolders => select(folders).get();

  Future<void> addFolder(Folder newFolder) => into(folders).insert(newFolder);

  Future<void> addFolders(List<Folder> newFolders) =>
      batch((b) => b.insertAll(folders, newFolders));

  Future<void> deleteFolder(int id) async =>
      (delete(folders)..where((tbl) => tbl.id.equals(id))).go();

  // ############ Memes ############

  Future<List<Meme>> get allMemes => select(memes).get();

  Future<void> addMeme(Meme newMeme) => into(memes).insert(newMeme);

  Future<void> addMemes(List<Meme> newMemes) =>
      batch((b) => b.insertAll(memes, newMemes));

  Future<void> deleteMeme(int id) async =>
      (delete(memes)..where((tbl) => tbl.id.equals(id))).go();
}
