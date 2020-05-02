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

  Future addFolder(FoldersCompanion folder, {bool ignoreFail = false}) =>
      into(folders).insert(
        folder,
        mode: ignoreFail ? InsertMode.insertOrIgnore : InsertMode.insert,
      );

  Future deleteFolder(FoldersCompanion folder) =>
      delete(folders).delete(folder);

  Future updateFolder(FoldersCompanion folder) =>
      update(folders).replace(folder);

  Future<List<Meme>> get getAllMemes => select(memes).get();

  Future addMeme(MemesCompanion meme, {bool ignoreFail = false}) =>
      into(memes).insert(
        meme,
        mode: ignoreFail ? InsertMode.insertOrIgnore : InsertMode.insert,
      );

  Future deleteMeme(MemesCompanion meme) => delete(memes).delete(meme);

  Future<List<Folder>> get getAllFolders => select(folders).get();

  Future<List<Folder>> get getAllFoldersEnabled =>
      (select(folders)..where((f) => f.scanningEnabled)).get();
}
