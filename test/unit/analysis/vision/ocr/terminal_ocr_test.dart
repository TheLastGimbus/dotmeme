import 'dart:io';

import 'package:dotmeme/analysis/vision/ocr/terminal_ocr_scanner.dart';
import 'package:flutter_test/flutter_test.dart';

const _ss1 = """6a © 18:36:14 © #1 0 GAO

Allow dotmeme to access photos
and media on your device?
\f""";

const _iphone = """Me leaving the apple
store with an Ban
12 in my mouth:

a

 
\f""";

void main() {
  test("Test if TerminalOcrScanner is working", () async {
    final ocr = TerminalOcrScanner();
    expect(
      await ocr.scan(
          File('test/_test_media/paths/Screenshots/2021-07-10-205430.png')),
      _ss1,
    );
    expect(
      await ocr.scan(File('test/_test_media/paths/Reddit/iphone_rule.jpg')),
      _iphone,
    );
  });
}
