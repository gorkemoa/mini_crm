import '../core/base/base_viewmodel.dart';
import '../services/storage/file_export_service.dart';
import '../services/storage/file_import_service.dart';
import '../models/export_bundle_model.dart';

class DataViewModel extends BaseViewModel {
  final FileExportService _exportService;
  final FileImportService _importService;

  DataViewModel({
    required FileExportService exportService,
    required FileImportService importService,
  })  : _exportService = exportService,
        _importService = importService;

  ExportBundleModel? _previewBundle;
  bool _exportSuccess = false;
  bool _importSuccess = false;

  ExportBundleModel? get previewBundle => _previewBundle;
  bool get exportSuccess => _exportSuccess;
  bool get importSuccess => _importSuccess;

  Future<bool> export() async {
    setLoading(true);
    clearError();
    _exportSuccess = false;
    final result = await _exportService.exportToJson();
    setLoading(false);
    if (result.isSuccess) {
      _exportSuccess = true;
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }

  Future<bool> pickImportFile() async {
    setLoading(true);
    clearError();
    _previewBundle = null;
    final result = await _importService.pickAndPreview();
    setLoading(false);
    if (result.isSuccess) {
      _previewBundle = result.data;
      safeNotify();
      return _previewBundle != null;
    }
    setError(result.error);
    return false;
  }

  Future<bool> confirmImport() async {
    if (_previewBundle == null) return false;
    setLoading(true);
    clearError();
    _importSuccess = false;
    final result = await _importService.importBundle(_previewBundle!);
    setLoading(false);
    if (result.isSuccess) {
      _importSuccess = true;
      _previewBundle = null;
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }

  void clearPreview() {
    _previewBundle = null;
    safeNotify();
  }
}
