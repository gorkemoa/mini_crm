import 'package:flutter/material.dart';

import '../core/base/base_viewmodel.dart';
import '../models/enums.dart';
import '../services/storage/app_settings_service.dart';

class SettingsViewModel extends BaseViewModel {
  final AppSettingsService _settings;
  SettingsViewModel(this._settings);

  late AppThemeMode _themeMode;
  Locale? _locale;

  AppThemeMode get themeMode => _themeMode;
  Locale? get locale => _locale;

  void load() {
    _themeMode = _settings.themeMode;
    final lang = _settings.locale;
    _locale = lang != null ? Locale(lang) : null;
    safeNotify();
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    _themeMode = mode;
    await _settings.setThemeMode(mode);
    safeNotify();
  }

  Future<void> setLocale(String? languageCode) async {
    _locale = languageCode != null ? Locale(languageCode) : null;
    await _settings.setLocale(languageCode);
    safeNotify();
  }

  ThemeMode get flutterThemeMode => switch (_themeMode) {
        AppThemeMode.light => ThemeMode.light,
        AppThemeMode.dark => ThemeMode.dark,
        AppThemeMode.system => ThemeMode.system,
      };
}
