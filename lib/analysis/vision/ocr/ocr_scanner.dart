import 'dart:io';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class OcrScanner {
  Future<String> scan(File file) {
    return FlutterTesseractOcr.extractText(file.path);
  }
}
