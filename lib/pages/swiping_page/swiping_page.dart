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
  SwipingPage({this.startIndex = 0});

  final int startIndex;

  PhotoViewGalleryPageOptions _photoViewPage(int index, String assetPath) =>
      PhotoViewGalleryPageOptions(
        imageProvider: AssetImage(assetPath),
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
        builder: (context, index) =>
            _photoViewPage(index, homeProvider.memesList[index]),
        itemCount: homeProvider.memesList.length,
      ),
    );
  }
}
