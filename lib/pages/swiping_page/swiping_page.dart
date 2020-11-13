import 'dart:typed_data';

import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';

class SwipingPageRouteData {
  SwipingPageRouteData({this.startIndex, this.startThumbnail});

  final int startIndex;
  final Uint8List startThumbnail;
}

class SwipingPage extends StatefulWidget {
  SwipingPage({this.startIndex = 0, this.startThumbnail});

  final int startIndex;
  final Uint8List startThumbnail;

  @override
  _SwipingPageState createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  var fullscreen = false;

  // This doesn't need to be individual for each image, because
  // *in theory*, if it's true, user should not be able to scroll anywhere
  // => he should not be able to move to any other photo
  var isZoomed = false;

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

  Widget _loadingWidget(int index, Meme meme) => index == widget.startIndex
      ? Image.memory(
          widget.startThumbnail,
          fit: BoxFit.contain,
          gaplessPlayback: true,
        )
      : FutureBuilder(
          future: _getMemeThumbnail(meme),
          builder: (context, snapshot) => snapshot.hasData
              ? Image.memory(
                  snapshot.data,
                  fit: BoxFit.contain,
                  gaplessPlayback: true,
                )
              : SizedBox(),
        );

  Widget _pageWidget(int index, Meme meme) => FutureBuilder(
        future: _loadMemeToMemory(meme),
        builder: (context, AsyncSnapshot<Uint8List> snapshot) =>
            snapshot.hasData
                ? PhotoView(
                    imageProvider: MemoryImage(snapshot.data),
                    onTapUp: (ctx, details, value) {
                      setState(() {
                        fullscreen = !fullscreen;
                      });
                    },
                    gaplessPlayback: true,
                    minScale: PhotoViewComputedScale.contained,
                    maxScale: 50.0,
                    // Tell me if setting state so often is inefficient or smth
                    scaleStateChangedCallback: (newState) => setState(
                      () => isZoomed = newState != PhotoViewScaleState.initial,
                    ),
                    scaleStateCycle: (scaleState) {
                      print('ScaleState: $scaleState');
                      if (scaleState == PhotoViewScaleState.initial) {
                        return PhotoViewScaleState.covering;
                      } else {
                        return PhotoViewScaleState.initial;
                      }
                    },
                  )
                : Icon(Icons.lock_clock),
      );

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context);
    final _controller = PageController(initialPage: widget.startIndex);

    SystemChrome.setEnabledSystemUIOverlays(
        fullscreen ? [SystemUiOverlay.bottom] : SystemUiOverlay.values);

    // TODO: Show/hide app bar and options buttons (not present yet)
    //  on single press
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: fullscreen
          ? null
          : AppBar(
              leading: BackButton(),
              backgroundColor: Colors.transparent,
            ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            // If it's null it will set to platform default
            physics: isZoomed ? NeverScrollableScrollPhysics() : null,
            itemBuilder: (context, index) =>
                _pageWidget(index, homeProvider.memesList[index]),
            itemCount: homeProvider.memesList.length,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () async {
                    var asset = await AssetEntity.fromId(
                      homeProvider.memesList[_controller.page.round()].id
                          .toString(),
                    );
                    var file = await asset.file;
                    var bytes = await file.readAsBytes();
                    Share.file(
                      'Shere meme',
                      asset.title,
                      bytes,
                      'image/${path.extension(asset.title).replaceFirst('.', '')}',
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
