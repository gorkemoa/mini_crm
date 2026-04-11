import 'package:shared_preferences/shared_preferences.dart';

import '../../core/constants/storage_keys.dart';
import '../../models/enums.dart';

class AppSettingsService {
  final SharedPreferences _prefs;
  AppSettingsService(this._prefs);

  AppThemeMode get themeMode {
    final stored = _prefs.getString(StorageKeys.themeMode);
    return AppThemeMode.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => AppThemeMode.system,
    );
  }

  Future<void> setThemeMode(AppThemeMode mode) async {
    await _prefs.setString(StorageKeys.themeMode, mode.name);
  }

  String? get locale => _prefs.getString(StorageKeys.locale);

  Future<void> setLocale(String? languageCode) async {
    if (languageCode == null) {
      await _prefs.remove(StorageKeys.locale);
    } else {
      await _prefs.setString(StorageKeys.locale, languageCode);
    }
  }
}
