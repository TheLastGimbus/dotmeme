import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class SwipingPageRouteData {
  SwipingPageRouteData(this.startIndex);

  final int startIndex;
}

class SwipingPage extends StatelessWidget {
  // TODO: Change this to get memes from Provider or something
  SwipingPage({this.startIndex = 0});

  final int startIndex;

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context);
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
            imageProvider: AssetImage(homeProvider.memesList[index]),
            minScale: PhotoViewComputedScale.contained,
            maxScale: 50.0,
            scaleStateCycle: (scaleState) {
              print('ScaleState: $scaleState');
              if (scaleState == PhotoViewScaleState.initial) {
                return PhotoViewScaleState.covering;
              } else {
                return PhotoViewScaleState.initial;
              }
            },
            // User is at control ;)
            heroAttributes: PhotoViewHeroAttributes(
              tag: 'meme$index',
              transitionOnUserGestures: true,
            ),
          );
        },
        itemCount: homeProvider.memesList.length,
      ),
    );
  }
}
