import 'package:moor/moor.dart';

class Folders extends Table {
  IntColumn get id => integer()();

  BoolColumn get scanningEnabled =>
      boolean().withDefault(const Constant(false))();
}
