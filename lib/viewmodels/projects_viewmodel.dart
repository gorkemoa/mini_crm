import '../core/base/base_viewmodel.dart';
import '../models/project_model.dart';
import '../models/enums.dart';
import '../models/client_model.dart';
import '../services/repositories/project_repository.dart';
import '../services/repositories/client_repository.dart';

class ProjectsViewModel extends BaseViewModel {
  final ProjectRepository _projectRepo;
  final ClientRepository _clientRepo;

  ProjectsViewModel({required ProjectRepository projectRepo, required ClientRepository clientRepo})
      : _projectRepo = projectRepo,
        _clientRepo = clientRepo;

  List<ProjectModel> _allProjects = [];
  Map<String, ClientModel> _clientsMap = {};
  String _searchQuery = '';
  ProjectStatus? _statusFilter;

  List<ProjectModel> get projects {
    return _allProjects.where((p) {
      final client = _clientsMap[p.clientId];
      final matchesSearch = _searchQuery.isEmpty ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (client?.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesStatus = _statusFilter == null || p.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  ClientModel? clientFor(String? clientId) => clientId != null ? _clientsMap[clientId] : null;
  bool get isEmpty => _allProjects.isEmpty;
  String get searchQuery => _searchQuery;
  ProjectStatus? get statusFilter => _statusFilter;

  Future<void> load() async {
    setLoading(true);
    clearError();
    final projectsResult = await _projectRepo.getAll();
    final clientsResult = await _clientRepo.getAll();

    if (projectsResult.isSuccess) { _allProjects = projectsResult.data!; }
    else { setError(projectsResult.error); }

    if (clientsResult.isSuccess) {
      _clientsMap = {for (final c in clientsResult.data!) c.id: c};
    }

    setLoading(false);
  }

  Future<void> refresh() => load();

  void setSearch(String q) {
    _searchQuery = q;
    safeNotify();
  }

  void setStatusFilter(ProjectStatus? s) {
    _statusFilter = s;
    safeNotify();
  }

  Future<bool> delete(String id) async {
    final result = await _projectRepo.delete(id);
    if (result.isSuccess) {
      _allProjects.removeWhere((p) => p.id == id);
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }
}
