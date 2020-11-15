import 'package:dotmeme/preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesProvider with ChangeNotifier {
  SharedPreferences prefs;

  SharedPreferencesProvider() {
    SharedPreferences.getInstance().then((p) {
      prefs = p;
      notifyListeners();
    });
  }

  set themePref(ThemeModePreference themeMode) {
    prefs?.setInt(Preferences.KEY_THEME_MODE, themeMode.index);
    notifyListeners();
  }

  ThemeModePreference get themePref =>
      ThemeModePreference.values[prefs?.getInt(Preferences.KEY_THEME_MODE) ??
          ThemeModePreference.SYSTEM.index];

  ThemeMode get getThemeMode => ThemeMode.values[themePref.index];

  int getMemesGridCrossAxisCount({bool portrait = true}) => portrait
      ? prefs?.getInt(Preferences.KEY_MEMES_GRID_CROSS_AXIS_COUNT_PORTRAIT) ??
          Preferences.DEFAULT_MEMES_GRID_CROSS_AXIS_COUNT_PORTRAIT
      : prefs?.getInt(Preferences.KEY_MEMES_GRID_CROSS_AXIS_COUNT_LANDSCAPE) ??
          Preferences.DEFAULT_MEMES_GRID_CROSS_AXIS_COUNT_LANDSCAPE;

  void setMemesGridCrossAxisCount(int count, {bool portrait = true}) {
    prefs?.setInt(
      portrait
          ? Preferences.KEY_MEMES_GRID_CROSS_AXIS_COUNT_PORTRAIT
          : Preferences.KEY_MEMES_GRID_CROSS_AXIS_COUNT_LANDSCAPE,
      count,
    );
    notifyListeners();
  }
}
