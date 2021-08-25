# Building the app

dotmeme has few dependencies to `flutter run` it, and few more to `flutter test`

If you have Ubuntu/Debian-based linux, you can run
```bash
./scripts/setup-test-media.sh
./scripts/setup-ocr.sh
```
(just like CI does) and everything should be ready :ok_hand:

## `flutter run`
To run it, you only need some `.traineddata` file for Tesseract-OCR to work. Download [one that I use](https://github.com/tesseract-ocr/tessdata_fast/raw/master/eng.traineddata), put it in `assets/tessdata/` and that should be it!

## `flutter test`
To run tests, you will need three more things
- test media that will be used to emulate memes on device:
  Run `./scripts/setup-test-media.sh`, or copy commands from it manually if you're on windoza
  (Oh, I forgot to mention it also requires python :hand_over_mouth:)
  You should end up with `dotmeme/test/_test_media` folder with correct `last modified` properties :ok_hand:
- `sqlite` binaries for `moor` database to work:
  - On Mac, you should have it preinstalled
  - On Ubuntu/Debian, `sudo apt install libsqlite3-dev`
  - Others/windoza, see: https://moor.simonbinder.eu/docs/testing/
- `tesseract` cli available to emulate ocr scanning on device:
  - On Mac: `brew install tesseract`
  - on Ubuntu/Debian: `sudo apt install tesseract-ocr`
  - Others/windoza: Windoza .exe should be available here: https://digi.bib.uni-mannheim.de/tesseract/ precisely: https://digi.bib.uni-mannheim.de/tesseract/tesseract-ocr-w64-setup-v4.1.0.20190314.exe
    Add it to your `PATH` and test if it runs - you may need to provide it `.traineddata` file mentioned above
    Google the rest, I don't have windoza to test it, sorry :/

What a ride! After all of that, `flutter test` should run smooth :grin: - otherwise, feel free to ask for help on Discord or other socials!
