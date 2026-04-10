import '../core/base/base_viewmodel.dart';
import '../core/constants/app_constants.dart';
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
      setError('Dışa aktarma başarısız: $e');
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
      setError('Dosya okunamadı: $e');
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
      setError('İçe aktarma başarısız: $e');
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
