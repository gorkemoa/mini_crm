import '../core/base/base_viewmodel.dart';
import '../core/utils/id_utils.dart';
import '../models/client_model.dart';
import '../models/income_model.dart';
import '../models/enums.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/income_repository.dart';

class IncomeFormViewModel extends BaseViewModel {
  final IncomeRepository _incomeRepo;
  final ClientRepository _clientRepo;

  IncomeFormViewModel({required IncomeRepository incomeRepo, required ClientRepository clientRepo})
      : _incomeRepo = incomeRepo,
        _clientRepo = clientRepo;

  bool get isEditMode => _editId != null;
  String? _editId;

  List<ClientModel> clients = [];
  String? selectedClientId;
  String sourcePlatform = '';
  String amount = '';
  String currency = 'USD';
  DateTime date = DateTime.now();
  String note = '';

  Future<void> loadClients() async {
    final result = await _clientRepo.getAll(status: ClientStatus.active);
    if (result.isSuccess) {
      clients = result.data!;
      safeNotify();
    }
  }

  void loadForEdit(IncomeModel income) {
    _editId = income.id;
    selectedClientId = income.clientId;
    sourcePlatform = income.sourcePlatform ?? '';
    amount = income.amount.toString();
    currency = income.currency;
    date = income.date;
    note = income.note ?? '';
    safeNotify();
  }

  Future<bool> submit() async {
    setLoading(true);
    clearError();

    final parsedAmount = double.tryParse(amount.replaceAll(',', '.'));
    if (parsedAmount == null || parsedAmount <= 0) {
      setError('Please enter a valid amount');
      setLoading(false);
      return false;
    }

    final now = DateTime.now();
    final income = IncomeModel(
      id: _editId ?? IdUtils.generate(),
      sourcePlatform: sourcePlatform.trim().isEmpty ? null : sourcePlatform.trim(),
      clientId: selectedClientId,
      amount: parsedAmount,
      currency: currency,
      date: date,
      note: note.trim().isEmpty ? null : note.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final result = isEditMode ? await _incomeRepo.update(income) : await _incomeRepo.create(income);
    setLoading(false);
    if (result.isFailure) {
      setError(result.error);
      return false;
    }
    return true;
  }
}
