import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as ui;
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart' as pp;

/// This file will contain some helpful independent functions and stuff for
/// manipulating images etc
///
/// I don't know where to put it yet, that's why it's directly in lib/ folder
/// Tho it will probably be moved somewhere else when more stuff like this comes

/// Adds text watermark to given image. Returned bytes are in .png format
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

  // Watermark will take 1/N-th of image width
  var watermark = ui.Image(630, 70);
  watermark = watermark.fill(Colors.white.value);
  watermark = ui.drawString(watermark, ui.arial_48, 10, 10, text,
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
  return Uint8List.fromList(ui.encodePng(withWater));
}

/// Save file to `tmp.[extension]` file in app cache dir
// This could be in another utils file
Future<File> writeTmpFile(Uint8List bytes, String extension) async {
  final dir = await pp.getTemporaryDirectory();
  final tmpFile = File(p.join(dir.path, 'tmp' + extension));
  return tmpFile.writeAsBytes(bytes);
}
