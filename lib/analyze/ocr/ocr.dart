import 'dart:core';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:tesseract_ocr/tesseract_ocr.dart';

class Ocr {
  static Future<String> getText(
      {@required String imagePath, String language = 'eng'}) {
    return TesseractOcr.extractText(imagePath, language: language);
  }
}
