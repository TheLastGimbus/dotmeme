import 'package:moor/moor.dart';

enum MemeType {
  image,
  video,
  // Possibly more in the future - gif?
}

class Memes extends Table {
  IntColumn get id => integer()();

  IntColumn get folderId => integer()();

  /// [MemeType] - image or video
  IntColumn get memeType => integer()();

  /// Text from OCR - can be null if not scanned yet
  TextColumn get scannedText => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
