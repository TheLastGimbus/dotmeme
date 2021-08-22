import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as ui;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
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
            InkWell(
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(Icons.share, color: Colors.white),
              ),
              onTap: () async {
                // TODO: Move this to separate logic
                final currentMeme = widget.memes[pageCtrl.page!.round()];
                final imageBytes =
                    await cacheCbt.getImageWithCache(currentMeme.id);
                if (imageBytes == null) throw "$currentMeme bytes is null!";
                final orig = ui.decodeImage(imageBytes);
                if (orig == null) throw "Can't decode $currentMeme!";

                // Watermark will take 1/Nth of image width
                const sizeFraction = 3.0;
                const alpha = 120;
                var watermark = ui.Image(630, 70);
                watermark = watermark.fill(Colors.white.value);
                watermark = ui.drawString(
                  watermark,
                  ui.arial_48,
                  10,
                  10,
                  "Found with (new) dotmeme!",
                  color: Colors.black.value,
                );
                watermark = ui.colorOffset(watermark, alpha: alpha - 255);
                final scale = (orig.width / sizeFraction) / watermark.width;
                watermark = ui.copyResize(
                  watermark,
                  width: (watermark.width * scale).round(),
                  height: (watermark.height * scale).round(),
                );

                var withWater = ui.copyInto(orig, watermark,
                    dstX: 0, dstY: (orig.height * 0.9).round());
                final dir = await getApplicationDocumentsDirectory();
                final tmpFile = File(p.join(dir.path, 'tmp.png'));
                final w = await tmpFile.writeAsBytes(ui.encodePng(withWater));

                await Share.shareFiles([w.path]);
              },
              // No watermark on long press
              onLongPress: () async {
                // TODO: Move this to separate logic
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
                ? Image.memory(snap.data!)
                : const Icon(Icons.warning)
            : const Icon(Icons.autorenew);
      },
    );
  }
}
