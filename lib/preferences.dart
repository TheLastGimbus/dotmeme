enum ThemeModePreference {
  SYSTEM,
  LIGHT,
  DARK,
}

class Preferences {
  static const KEY_THEME_MODE = 'pref_theme_mode';
  static final DEFAULT_THEME_MODE = ThemeModePreference.SYSTEM.index;
}
