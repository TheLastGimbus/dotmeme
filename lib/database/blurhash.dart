import 'dart:async';

import 'package:blurhash_dart/blurhash_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as img;
import 'package:moor/moor.dart';

import '../device_media/media_manager.dart';
import 'memebase.dart';

final _mm = GetIt.I<MediaManager>();

String _getHash(Uint8List thumb) => BlurHash.encode(
      img.decodeImage(thumb.toList())!,
      numCompX: 5,
      numCompY: 5,
    ).hash;

extension Blurhash on Memebase {
  Stream<int> encodeBlurhashes() async* {
    final q = (select(memes).join([
      innerJoin(folders, folders.id.equalsExp(memes.folderId)),
    ]));
    q.where(
      folders.scanningEnabled.equals(true) /*& memes.blurhash.equals(null)*/,
    );
    for (final meme in await q.map((row) => row.readTable(memes)).get()) {
      final w = Stopwatch()..start();
      final ass = await _mm.assetEntityFromId(meme.id.toString());
      final thumb = await ass!.thumbDataWithSize(10, 10, quality: 60);
      final bh = await compute(_getHash, thumb!);
      print("bh took ${w.elapsedMilliseconds}ms");
      await update(memes).replace(meme.copyWith(blurhash: bh));
    }
  }
}
