import 'dart:typed_data';

import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as nImage;
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

  int _currentPage = 0;

  Future<Uint8List> _loadMemeToMemory(Meme meme) async {
    var asset = await AssetEntity.fromId(meme.id.toString());
    var file = await asset.file;
    var bytes = await file.readAsBytes();
    return bytes;
  }

  Future<Uint8List> _getMemeThumbnail(Meme meme) async {
    var asset = await AssetEntity.fromId(meme.id.toString());
    return await asset.thumbData;
  }

  Widget _loadingWidget(int index, Meme meme) => index == startIndex
      ? Image.memory(
          startThumbnail,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        )
      : FutureBuilder(
          future: _loadMemeToMemory(meme),
          builder: (context, snapshot) => snapshot.hasData
              ? Image.memory(
                  snapshot.data,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                )
              : SizedBox(),
        );

  // TODO: When page is not *fully* swiped, two heroes fly on screen :/
  // This also sometimes happens when opening end closing
  // *some* images (random?), even if not swiped.
  Widget _pageWidget(int index, Meme meme) => FutureBuilder(
        future: _loadMemeToMemory(meme),
        builder: (context, AsyncSnapshot<Uint8List> snapshot) => snapshot.hasData
            ? PhotoView(
                imageProvider: MemoryImage(snapshot.data),
                loadingBuilder: (ctx, event) => _loadingWidget(index, meme),
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
                meme,
              ),
      );

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context);
    final _controller = PageController(initialPage: startIndex);
    _currentPage = startIndex;

    // TODO: Show/hide app bar and options buttons (not present yet)
    //  on single press
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: BackButton(),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              var asset = await AssetEntity.fromId(
                homeProvider.memesList[_currentPage].id.toString(),
              );
              var file = await asset.file;
              var image = nImage.decodeNamedImage(
                  await file.readAsBytes(), asset.title);
              nImage.drawString(
                image,
                nImage.arial_24,
                image.width ~/ 12,
                image.height - image.height ~/ 8,
                'Found with .meme',
                color: Colors.white.value,
              );
              Share.file(
                'Shere meme',
                asset.title,
                nImage.encodeJpg(image),
                'image/*',
              );
            },
          )
        ],
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: PhotoViewGallery.builder(
        pageController: _controller,
        builder: (context, index) => PhotoViewGalleryPageOptions.customChild(
          child: _pageWidget(index, homeProvider.memesList[index]),
        ),
        gaplessPlayback: true,
        onPageChanged: (now) => _currentPage = now,
        itemCount: homeProvider.memesList.length,
      ),
    );
  }
}
