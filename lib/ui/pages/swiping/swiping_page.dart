import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:share_plus/share_plus.dart';

import '../../../database/memebase.dart';
import '../../common/cubit/common_cache_cubit.dart';

class SwipingPage extends StatefulWidget {
  final List<Meme> memes;
  final int initialIndex;

  const SwipingPage({Key? key, required this.memes, this.initialIndex = 0})
      : super(key: key);

  @override
  _SwipingPageState createState() => _SwipingPageState();
}

class _SwipingPageState extends State<SwipingPage> {
  late PageController pageCtrl;

  @override
  void initState() {
    super.initState();
    pageCtrl = PageController(initialPage: widget.initialIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: pageCtrl,
            itemCount: widget.memes.length,
            itemBuilder: (context, index) => GestureDetector(
              child: _image(context, widget.memes[index]),
              onVerticalDragEnd: (details) {
                if (details.velocity.pixelsPerSecond.direction > 0) {
                  Navigator.of(context).pop();
                }
              },
            ),
          ),
          Align(alignment: Alignment.bottomCenter, child: _bottomBar(context)),
        ],
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
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: () async {
                // TODO: Watermark
                final currentMeme = widget.memes[pageCtrl.page!.round()];
                final file = await cacheCbt.getFileWithCache(currentMeme.id);
                if (file == null) {
                  throw "Can't share meme $currentMeme because file is null!";
                }
                Share.shareFiles([file.path]);
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
                ? Image.memory(snap.data!)
                : const Icon(Icons.warning)
            : const Icon(Icons.autorenew);
      },
    );
  }
}
