import 'dart:io';

import 'ocr_scanner.dart';

class TerminalOcrScanner implements OcrScanner {
  static const _outputFile = "_ocr_output";

  @override
  Future<String> scan(File file) async {
    final res = await Process.run("tesseract", [
      "--tessdata-dir",
      "assets/tessdata/",
      file.path,
      _outputFile,
    ]);
    if (res.exitCode != 0) {
      print(res);
      print("res.exitCode");
      print(res.exitCode);
      print("res.stdout");
      print(res.stdout);
      print("res.stderr");
      print(res.stderr);
      throw "tesseract return non-0 code";
    }
    return await File(_outputFile + ".txt").readAsString();
  }
}
