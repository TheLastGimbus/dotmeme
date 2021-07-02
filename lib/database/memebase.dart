import 'dart:io';

import 'package:moor/ffi.dart';
import 'package:moor/moor.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'dart:async';

import 'tables/folders.dart';
import 'tables/memes.dart';

part 'memebase.g.dart';

const databaseFileName = 'memebase_v1.sqlite';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, databaseFileName));
    return VmDatabase(file);
  });
}

@UseMoor(tables: [Folders, Memes])
class Memebase extends _$Memebase {
  Memebase() : super(_openConnection());

  Future<List<Meme>> get allMemes => select(memes).get();

  @override
  int get schemaVersion => 1;
}
