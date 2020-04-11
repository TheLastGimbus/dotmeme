// This provider keeps sync of all memes list
import 'package:flutter/widgets.dart';

class MemesProvider with ChangeNotifier {
  MemesProvider() {
    _allMemes = [
      'assets/example_memes/t-regex.jpg',
      'assets/example_memes/fixing-bugs.jpg',
      'assets/example_memes/c-vs-rust.jpg',
      'assets/example_memes/github-build.png',
      'assets/example_memes/elon-distance.png',
      'assets/example_memes/esk8.jpg',
      'assets/example_memes/milk.jpg',
      'assets/example_memes/fire.jpg',
      'assets/example_memes/high-priority.jpg',
      'assets/example_memes/duck.jpg',
      'assets/example_memes/china.png',
      'assets/example_memes/beautiful.jpeg',
      'assets/example_memes/ding-ding.png',
      'assets/example_memes/first-kiss.png',
      'assets/example_memes/instagram.png',
      'assets/example_memes/iphone.jpeg',
      'assets/example_memes/linus-sniffs.jpeg',
      'assets/example_memes/pumped.png',
      'assets/example_memes/remote-work.jpg',
      'assets/example_memes/secrets.jpeg',
      'assets/example_memes/stonks.jpeg',
      'assets/example_memes/the-cpu.png',
    ];
  }

  // TODO: Change this to some fancy Meme class
  List<String> _allMemes;

  get getAllMemes => _allMemes;
}
