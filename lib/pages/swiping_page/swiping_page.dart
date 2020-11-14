import 'dart:typed_data';
import 'dart:ui';

import 'package:dotmeme/database/memebase.dart';
import 'package:dotmeme/providers/home_page_provider.dart';
import 'package:dotmeme/widgets/file_info.dart';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/cupertino.dart';
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

/// This is a page that contains a PageView with all memes from
/// homeProvider.memes
///
/// It is meant as main *meme watching* expeirience
class SwipingPage extends StatefulWidget {
  SwipingPage({this.startIndex = 0, this.startThumbnail});

  final int startIndex;
  final Uint8List startThumbnail;

  @override
  _SwipingPageState createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  var fullscreen = false;

  /// This is flag that is meant to be updated every time when meme zoom
  /// state changes, and set to [true] if it's zoomed.
  ///
  /// Then, we can block scrolling to avoid annoyance
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

  /// This is probably deprecated. It was meant to help with [Hero]
  ///
  /// But we fuck Hero so it's useless for now
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

  /// This is single page containing one meme, that is zoomable etc
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
                : snapshot.hasError
                    ? Center(
                        child: Text(
                          'Sorry, there was some error '
                          'when loading this meme :c',
                        ),
                      )
                    : SizedBox(),
      );

  @override
  Widget build(BuildContext context) {
    final homeProvider = Provider.of<HomePageProvider>(context);
    final _controller = PageController(initialPage: widget.startIndex);
    final theme = Theme.of(context);

    SystemChrome.setEnabledSystemUIOverlays(
        fullscreen ? [SystemUiOverlay.bottom] : SystemUiOverlay.values);

    List<Color> _gradientColors = [
      Colors.black38,
      Colors.black26,
      Colors.transparent
    ];

    /// This is our custom AppBar, so we have more control over how it will
    /// look and behave
    topBar() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.bottomCenter,
              colors: _gradientColors,
            ),
          ),
          child: SafeArea(
            child: Container(
              height: kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // TODO: Add some info about meme object itself
                  // Scanned text, OCR metadata or something
                  BackButton(),
                  IconButton(
                    icon: Icon(Icons.info_outline),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Properties',
                              style: theme.textTheme.headline6),
                          content: FileInfo(
                            assetId: homeProvider
                                .memesList[_controller.page.round()].id
                                .toString(),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          insetPadding: EdgeInsets.all(16),
                          actions: [
                            FlatButton(
                              child: Text('Ok'),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );

    /// This is our custom BottomBar (seems like [Scaffold] doesn't even have
    /// something like what we need). It has most of usefull buttons - like
    /// share, delete, etc.
    bottomBar() => Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.center,
              end: Alignment.topCenter,
              colors: _gradientColors,
            ),
          ),
          height: kToolbarHeight,
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
        );

    return Scaffold(
      backgroundColor: Colors.black,
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
            alignment: Alignment.topCenter,
            child: AnimatedCrossFade(
              duration: kTabScrollDuration,
              crossFadeState: fullscreen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              // crossFadeState: CrossFadeState.showFirst,
              firstChild: topBar(),
              secondChild: Flex(direction: Axis.horizontal),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedCrossFade(
              duration: kTabScrollDuration,
              crossFadeState: fullscreen
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              firstChild: bottomBar(),
              secondChild: Flex(direction: Axis.horizontal),
            ),
          ),
        ],
      ),
    );
  }
}
