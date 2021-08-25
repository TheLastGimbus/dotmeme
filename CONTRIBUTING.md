# Contributing

Wanna contribute? Marvelous! Every little bugfix or typo fix is very much welcome!

## Running the app yourself

Everything you need to know to happily run `flutter run` or `flutter test` is in [BUILD.md](BUILD.md)

## I want to add some feature - where do I start?

I think I made folder hierarchy pretty basic and intuitive - there is no crazy "clean code" architecture or something, because I was too lazy to read it :sparkling_heart:

- stuff that analyzes the memes (text scanning, other computer vision stuff) is in `analysis/`
- anything that executes in background (foreground service scanning for memes etc) is in `background/`
- anything database-ish (table definitions, search, queries) is in `database/`
- stuff that manages media on device ("get all folders with images" etc) is in `device_media/`
- everything UI (and also little bit of logic) is in `ui/`
  - `common/` folder contains common stuff like cubits or widgets that are used in whole app
  - `pages/` contain folders with all pages

Besides from above description, most file should contain nice documentation of what they are at the top - some folders even contain their own `README.md` files for broader explanations :ok_hand: :rocket:

If you ever feel like you don't know where to start or what can/should you do - feel welcome to ask on Discord or other community platform :sparkling_heart:

## Okay, I made some changes - what now?

There is a CI set up that won't pass any PRs if they are unformatted/have liter warnings/don't pass tests, so:
- run `flutter format lib` to be sure
- make sure you don't have any warnings from `flutter analyze`
- run `flutter test test/unit test/widget`
  If, for some weird dependencies reason, you are unable to run tests yourself, you can leave it to CI :) But trust me, you will save yourself a lot of time :hourglass:

Always think about future people (that may be you!) that will work with code you wrote:
- leave some comments or documentation for anything non-obvious
- give Tom Scott a watch :) https://www.youtube.com/watch?v=LZM9YdO_QKk
  (I know this app isn't life-critical at all - it's just a worth watch :sparkling_heart:)

If you made any advance changes - write some tests! It's fun, and actually, sometimes way faster to develop with than restarting the app and re-clicking some menus

Now go ahead and submit your PR! I can't promise anything, but I will try to review it as fast as I can :rocket:

Thanks very much again :smiling_face_with_three_hearts:
