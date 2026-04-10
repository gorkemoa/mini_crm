import '../core/base/base_viewmodel.dart';
import '../models/debt_model.dart';
import '../services/repositories/debt_repository.dart';

class DebtsViewModel extends BaseViewModel {
  final DebtRepository _repo;

  DebtsViewModel({required DebtRepository debtRepository})
      : _repo = debtRepository;

  List<DebtModel> _all = [];
  List<DebtModel> _filtered = [];
  DebtStatus? _statusFilter;
  double _totalPending = 0;

  List<DebtModel> get items => _filtered;
  DebtStatus? get statusFilter => _statusFilter;
  double get totalPending => _totalPending;

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      final results = await Future.wait([
        _repo.getAll(),
        _repo.getTotalPending(),
      ]);
      _all = results[0] as List<DebtModel>;
      _totalPending = results[1] as double;
      _applyFilter();
    } catch (e) {
      setError('Alacaklar yüklenemedi.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() => load();

  void filterByStatus(DebtStatus? status) {
    _statusFilter = status;
    _applyFilter();
  }

  void _applyFilter() {
    if (_statusFilter == null) {
      _filtered = _all;
    } else {
      _filtered = _all.where((d) => d.status == _statusFilter).toList();
    }
    notifyListeners();
  }

  Future<void> delete(String id) async {
    try {
      await _repo.delete(id);
      _all.removeWhere((d) => d.id == id);
      _totalPending = _all
          .where((d) =>
              d.status == DebtStatus.pending ||
              d.status == DebtStatus.overdue ||
              d.status == DebtStatus.partial)
          .fold(0, (sum, d) => sum + d.amount);
      _applyFilter();
    } catch (e) {
      setError('Alacak silinemedi.');
    }
  }
}
