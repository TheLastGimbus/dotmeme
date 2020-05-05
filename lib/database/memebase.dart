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
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(onCreate: (Migrator m) {
        return m.createAll();
      }, onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1) {
          // we added the dueDate property in the change from version 1
          await m.addColumn(folders, folders.lastSync);
        }
      });

  Future addFolder(FoldersCompanion folder, {bool ignoreFail = false}) =>
      into(folders).insert(
        folder,
        mode: ignoreFail ? InsertMode.insertOrIgnore : InsertMode.insert,
      );

  Future deleteFolder(FoldersCompanion folder) =>
      delete(folders).delete(folder);

  Future updateFolder(Folder folder) => update(folders).replace(folder);

  Future updateMultipleFolders(List<Folder> updateFolders) =>
      batch((b) => b.replaceAll(folders, updateFolders));

  Future<List<Meme>> get getAllMemes => select(memes).get();

  Future<List<Meme>> getAllMemesFromFolder(int folderId) =>
      (select(memes)..where((m) => m.folderId.equals(folderId))).get();

  Future addMeme(MemesCompanion meme, {bool ignoreFail = false}) =>
      into(memes).insert(
        meme,
        mode: ignoreFail ? InsertMode.insertOrIgnore : InsertMode.insert,
      );

  Future addMultipleMemes(List<MemesCompanion> newMemes) =>
      batch((b) => b.insertAll(
            memes,
            newMemes,
            mode: InsertMode.insertOrIgnore,
          ));

  Future setMemeText(int memeId, String text) =>
      (update(memes)..where((m) => m.id.equals(memeId)))
          .write(MemesCompanion(scannedText: Value(text)));

  Future<List<Meme>> get getNotScannedMemes =>
      (select(memes)..where((m) => isNull(m.scannedText))).get();

  Future deleteMeme(MemesCompanion meme) => delete(memes).delete(meme);

  Future deleteAllMemesFromFolder(int folderId) =>
      (delete(memes)..where((m) => m.folderId.equals(folderId))).go();

  Future deleteAllMemesFromDisabledFolders() async {
    var disabledFolders =
        await (select(folders)..where((f) => f.scanningEnabled.not())).get();
    var disabledIds = disabledFolders.map((f) => f.id).toList();
    await (delete(memes)..where((m) => m.folderId.isIn(disabledIds))).go();
    await updateMultipleFolders(
      disabledFolders
          .map((f) => f.copyWith(
                lastSync: DateTime.fromMillisecondsSinceEpoch(0),
              ))
          .toList(),
    );
  }

  Future<List<Folder>> get getAllFolders => select(folders).get();

  Future<List<Folder>> get getAllFoldersEnabled =>
      (select(folders)..where((f) => f.scanningEnabled)).get();

  Future<List<Folder>> get getAllFoldersDisabled =>
      (select(folders)..where((f) => f.scanningEnabled.not())).get();
}
