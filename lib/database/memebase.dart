import 'dart:io';

import 'package:moor/moor.dart';
import 'package:moor_ffi/moor_ffi.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'memebase.g.dart';

/// All fileds containing scanned data are nullable.
/// This provides easy way to tell if certain field was scanned or not,
/// without some dumb "wasScanned" booleans.
class Memes extends Table {
  IntColumn get id => integer().customConstraint("UNIQUE")();

  IntColumn get folderId => integer()();

  TextColumn get scannedText => text().named('text').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Folders extends Table {
  IntColumn get id => integer().customConstraint("UNIQUE")();

  BoolColumn get scanningEnabled => boolean()();

  // Party like it's 1/1/1970
  DateTimeColumn get lastSync => dateTime()
      .withDefault(Constant(DateTime.fromMillisecondsSinceEpoch(0)))();

  @override
  Set<Column> get primaryKey => {id};
}

@UseMoor(tables: [Folders, Memes])
class Memebase extends _$Memebase {
  static const DB_FILE_NAME = 'memebase.sqlite';

  Memebase()
      : super(LazyDatabase(() async {
          final dbfolder = await getApplicationSupportDirectory();
          final dbfile = File(p.join(dbfolder.path, DB_FILE_NAME));
          return VmDatabase(dbfile);
        }));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // Use it some day
        }
      });

  Future addFolder(FoldersCompanion folder, {bool ignoreFail = false}) =>
      into(folders).insert(
        folder,
        mode: ignoreFail ? InsertMode.insertOrIgnore : InsertMode.insert,
      );

  Future addMultipleFolders(List<Folder> newFolders) =>
      batch((b) => b.insertAll(
            folders,
            newFolders,
            mode: InsertMode.insertOrIgnore,
          ));

  Future deleteFolder(Folder folder) => delete(folders).delete(folder);

  Future updateFolder(Folder folder) => update(folders).replace(folder);

  Future updateMultipleFolders(List<Folder> updateFolders) =>
      batch((b) => b.replaceAll(folders, updateFolders));

  Future<List<Meme>> get getAllMemes => select(memes).get();

  Future<int> get getAllMemesCount async {
    var res = await (selectOnly(memes)..addColumns([countAll()])).getSingle();
    return res.read(countAll());
  }

  Future<int> getAllMemesCountInFolder(int folderId) async {
    var count = countAll(filter: memes.folderId.equals(folderId));
    var res = await (selectOnly(memes)..addColumns([count])).getSingle();
    return res.read(count);
  }

  Future<List<Meme>> getAllMemesFromFolder(int folderId) =>
      (select(memes)..where((m) => m.folderId.equals(folderId))).get();

  Future addMeme(MemesCompanion meme, {bool ignoreFail = false}) =>
      into(memes).insert(
        meme,
        mode: ignoreFail ? InsertMode.insertOrIgnore : InsertMode.insert,
      );

  Future addMultipleMemes(List<Meme> newMemes) => batch((b) => b.insertAll(
        memes,
        newMemes,
        mode: InsertMode.insertOrIgnore,
      ));

  Future setMemeText(int memeId, String text) =>
      (update(memes)..where((m) => m.id.equals(memeId)))
          .write(MemesCompanion(scannedText: Value(text)));

  Future<List<Meme>> get getNotScannedMemes =>
      (select(memes)..where((m) => isNull(m.scannedText))).get();

  Future deleteMeme(Meme meme) => delete(memes).delete(meme);

  Future<void> deleteMultipleMemes(List<Meme> toDelete) => (delete(memes)
        ..where(
          (m) => m.id.isIn(
            toDelete.map((m) => m.id).toList(),
          ),
        ))
      .go();

  Future deleteAllMemesFromFolder(int folderId) =>
      (delete(memes)..where((m) => m.folderId.equals(folderId))).go();

  /// Also deletes all from non-existing folders
  Future deleteAllMemesFromDisabledFolders() async {
    var disabledFolders = await getAllFoldersDisabled;
    var enabledIds = (await getAllFoldersEnabled).map((f) => f.id).toList();
    var disabledIds = disabledFolders.map((f) => f.id).toList();

    // Also remove all form non-existing
    var allFoldersIds = (disabledIds + enabledIds);

    await (delete(memes)
          ..where(
            (m) =>
                m.folderId.isIn(disabledIds) |
                m.folderId.isNotIn(allFoldersIds),
          ))
        .go();
    await updateMultipleFolders(
      disabledFolders
          .map((f) => f.copyWith(
                lastSync: DateTime.fromMillisecondsSinceEpoch(0),
              ))
          .toList(),
    );
  }

  Future<Folder> getFolderById(int id) =>
      (select(folders)..where((f) => f.id.equals(id))).getSingle();

  Future<List<Folder>> get getAllFolders => select(folders).get();

  Future<List<Folder>> get getAllFoldersEnabled =>
      (select(folders)..where((f) => f.scanningEnabled)).get();

  Future<List<Folder>> get getAllFoldersDisabled =>
      (select(folders)..where((f) => f.scanningEnabled.not())).get();
}
