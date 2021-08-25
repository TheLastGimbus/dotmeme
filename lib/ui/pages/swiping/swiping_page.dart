import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../../database/memebase.dart';
import '../../../image_utils.dart' as imutils;
import '../../common/cubit/common_cache_cubit.dart';
import 'meme_info_dialog.dart';

class SwipingPage extends StatefulWidget {
  final List<Meme> memes;
  final int initialIndex;

  const SwipingPage({Key? key, required this.memes, this.initialIndex = 0})
      : super(key: key);

  @override
  _SwipingPageState createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  final log = GetIt.I<Logger>();
  late PageController pageCtrl;
  var isZoomed = false;
  double? _statusBarHeight;
  var fullscreen = false;

  @override
  void initState() {
    super.initState();
    pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    _statusBarHeight ??= MediaQuery.of(context).padding.top;
    // TODO: Transparent system navigation bar
    SystemChrome.setEnabledSystemUIOverlays(
        fullscreen ? [SystemUiOverlay.bottom] : SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageCtrl,
            physics: isZoomed ? const NeverScrollableScrollPhysics() : null,
            itemCount: widget.memes.length,
            itemBuilder: (context, index) =>
                _image(context, widget.memes[index]),
          ),
          // TODO: Smooth disappear
          if (!fullscreen)
            Align(alignment: Alignment.topCenter, child: _topBar(context)),
          if (!fullscreen)
            Align(
                alignment: Alignment.bottomCenter, child: _bottomBar(context)),
        ],
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        height: _statusBarHeight! + 64,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.transparent, Colors.black54],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: _statusBarHeight),
            Row(
              children: [
                const BackButton(color: Colors.white),
                const Expanded(child: SizedBox()),
                InkWell(
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.info, color: Colors.white),
                  ),
                  onTap: () async {
                    final meme = widget.memes[pageCtrl.page!.round()];
                    final props =
                        await imutils.getMemeProperties(context, meme);
                    return showDialog(
                      context: context,
                      builder: (context) => MemeInfoDialog(properties: props),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBar(BuildContext context) {
    final cacheCbt = context.read<CommonCacheCubit>();
    return Material(
      color: Colors.transparent,
      child: Container(
        height: 64,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black54],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.share, color: Colors.white),
              ),
              onTap: () async {
                final currentMeme = widget.memes[pageCtrl.page!.round()];
                final bytes = await cacheCbt.getImageWithCache(currentMeme.id);
                if (bytes == null) throw "$currentMeme bytes is null!";
                // I tired to put this into compute(), but OMG is it unpractical
                // I don't care that ui hangs -_-
                final tmpFile = await imutils.writeTmpFile(
                  imutils.addTextWatermark(bytes, "Found with (new) dotmeme!"),
                  ".jpg",
                );
                await Share.shareFiles([tmpFile.path]);
              },
              // No watermark on long press
              onLongPress: () async {
                final currentMeme = widget.memes[pageCtrl.page!.round()];
                final file = await cacheCbt.getFileWithCache(currentMeme.id);
                if (file == null) throw "$currentMeme file is null!";
                await Share.shareFiles([file.path]);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _image(BuildContext context, Meme meme) {
    return FutureBuilder(
      future: context.read<CommonCacheCubit>().getImageWithCache(meme.id),
      builder: (context, AsyncSnapshot<Uint8List?> snap) {
        return snap.hasData
            ? snap.data != null
                ? PhotoView(
                    imageProvider: MemoryImage(snap.data!),
                    gaplessPlayback: true,
                    scaleStateChangedCallback: (newState) {
                      final _zoomed = newState != PhotoViewScaleState.initial;
                      if (_zoomed != isZoomed) {
                        isZoomed = _zoomed;
                        setState(() {});
                      }
                    },
                    maxScale: 50.0,
                    minScale: PhotoViewComputedScale.contained,
                    scaleStateCycle: (scaleState) =>
                        scaleState == PhotoViewScaleState.initial
                            ? PhotoViewScaleState.covering
                            : PhotoViewScaleState.initial,
                    onTapUp: (context, details, val) =>
                        setState(() => fullscreen = !fullscreen),
                  )
                : const Icon(Icons.warning)
            : const Icon(Icons.autorenew);
      },
    );
  }
}
