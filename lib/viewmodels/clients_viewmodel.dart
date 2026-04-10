import '../core/base/base_viewmodel.dart';
import '../models/client_model.dart';
import '../services/repositories/client_repository.dart';

class ClientsViewModel extends BaseViewModel {
  final ClientRepository _repo;

  ClientsViewModel({required ClientRepository clientRepository})
      : _repo = clientRepository;

  List<ClientModel> _all = [];
  List<ClientModel> _filtered = [];
  String _searchQuery = '';
  ClientStatus? _statusFilter;

  List<ClientModel> get items => _filtered;
  String get searchQuery => _searchQuery;
  ClientStatus? get statusFilter => _statusFilter;

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      _all = await _repo.getAll();
      _applyFilter();
    } catch (e) {
      setError('errorClientsLoad');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() => load();

  void search(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void filterByStatus(ClientStatus? status) {
    _statusFilter = status;
    _applyFilter();
  }

  void _applyFilter() {
    var result = _all;
    if (_statusFilter != null) {
      result = result.where((c) => c.status == _statusFilter).toList();
    }
    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      result = result
          .where((c) =>
              c.fullName.toLowerCase().contains(q) ||
              (c.companyName?.toLowerCase().contains(q) ?? false) ||
              (c.email?.toLowerCase().contains(q) ?? false))
          .toList();
    }
    _filtered = result;
    notifyListeners();
  }

  Future<void> deleteClient(String id) async {
    try {
      await _repo.delete(id);
      _all.removeWhere((c) => c.id == id);
      _applyFilter();
    } catch (e) {
      setError('errorClientDelete');
    }
  }
}
