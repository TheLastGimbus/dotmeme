import 'package:moor/moor.dart';

import 'memebase.dart';

extension Search on Memebase {
  MultiSelectable<Meme> searchMemes(String search) {
    return searchMemesByScannedText(
      search
          .trim()
          .replaceAll(RegExp('\'|"'), '')
          .split(RegExp(r'[ \t]+'))
          .map((e) => '"$e"*')
          .join(" OR "),
    );
  }
}
