import '../core/base/base_viewmodel.dart';
import '../models/debt_model.dart';
import '../models/enums.dart';
import '../services/repositories/debt_repository.dart';
import '../services/repositories/client_repository.dart';
import '../models/client_model.dart';

class DebtsViewModel extends BaseViewModel {
  final DebtRepository _debtRepo;
  final ClientRepository _clientRepo;

  DebtsViewModel({required DebtRepository debtRepo, required ClientRepository clientRepo})
      : _debtRepo = debtRepo,
        _clientRepo = clientRepo;

  List<DebtModel> _allDebts = [];
  Map<String, ClientModel> _clientsMap = {};
  String _searchQuery = '';
  DebtStatus? _statusFilter;

  List<DebtModel> get debts {
    return _allDebts.where((d) {
      final client = _clientsMap[d.clientId];
      final matchesSearch = _searchQuery.isEmpty ||
          d.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          (client?.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
      final matchesStatus = _statusFilter == null || d.status == _statusFilter;
      return matchesSearch && matchesStatus;
    }).toList();
  }

  ClientModel? clientFor(String clientId) => _clientsMap[clientId];
  String get searchQuery => _searchQuery;
  DebtStatus? get statusFilter => _statusFilter;
  bool get isEmpty => _allDebts.isEmpty;

  double get pendingTotal => _allDebts
      .where((d) => d.status == DebtStatus.pending || d.status == DebtStatus.overdue)
      .fold(0.0, (s, d) => s + d.amount);

  double get overdueTotal => _allDebts
      .where((d) => d.status == DebtStatus.overdue || d.isOverdue)
      .fold(0.0, (s, d) => s + d.amount);

  Future<void> load() async {
    setLoading(true);
    clearError();
    final debtsResult = await _debtRepo.getAll();
    final clientsResult = await _clientRepo.getAll();

    if (debtsResult.isSuccess) {
      _allDebts = _updateOverdueStatus(debtsResult.data!);
    } else {
      setError(debtsResult.error);
    }

    if (clientsResult.isSuccess) {
      _clientsMap = {for (final c in clientsResult.data!) c.id: c};
    }

    setLoading(false);
  }

  List<DebtModel> _updateOverdueStatus(List<DebtModel> debts) {
    return debts.map((d) {
      if (d.status == DebtStatus.pending && d.isOverdue) {
        return d.copyWith(status: DebtStatus.overdue);
      }
      return d;
    }).toList();
  }

  Future<void> refresh() => load();

  void setSearch(String q) {
    _searchQuery = q;
    safeNotify();
  }

  void setStatusFilter(DebtStatus? s) {
    _statusFilter = s;
    safeNotify();
  }

  Future<bool> delete(String id) async {
    final result = await _debtRepo.delete(id);
    if (result.isSuccess) {
      _allDebts.removeWhere((d) => d.id == id);
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }
}
