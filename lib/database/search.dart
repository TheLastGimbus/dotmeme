/// This file should contain *all* stuff that the UI finally uses
/// That is, you should be able to *safely* throw in any text from input fields
/// here, and it will parse and sanitize everything, and give you end results
import 'package:moor/moor.dart';

import 'memebase.dart';

extension Search on Memebase {
  /// Default way to *search the memes*. Throw in raw user input here, and it
  /// will give you *the memes*
  // IDEA: Filters - like certain folder, sizes, file types etc
  MultiSelectable<Meme> searchMemes(String search) {
    return searchMemesByScannedText(
      search
          .trim()
          // Sanitise " and ' chars to prevent SQL injections
          // NOTE: I am *very* unsure if this is enough ;_;
          .replaceAll(RegExp('\'|"'), '')
          // Split them into words...
          .split(RegExp(r'[ \t]+'))
          // ...put all into "" so they are safe and '*' to match suffixes...
          .map((e) => '"$e"*')
          // ...and add "OR" not to care about order
          .join(" OR "),
    );
  }
}
