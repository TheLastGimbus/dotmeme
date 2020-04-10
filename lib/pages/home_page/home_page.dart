import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var memesPaths = [
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
    ];

    return Scaffold(
      appBar: AppBar(title: Text('Dotmeme')),
      body: GridView.builder(
        itemCount: memesPaths.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),

        itemBuilder: (context, index) {
          return Image.asset(memesPaths[index], fit: BoxFit.cover,);
        },
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search',
        child: Icon(Icons.search),
        onPressed: () {},
      ),
    );
  }
}
