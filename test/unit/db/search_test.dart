import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/tables/memes.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const _memez = {
    54352: 'this is text number one',
    65436: 'this however is text number two',
    90352: 'and this, unexpectedly, is text number three',
    90675: 'oh this is four',
    34503: '...and thats five...',
  };
  setupTestDb() async {
    final db = Memebase(Memebase.virtualDatabase);
    await db.batch((b) {
      for (final entry in _memez.entries) {
        b.insert(
          db.memes,
          Meme(
            id: entry.key,
            folderId: 69,
            memeType: MemeType.image.index,
            lastModified: DateTime.now(),
            scannedText: entry.value,
            textScannerVersion: -1,
          ),
        );
      }
    });
    return db;
  }

  expectSearch(Memebase db, String string, Set<int> ids) async {
    final result = await db.searchMemesByScannedText(string).get();
    expect(result.map((e) => e.id).toSet(), ids);
  }

  group("FTS5 search functionality", () {
    test("basic raw search", () async {
      final db = await setupTestDb();
      await expectSearch(db, "this", {54352, 65436, 90352, 90675});
      await expectSearch(db, "and", {90352, 34503});
      await expectSearch(db, "number", {54352, 65436, 90352});
      await expectSearch(
          db, "thats OR is", {54352, 65436, 90352, 90675, 34503});
    });
    test("delete", () async {
      final db = await setupTestDb();
      await expectSearch(db, "this", {54352, 65436, 90352, 90675});
      await (db.delete(db.memes)..where((e) => e.id.equals(65436))).go();
      await expectSearch(db, "this", {54352, 90352, 90675});
      // Assert :100:% that fts table also deleted them
      final res = await db
          .customSelect(
          "SELECT * FROM memes_fts WHERE scanned_text MATCH 'this'")
          .get();
      expect(res.length, 3);
    });
  });
}
