import '../core/base/base_viewmodel.dart';
import '../models/income_model.dart';
import '../models/client_model.dart';
import '../services/repositories/income_repository.dart';
import '../services/repositories/client_repository.dart';

class IncomeViewModel extends BaseViewModel {
  final IncomeRepository _incomeRepo;
  final ClientRepository _clientRepo;

  IncomeViewModel({required IncomeRepository incomeRepo, required ClientRepository clientRepo})
      : _incomeRepo = incomeRepo,
        _clientRepo = clientRepo;

  List<IncomeModel> _allIncomes = [];
  Map<String, ClientModel> _clientsMap = {};
  String _searchQuery = '';

  List<IncomeModel> get incomes {
    if (_searchQuery.isEmpty) return _allIncomes;
    return _allIncomes.where((i) {
      final client = _clientsMap[i.clientId];
      return i.sourcePlatform?.toLowerCase().contains(_searchQuery.toLowerCase()) == true ||
          (client?.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false) ||
          (i.note?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false);
    }).toList();
  }

  ClientModel? clientFor(String? clientId) => clientId != null ? _clientsMap[clientId] : null;
  bool get isEmpty => _allIncomes.isEmpty;
  double get total => _allIncomes.fold(0.0, (s, i) => s + i.amount);

  double get monthlyTotal {
    final now = DateTime.now();
    return _allIncomes
        .where((i) => i.date.year == now.year && i.date.month == now.month)
        .fold(0.0, (s, i) => s + i.amount);
  }

  Future<void> load() async {
    setLoading(true);
    clearError();
    final results = await Future.wait([_incomeRepo.getAll(), _clientRepo.getAll()]);
    if (results[0].isSuccess) _allIncomes = results[0].data as List<IncomeModel>;
    else setError(results[0].error);
    if (results[1].isSuccess) {
      _clientsMap = {for (final c in results[1].data as List<ClientModel>) c.id: c};
    }
    setLoading(false);
  }

  Future<void> refresh() => load();

  void setSearch(String q) {
    _searchQuery = q;
    safeNotify();
  }

  Future<bool> delete(String id) async {
    final result = await _incomeRepo.delete(id);
    if (result.isSuccess) {
      _allIncomes.removeWhere((i) => i.id == id);
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }
}
