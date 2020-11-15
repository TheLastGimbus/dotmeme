enum ThemeModePreference {
  SYSTEM,
  LIGHT,
  DARK,
}

class Preferences {
  static const KEY_THEME_MODE = 'pref_theme_mode';
  static final DEFAULT_THEME_MODE = ThemeModePreference.SYSTEM.index;
  static const KEY_MEMES_GRID_CROSS_AXIS_COUNT_PORTRAIT =
      'pref.memes_grid.cross_axis_count.portrait';
  static const DEFAULT_MEMES_GRID_CROSS_AXIS_COUNT_PORTRAIT = 3;
  static const KEY_MEMES_GRID_CROSS_AXIS_COUNT_LANDSCAPE =
      'pref.memes_grid.cross_axis_count.landscape';
  static const DEFAULT_MEMES_GRID_CROSS_AXIS_COUNT_LANDSCAPE = 5;
}
