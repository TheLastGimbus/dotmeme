import 'dart:typed_data';

import 'package:dotmeme/device_media/media_manager.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../database/memebase.dart';

class SwipingPage extends StatelessWidget {
  final List<Meme> memes;
  final int initialIndex;

  const SwipingPage({Key? key, required this.memes, this.initialIndex = 0})
      : super(key: key);

  Future<Uint8List?> _getImage(Meme meme) async {
    final _mm = GetIt.I<MediaManager>();
    final asset = await _mm.assetEntityFromId(meme.id.toString());
    if (asset == null) return null;
    assert(asset.type == AssetType.image, "Non-images are not supported yet");
    final file = await asset.file;
    if (file == null) return null;
    return file.readAsBytes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: PageController(initialPage: initialIndex),
        itemCount: memes.length,
        itemBuilder: (context, index) => GestureDetector(
          child: _image(memes[index]),
          onVerticalDragEnd: (details) {
            if (details.velocity.pixelsPerSecond.direction > 0) {
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  Widget _image(Meme meme) {
    return FutureBuilder(
      future: _getImage(meme),
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
