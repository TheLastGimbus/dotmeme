import 'package:moor/moor.dart';

class Folders extends Table {
  IntColumn get id => integer()();

  /// Whether to show and scan memes from this folder
  BoolColumn get scanningEnabled =>
      boolean().withDefault(const Constant(false))();

  // This should help with media sync
  DateTimeColumn get lastModified =>
      dateTime().withDefault(currentDateAndTime)();
}
