import 'package:dotmeme/pages/swiping_page/swiping_page.dart';
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

    final searchFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          textInputAction: TextInputAction.search,
          focusNode: searchFocusNode,
          minLines: 1,
          maxLines: 2,
          decoration: InputDecoration.collapsed(hintText: 'Search'),
          cursorColor: Colors.white,
          onSubmitted: (input) {
            print('entered $input');
            FocusScope.of(context).dispose();
          },
        ),
      ),
      body: GridView.builder(
        itemCount: memesPaths.length,
        gridDelegate:
        SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(
                '/swiping_page',
                arguments: SwipingPageRouteData(memesPaths, index),
              );
            },
            child: Hero(
              tag: 'meme$index:$index',
              child: Image.asset(
                memesPaths[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
      drawer: Drawer(),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Search',
        child: Icon(Icons.search),
        onPressed: () {
          FocusScope.of(context).requestFocus(searchFocusNode);
        },
      ),
    );
  }
}
