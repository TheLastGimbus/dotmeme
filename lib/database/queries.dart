import 'package:moor/moor.dart';

import 'memebase.dart';

extension Queries on Memebase {
  // ############ Folders ############

  MultiSelectable<Folder> get allFolders => select(folders)
    ..orderBy([
      (tbl) =>
          OrderingTerm(expression: tbl.lastModified, mode: OrderingMode.desc)
    ]);

  MultiSelectable<Folder> get enabledFolders => (select(folders)
    ..where((tbl) => tbl.scanningEnabled.equals(true))
    ..orderBy([
      (tbl) =>
          OrderingTerm(expression: tbl.lastModified, mode: OrderingMode.desc)
    ]));

  Future<void> setFolderEnabled(int id, bool enabled) async =>
      await (update(folders)..where((tbl) => tbl.id.equals(id)))
          .write(FoldersCompanion(scanningEnabled: Value(enabled)));

  Future<int> folderMemesCount(int id) async {
    final exp = memes.id.count();
    final res = await (selectOnly(memes)
          ..addColumns([exp])
          ..where(memes.folderId.equals(id)))
        .getSingle();
    return res.read(exp);
  }

  /// Batch of all folders meme counts
  /// Returns a Map<folderId, memeCount>
  MultiSelectable<MapEntry<Folder, int>> allFoldersMemeCounts() {
    final exp = memes.id.count();
    return (select(folders).join([
      leftOuterJoin(memes, memes.folderId.equalsExp(folders.id)),
    ])
          ..addColumns([exp])
          ..groupBy([folders.id])
          ..orderBy([OrderingTerm.desc(folders.lastModified)]))
        .map((row) => MapEntry(row.readTable(folders), row.read(exp)));
  }

  // ############ Memes ############

  /// All memes from enabled folders
  MultiSelectable<Meme> get allMemes {
    final q = (select(memes).join([
      innerJoin(folders, folders.id.equalsExp(memes.folderId)),
    ]));
    q.where(folders.scanningEnabled.equals(true));
    q.orderBy([OrderingTerm.desc(memes.lastModified)]);
    return q.map((row) => row.readTable(memes));
  }

  /// All memes from enabled folders that are not scanned yet
  MultiSelectable<Meme> get allNotScannedMemes {
    final q = (select(memes).join([
      innerJoin(folders, folders.id.equalsExp(memes.folderId)),
    ]));
    q.where(folders.scanningEnabled.equals(true));
    q.where(memes.scannedText.isNull());
    // Scan oldest memes first
    q.orderBy([OrderingTerm.asc(memes.lastModified)]);
    return q.map((row) => row.readTable(memes));
  }

  /// Literally all memes - even from folders that are not enabled - not memes
  /// Note that those may be less up-to-date than actual memes (less frequently
  /// synced)
  MultiSelectable<Meme> get allMemesLiteral =>
      select(memes)..orderBy([(tbl) => OrderingTerm.desc(tbl.lastModified)]);

  Future<void> setMemeScannedText(int id, String text) async {
    // NOTE: Maybe some shorter/common way to handle this
    var affectedRows = await (update(memes)..where((tbl) => tbl.id.equals(id)))
        .write(MemesCompanion(scannedText: Value(text)));
    if (affectedRows == 1) return;
    if (affectedRows == 0) throw "No meme with given id found!";
    throw "WTF: This should never happen";
  }

  Future<int> get scannedMemesCount async {
    final exp = memes.id.count();
    final raw = await (selectOnly(memes)
          ..addColumns([exp, memes.scannedText])
          ..where(memes.scannedText.equals(null).not()))
        .getSingle();
    return raw.read(exp);
  }
}
