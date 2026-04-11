import '../core/base/base_viewmodel.dart';
import '../models/client_model.dart';
import '../models/enums.dart';
import '../services/repositories/client_repository.dart';

class ClientsViewModel extends BaseViewModel {
  final ClientRepository _repository;
  ClientsViewModel(this._repository);

  List<ClientModel> _allClients = [];
  String _searchQuery = '';
  ClientStatus? _statusFilter;

  List<ClientModel> get clients {
    return _allClients.where((c) {
      final matchesSearch = _searchQuery.isEmpty ||
          c.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (c.companyName?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (c.email?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesStatus = _statusFilter == null || c.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  String get searchQuery => _searchQuery;
  ClientStatus? get statusFilter => _statusFilter;
  bool get isEmpty => _allClients.isEmpty;
  bool get isFilteredEmpty => clients.isEmpty;
  int get totalCount => _allClients.length;

  Future<void> load() async {
    setLoading(true);
    clearError();
    final result = await _repository.getAll();
    result.fold(
      onSuccess: (data) => _allClients = data,
      onFailure: (e) => setError(e),
    );
    setLoading(false);
  }

  Future<void> refresh() => load();

  void setSearch(String query) {
    _searchQuery = query;
    safeNotify();
  }

  void setStatusFilter(ClientStatus? status) {
    _statusFilter = status;
    safeNotify();
  }

  Future<bool> delete(String id) async {
    final result = await _repository.delete(id);
    if (result.isSuccess) {
      _allClients.removeWhere((c) => c.id == id);
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }
}
