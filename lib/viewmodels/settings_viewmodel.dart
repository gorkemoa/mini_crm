import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/base/base_viewmodel.dart';
import '../core/constants/app_constants.dart';
import '../core/constants/storage_keys.dart';
import '../services/storage/file_export_service.dart';
import '../services/storage/file_import_service.dart';
import '../models/export_bundle_model.dart';

class SettingsViewModel extends BaseViewModel {
  final FileExportService _exportService;
  final FileImportService _importService;

  SettingsViewModel({
    required FileExportService exportService,
    required FileImportService importService,
  })  : _exportService = exportService,
        _importService = importService;

  String get appVersion => AppConstants.appVersion;

  // ── Locale ──────────────────────────────────────────────────────────────

  Locale _locale = const Locale('tr');
  Locale get locale => _locale;

  static const List<Map<String, String>> supportedLanguages = [
    {'code': 'en', 'name': 'English', 'native': 'English'},
    {'code': 'tr', 'name': 'Turkish', 'native': 'Türkçe'},
    {'code': 'ar', 'name': 'Arabic', 'native': 'العربية'},
    {'code': 'zh', 'name': 'Chinese', 'native': '中文'},
    {'code': 'es', 'name': 'Spanish', 'native': 'Español'},
    {'code': 'hi', 'name': 'Hindi', 'native': 'हिन्दी'},
    {'code': 'pt', 'name': 'Portuguese', 'native': 'Português'},
    {'code': 'fr', 'name': 'French', 'native': 'Français'},
    {'code': 'id', 'name': 'Indonesian', 'native': 'Indonesia'},
    {'code': 'ja', 'name': 'Japanese', 'native': '日本語'},
    {'code': 'de', 'name': 'German', 'native': 'Deutsch'},
    {'code': 'ru', 'name': 'Russian', 'native': 'Русский'},
    {'code': 'ko', 'name': 'Korean', 'native': '한국어'},
    {'code': 'bn', 'name': 'Bengali', 'native': 'বাংলা'},
    {'code': 'ur', 'name': 'Urdu', 'native': 'اردو'},
    {'code': 'vi', 'name': 'Vietnamese', 'native': 'Tiếng Việt'},
    {'code': 'it', 'name': 'Italiano', 'native': 'Italiano'},
    {'code': 'fa', 'name': 'Persian', 'native': 'فارسی'},
    {'code': 'pl', 'name': 'Polish', 'native': 'Polski'},
    {'code': 'th', 'name': 'Thai', 'native': 'ภาษาไทย'},
  ];

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final code = prefs.getString(StorageKeys.locale) ?? 'tr';
    _locale = Locale(code);
    notifyListeners();
  }

  Future<void> setLocale(Locale locale) async {
    if (_locale == locale) return;
    _locale = locale;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.locale, locale.languageCode);
    notifyListeners();
  }

  // ── Export / Import ──────────────────────────────────────────────────────

  bool _exportSuccess = false;
  bool _importSuccess = false;
  ExportBundleModel? _pendingImport;

  bool get exportSuccess => _exportSuccess;
  bool get importSuccess => _importSuccess;
  ExportBundleModel? get pendingImport => _pendingImport;

  Future<void> exportData() async {
    setLoading(true);
    clearError();
    _exportSuccess = false;
    try {
      await _exportService.exportAndShare();
      _exportSuccess = true;
    } catch (e) {
      setError('errorExportFailed');
    } finally {
      setLoading(false);
    }
  }

  Future<void> pickImportFile() async {
    setLoading(true);
    clearError();
    _pendingImport = null;
    try {
      _pendingImport = await _importService.pickAndParse();
    } catch (e) {
      setError('errorFileRead');
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }

  Future<void> confirmImport() async {
    if (_pendingImport == null) return;
    setLoading(true);
    clearError();
    _importSuccess = false;
    try {
      await _importService.importBundle(_pendingImport!);
      _importSuccess = true;
      _pendingImport = null;
    } catch (e) {
      setError('errorImportFailed');
    } finally {
      setLoading(false);
    }
    notifyListeners();
  }

  void cancelImport() {
    _pendingImport = null;
    notifyListeners();
  }
}
