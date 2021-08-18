import 'dart:io';

import 'package:flutter_tesseract_ocr/flutter_tesseract_ocr.dart';

class OcrScanner {
  Future<String> scan(File file) {
    return FlutterTesseractOcr.extractText(file.path);
  }

  /// Scanner version - may be used to re-scan images when we have improve it
  /// in future
  int get version => 1;
}
