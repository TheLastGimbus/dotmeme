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

  Future<Uint8List> _loadAssetToMemory(AssetEntity asset) async {
    var file = await asset.file;
    var bytes = await file.readAsBytes();
    return bytes;
  }

  Widget _loadingWidget(int index, AssetEntity assetEntity) =>
      index == startIndex
          ? Image.memory(
              startThumbnail,
              fit: BoxFit.contain,
              gaplessPlayback: true,
            )
          : FutureBuilder(
              future: assetEntity.thumbData,
              builder: (context, snapshot) => snapshot.hasData
                  ? Image.memory(
                      snapshot.data,
                      fit: BoxFit.contain,
                      gaplessPlayback: true,
                    )
                  : SizedBox(),
            );

  Widget _pageWidget(int index, AssetEntity assetEntity) => FutureBuilder(
        future: _loadAssetToMemory(assetEntity),
        builder: (context, AsyncSnapshot<Uint8List> snapshot) => Hero(
          tag: 'meme$index',
          child: snapshot.hasData
              ? PhotoView(
                  imageProvider: MemoryImage(snapshot.data),
                  loadingBuilder: (ctx, event) =>
                      _loadingWidget(index, assetEntity),
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
                  gaplessPlayback: true,
                )
              : _loadingWidget(
                  index,
                  assetEntity,
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
      body: PhotoViewGallery.builder(
        pageController: _controller,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: _pageWidget(index, homeProvider.memesList[index]),
        ),
        gaplessPlayback: true,
        itemCount: homeProvider.memesList.length,
      ),
    );
  }
}
