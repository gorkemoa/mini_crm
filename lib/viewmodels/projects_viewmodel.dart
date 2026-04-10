import '../core/base/base_viewmodel.dart';
import '../models/project_model.dart';
import '../services/repositories/project_repository.dart';

class ProjectsViewModel extends BaseViewModel {
  final ProjectRepository _repo;

  ProjectsViewModel({required ProjectRepository projectRepository})
      : _repo = projectRepository;

  List<ProjectModel> _all = [];
  List<ProjectModel> _filtered = [];
  ProjectStatus? _statusFilter;

  List<ProjectModel> get items => _filtered;
  ProjectStatus? get statusFilter => _statusFilter;

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      _all = await _repo.getAll();
      _applyFilter();
    } catch (e) {
      setError('errorProjectsLoad');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() => load();

  void filterByStatus(ProjectStatus? status) {
    _statusFilter = status;
    _applyFilter();
  }

  void _applyFilter() {
    if (_statusFilter == null) {
      _filtered = _all;
    } else {
      _filtered = _all.where((p) => p.status == _statusFilter).toList();
    }
    notifyListeners();
  }

  Future<void> delete(String id) async {
    try {
      await _repo.delete(id);
      _all.removeWhere((p) => p.id == id);
      _applyFilter();
    } catch (e) {
      setError('errorProjectDelete');
    }
  }
}
