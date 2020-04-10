import 'package:flutter/material.dart';

class SwipingPage extends StatefulWidget {
  SwipingPage({@required this.imagesList, this.startIndex});

  final List<String> imagesList;
  final startIndex;

  @override
  State<StatefulWidget> createState() => _SwipingPageState(
        imagesList: imagesList,
        startIndex: startIndex,
      );
}

class SwipingPageRouteData {
  final List<String> imagesList;
  final int startIndex;

  SwipingPageRouteData(this.imagesList, this.startIndex);
}

class _SwipingPageState extends State<SwipingPage> {
  // TODO: Change this to get memes from Provider or something
  _SwipingPageState({@required this.imagesList, this.startIndex = 0});

  List<String> imagesList;
  final int startIndex;

  @override
  Widget build(BuildContext context) {
    final _controller = PageController(initialPage: startIndex);
    return Scaffold(
      body: PageView.builder(
        controller: _controller,
        itemBuilder: (context, index) {
          return Image.asset(imagesList[index]);
        },
      ),
    );
  }
}
