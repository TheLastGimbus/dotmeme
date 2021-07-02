# Testing

dotmeme has many dependencies on platform for core features, like tesseract_ocr, or photo_manager

As much as it's possible, we try to move those dependencies to some classes that we can put (and later hot-swap) in `lib/di.dart`

Right now, we only have database there :P

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
