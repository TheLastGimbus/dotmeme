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
  TextColumn get id => text()();

  TextColumn get folderId => text()();

  TextColumn get scannedText => text().named('text').nullable()();
}

class Folders extends Table {
  TextColumn get id => text()();

  BoolColumn get scanningEnabled => boolean()();
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
}
