import '../core/base/base_viewmodel.dart';
import '../models/lead_model.dart';
import '../services/repositories/lead_repository.dart';

class LeadsViewModel extends BaseViewModel {
  final LeadRepository _repo;

  LeadsViewModel({required LeadRepository leadRepository})
      : _repo = leadRepository;

  List<LeadModel> _all = [];
  List<LeadModel> _filtered = [];
  LeadStage? _stageFilter;

  List<LeadModel> get items => _filtered;
  LeadStage? get stageFilter => _stageFilter;

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      _all = await _repo.getAll();
      _applyFilter();
    } catch (e) {
      setError('Leadler yüklenemedi.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() => load();

  void filterByStage(LeadStage? stage) {
    _stageFilter = stage;
    _applyFilter();
  }

  void _applyFilter() {
    if (_stageFilter == null) {
      _filtered = _all;
    } else {
      _filtered = _all.where((l) => l.stage == _stageFilter).toList();
    }
    notifyListeners();
  }

  Future<void> delete(String id) async {
    try {
      await _repo.delete(id);
      _all.removeWhere((l) => l.id == id);
      _applyFilter();
    } catch (e) {
      setError('Lead silinemedi.');
    }
  }
}
