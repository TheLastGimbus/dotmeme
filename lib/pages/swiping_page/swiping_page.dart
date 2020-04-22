import 'dart:io';
import 'dart:typed_data';

import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';

class SwipingPageRouteData {
  SwipingPageRouteData({this.startIndex, this.startThumbnail});

  final int startIndex;
  final Uint8List startThumbnail;
}

class SwipingPage extends StatelessWidget {
  SwipingPage({this.startIndex = 0, this.startThumbnail});

  final int startIndex;
  final Uint8List startThumbnail;

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

  Widget _pageWidget(int index, AssetEntity assetEntity) => FutureBuilder(
        future: assetEntity.file,
        builder: (context, AsyncSnapshot<File> snapshot) => PhotoView(
          imageProvider: snapshot.hasData
              ? FileImage(snapshot.data)
              : MemoryImage(startThumbnail),
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
          gaplessPlayback: !snapshot.hasData,
          heroAttributes: PhotoViewHeroAttributes(
            tag: 'meme$index',
            transitionOnUserGestures: true,
          ),
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
      body: PageView.builder(
        controller: _controller,
        itemBuilder: (context, index) =>
            _pageWidget(index, homeProvider.memesList[index]),
        itemCount: homeProvider.memesList.length,
      ),
    );
  }
}
