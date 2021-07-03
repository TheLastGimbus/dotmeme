import 'package:moor/moor.dart';

class Folders extends Table {
  IntColumn get id => integer()();

  // IT IS WORTH IT
  TextColumn get name => text()();

  /// Whether to show and scan memes from this folder
  BoolColumn get scanningEnabled =>
      boolean().withDefault(const Constant(false))();

  // This should help with media sync
  DateTimeColumn get lastModified =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
