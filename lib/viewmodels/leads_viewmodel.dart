import '../core/base/base_viewmodel.dart';
import '../models/lead_model.dart';
import '../models/enums.dart';
import '../services/repositories/lead_repository.dart';

class LeadsViewModel extends BaseViewModel {
  final LeadRepository _repository;
  LeadsViewModel(this._repository);

  List<LeadModel> _allLeads = [];
  String _searchQuery = '';
  LeadStage? _stageFilter;

  List<LeadModel> get leads {
    return _allLeads.where((l) {
      final matchesSearch = _searchQuery.isEmpty ||
          l.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (l.source?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesStage = _stageFilter == null || l.stage == _stageFilter;
      return matchesSearch && matchesStage;
    }).toList();
  }

  bool get isEmpty => _allLeads.isEmpty;
  String get searchQuery => _searchQuery;
  LeadStage? get stageFilter => _stageFilter;

  int get wonCount => _allLeads.where((l) => l.stage == LeadStage.won).length;
  int get totalCount => _allLeads.length;
  double get winRate => totalCount == 0 ? 0 : (wonCount / totalCount * 100);

  Future<void> load() async {
    setLoading(true);
    clearError();
    final result = await _repository.getAll();
    result.fold(
      onSuccess: (data) => _allLeads = data,
      onFailure: (e) => setError(e),
    );
    setLoading(false);
  }

  Future<void> refresh() => load();

  void setSearch(String q) {
    _searchQuery = q;
    safeNotify();
  }

  void setStageFilter(LeadStage? s) {
    _stageFilter = s;
    safeNotify();
  }

  Future<bool> delete(String id) async {
    final result = await _repository.delete(id);
    if (result.isSuccess) {
      _allLeads.removeWhere((l) => l.id == id);
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }
}
