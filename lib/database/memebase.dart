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
  TextColumn get id => text().customConstraint("UNIQUE")();

  TextColumn get folderId => text()();

  TextColumn get scannedText => text().named('text').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class Folders extends Table {
  TextColumn get id => text().customConstraint("UNIQUE")();

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

  Future createFolder(FoldersCompanion folder, {bool ignoreFail = false}) {
    return into(folders).insert(
      folder,
      mode: ignoreFail ? InsertMode.insertOrIgnore : InsertMode.insert,
    );
  }

  Future deleteFolder(FoldersCompanion folder) {
    return delete(folders).delete(folder);
  }

  Future<List<Meme>> get getAllMemes => select(memes).get();

  Future<List<Folder>> get getAllFolders => select(folders).get();
}
