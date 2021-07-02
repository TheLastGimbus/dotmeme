import 'package:moor/moor.dart';

class Memes extends Table {
  IntColumn get id => integer()();

  IntColumn get folderId => integer()();
}
