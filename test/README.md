# Testing

dotmeme has many dependencies on platform for core features, like tesseract_ocr, or photo_manager

As much as it's possible, we try to move those dependencies to some classes that we can put (and later hot-swap) in `lib/di.dart`

Right now, we only have database and photo_manager there :)

## photo_manager

I actually managed to make kind of proxy class called `MediaManager`, which has it's mocked version (`MockMediaManager`), and is replaced instead of it with `get_it` while testing

It requires you to have folder with test media - set it up by running `./scripts/setup-test-media.sh`

More info about this is in `lib/device_media/mock_media_manager.dart` and at [test Github repo README.md](https://github.com/TheLastGimbus/__dotmeme_test_media__)

## moor

Moor requires `libsqlite3.so` to be installed on system where tests are run

> ### Installing sqlite
>
> We can't distribute an sqlite installation as a pub package (at least not as something that works outside of a Flutter build), so you need to ensure that you have the sqlite3 shared library installed on your system.
>
> On macOS, it's installed by default.
>
> On Linux, you can use the libsqlite3-dev package on Ubuntu and the sqlite3 package on Arch (other distros will have similar packages).
>
> On Windows, you can download 'Precompiled Binaries for Windows' and extract sqlite3.dll into a folder that's in your PATH environment variable. Then restart your device to ensure that all apps will run with this PATH change.
