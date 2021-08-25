import 'dart:io';
import 'dart:typed_data';

import 'package:filesize/filesize.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image/image.dart' as ui;
import 'package:logger/logger.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

import 'database/memebase.dart';
import 'ui/common/cubit/common_cache_cubit.dart';
import 'ui/pages/swiping/meme_info_dialog.dart';

final _log = GetIt.I<Logger>();

/// This file will contain some helpful independent functions and stuff for
/// manipulating images etc
///
/// I don't know where to put it yet, that's why it's directly in lib/ folder
/// Tho it will probably be moved somewhere else when more stuff like this comes

/// Adds text watermark to given image. Returned bytes are in .jpg format
///
/// [widthFraction] is how much width of original image watermark will take
Uint8List addTextWatermark(
  Uint8List image,
  String text, {
  double widthFraction = 0.3,
  int alpha = 120,
}) {
  final orig = ui.decodeImage(image);
  if (orig == null) throw "Can't decode image!";

  final font = ui.arial_48;
  var textWidth = 0.0;
  for (final c in text.characters) {
    textWidth += font.characterXAdvance(c) * 1.165;
  }

  const margin = 10;
  var watermark = ui.Image(textWidth.round() + margin * 2, 50 + (margin * 2));
  watermark = watermark.fill(Colors.white.value);
  watermark = ui.drawString(watermark, font, margin, margin, text,
      color: Colors.black.value);
  watermark = ui.colorOffset(watermark, alpha: alpha - 255);
  final scale = (orig.width * widthFraction) / watermark.width;
  watermark = ui.copyResize(
    watermark,
    width: (watermark.width * scale).round(),
    height: (watermark.height * scale).round(),
  );

  final withWater =
      ui.copyInto(orig, watermark, dstX: 0, dstY: (orig.height * 0.9).round());
  return Uint8List.fromList(ui.encodeJpg(withWater));
}

/// Save file to `tmp.[extension]` file in app cache dir
// This could be in another utils file
Future<File> writeTmpFile(Uint8List bytes, String extension) async {
  final dir = await pp.getTemporaryDirectory();
  final tmpFile = File(p.join(dir.path, 'tmp' + extension));
  return tmpFile.writeAsBytes(bytes);
}

Size? getImageSize(Uint8List image) {
  final img = ui.decodeImage(image);
  return img == null ? null : Size(img.width.toDouble(), img.height.toDouble());
}

Future<List<MemeProperty>> getMemeProperties(
    BuildContext context, Meme meme) async {
  final cacheCbt = context.read<CommonCacheCubit>();
  final ass = await cacheCbt.getAssetEntityWithCache(meme.id);
  if (ass == null) throw "WTF: Can't get $meme asset";
  final file = await cacheCbt.getFileWithCache(meme.id);
  if (file == null) throw "WTF: Can't get $meme asset";
  var width = ass.width;
  var height = ass.height;
  if (width <= 0 || height <= 0) {
    if (width != height) {
      _log.wtf("One dimension of $ass is 0 but other isn't");
    }
    final img = await cacheCbt.getImageWithCache(meme.id);
    if (img == null) {
      _log.wtf("Can't get image bytes of $meme ; $ass");
    } else {
      final size = getImageSize(img);
      width = size?.width.toInt() ?? 0;
      height = size?.height.toInt() ?? 0;
    }
  }
  return [
    MemeProperty(name: "Name", value: ass.title),
    MemeProperty(name: "Path", value: file.path),
    MemeProperty(name: "Size", value: filesize(await file.length())),
    MemeProperty(name: "Resolution", value: "$width x $height"),
    MemeProperty(name: "Last modified", value: ass.modifiedDateTime.toString()),
    MemeProperty(
        name: "Scanned text", value: meme.scannedText ?? "<not scanned yet>"),
  ];
}
