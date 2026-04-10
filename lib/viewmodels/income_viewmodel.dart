import '../core/base/base_viewmodel.dart';
import '../models/income_model.dart';
import '../services/repositories/income_repository.dart';

class IncomeViewModel extends BaseViewModel {
  final IncomeRepository _repo;

  IncomeViewModel({required IncomeRepository incomeRepository})
      : _repo = incomeRepository;

  List<IncomeModel> _all = [];
  Map<String, double> _byPlatform = {};
  double _thisMonthTotal = 0;

  List<IncomeModel> get items => _all;
  Map<String, double> get byPlatform => _byPlatform;
  double get thisMonthTotal => _thisMonthTotal;

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      final results = await Future.wait([
        _repo.getAll(),
        _repo.getTotalByPlatform(),
        _repo.getTotalThisMonth(),
      ]);
      _all = results[0] as List<IncomeModel>;
      _byPlatform = results[1] as Map<String, double>;
      _thisMonthTotal = results[2] as double;
    } catch (e) {
      setError('errorIncomeLoad');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() => load();

  Future<void> delete(String id) async {
    try {
      await _repo.delete(id);
      _all.removeWhere((i) => i.id == id);
      _thisMonthTotal = _all
          .where((i) {
            final now = DateTime.now();
            return i.date.year == now.year && i.date.month == now.month;
          })
          .fold(0, (sum, i) => sum + i.amount);
      notifyListeners();
    } catch (e) {
      setError('errorIncomeDelete');
    }
  }
}
