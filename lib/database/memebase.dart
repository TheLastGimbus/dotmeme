import 'dart:async';
import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'tables/folders.dart';
import 'tables/memes.dart';

part 'memebase.g.dart';

@UseMoor(tables: [Folders, Memes])
class Memebase extends _$Memebase {
  Memebase(QueryExecutor q) : super(q);

  Future<List<Meme>> get allMemes => select(memes).get();

  static const databaseFileName = 'memebase_v1.sqlite';

  static LazyDatabase get diskDatabase {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, databaseFileName));
      return VmDatabase(file);
    });
  }

  static VmDatabase get virtualDatabase => VmDatabase.memory();

  @override
  int get schemaVersion => 1;
}
