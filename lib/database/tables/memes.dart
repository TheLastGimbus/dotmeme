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

  // For sorting them
  /// WARNING: Turns out moor returns DateTimes in local time!
  /// This, for example, brakes tests!
  DateTimeColumn get lastModified =>
      dateTime().clientDefault(() => DateTime.now())();

  /// Text from OCR - can be null if not scanned yet
  TextColumn get scannedText => text().nullable()();

  /// Version of OCR scanner. If it's lower than current one, it means we have
  /// some new, better one, and we may want to re-scan those images
  ///
  /// The exception is when it's [-1] - then it means it was labeled by hand
  /// - don't touch this!
  ///
  /// It's nullable, because meme may not be scanned yet
  IntColumn get textScannerVersion => integer().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
