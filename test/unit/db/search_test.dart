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

  group("Search functionality", () {
    test("raw query", () async {
      final db = Memebase(Memebase.virtualDatabase);
      // Maybe move this to setup() ?
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
      expectResults(String string, Set<int> ids) async {
        final result = await db.searchMemesByScannedText(string).get();
        expect(result.map((e) => e.id).toSet(), ids);
      }

      await expectResults("this", {54352, 65436, 90352, 90675});
      await expectResults("and", {90352, 34503});
      await expectResults("number", {54352, 65436, 90352});
      await expectResults("thats OR is", {54352, 65436, 90352, 90675, 34503});
    });
  });
}
