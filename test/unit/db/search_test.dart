import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/database/search.dart';
import 'package:dotmeme/database/tables/memes.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:moor/moor.dart';

void main() {
  const _memez = {
    54352: 'this is text number one',
    65436: 'this however is text number two',
    90352: 'and this, unexpectedly, is text number three',
    90675: 'oh this is four',
    34503: '...and thats five...',
  };
  late Memebase db;
  setUp(() async {
    db = Memebase(Memebase.virtualDatabase);
    await db.batch((b) {
      b.insert(
        db.folders,
        Folder(
          id: 2137,
          name: "Dummy folder",
          scanningEnabled: true,
          lastModified: DateTime(2003),
        ),
      );
      for (final entry in _memez.entries) {
        b.insert(
          db.memes,
          Meme(
            id: entry.key,
            folderId: 2137,
            memeType: MemeType.image.index,
            lastModified: DateTime.now(),
            scannedText: entry.value,
            textScannerVersion: -1,
          ),
        );
      }
    });
    return db;
  });
  tearDown(() async {
    await db.close();
  });
  group("Search - basic FTS5 query", () {
    expectSearch(String string, Set<int> ids) async {
      final result = await db.searchMemesByScannedText(string).get();
      expect(result.map((e) => e.id).toSet(), ids);
    }

    test("basic raw search", () async {
      await expectSearch("this", {54352, 65436, 90352, 90675});
      await expectSearch("and", {90352, 34503});
      await expectSearch("number", {54352, 65436, 90352});
      await expectSearch("thats OR is", {54352, 65436, 90352, 90675, 34503});
    });
    test("delete", () async {
      await expectSearch("this", {54352, 65436, 90352, 90675});
      await (db.delete(db.memes)..where((e) => e.id.equals(65436))).go();
      await expectSearch("this", {54352, 90352, 90675});
      // Assert :100:% that fts table also deleted them
      final res = await db
          .customSelect(
              "SELECT * FROM memes_fts WHERE scanned_text MATCH 'this'")
          .get();
      expect(res.length, 3);
    });
    test("update", () async {
      await expectSearch("this", {54352, 65436, 90352, 90675});
      await (db.update(db.memes)..where((tbl) => tbl.id.equals(54352)))
          .write(const MemesCompanion(scannedText: Value("text number one")));
      await expectSearch("this", {65436, 90352, 90675});
    });
  });
  group("Search - high-level interface", () {
    test("basic search", () async {
      final res =
          await db.searchMemes("this should cover everything even five").get();
      expect(res.map((e) => e.id).toSet(), _memez.keys.toSet());
    });
    test("correct sort", () async {
      final res = await db
          .searchMemes("and this, unexpectedly, is text number three")
          .get();
      expect(res.length, _memez.length);
      expect(res.map((e) => e.id).first, 90352);
    });
    test("weird user gibberish resistance", () async {
      final res = await db
          .searchMemes(" \"'!@#\$%^&*()_+= :\"/'>< ** okay thats it  `~ ")
          .get();
      expect(res.map((e) => e.id).toSet(), {34503});
    });
    // TODO: Some for suffixes to work to :(
    test("only prefixes also match", () async {
      final res = await db.searchMemes("tha").get();
      expect(res.map((e) => e.id).toSet(), {34503});
    });
  });
  group("Fuzzy search", () {
    test("simple spell mistakes", () async {
      final fiwe = await db.searchMemes("fiwe").get();
      expect(fiwe.first.id, 34503);
      final unexpectedly = await db.searchMemes("unekspectedly").get();
      expect(unexpectedly.first.id, 90352);
    });
  }, skip: "Search isn't fuzzy yet :(");
}
