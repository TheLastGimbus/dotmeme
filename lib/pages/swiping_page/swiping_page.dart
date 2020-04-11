import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

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
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: PhotoViewGallery.builder(
        pageController: _controller,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: AssetImage(imagesList[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: 50.0, // User is at control ;)
            heroAttributes: PhotoViewHeroAttributes(
              tag: 'meme$index',
              transitionOnUserGestures: true,
            ),
          );
        },
        itemCount: imagesList.length,
      ),
    );
  }
}
