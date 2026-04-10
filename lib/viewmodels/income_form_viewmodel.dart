import '../core/base/base_viewmodel.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/id_utils.dart';
import '../core/utils/validators.dart';
import '../models/client_model.dart';
import '../models/income_model.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/income_repository.dart';

class IncomeFormViewModel extends BaseViewModel {
  final IncomeRepository _incomeRepo;
  final ClientRepository _clientRepo;

  IncomeFormViewModel({
    required IncomeRepository incomeRepository,
    required ClientRepository clientRepository,
  })  : _incomeRepo = incomeRepository,
        _clientRepo = clientRepository;

  IncomeModel? _editingIncome;
  bool get isEditMode => _editingIncome != null;

  List<ClientModel> clients = [];
  String? selectedClientId;
  String sourcePlatform = '';
  String amount = '';
  String currency = AppConstants.defaultCurrency;
  DateTime date = DateTime.now();
  String note = '';

  bool _saved = false;
  bool get saved => _saved;

  Future<void> init({IncomeModel? editIncome}) async {
    setLoading(true);
    try {
      clients = await _clientRepo.getAll();
      if (editIncome != null) {
        _editingIncome = editIncome;
        selectedClientId = editIncome.clientId;
        sourcePlatform = editIncome.sourcePlatform ?? '';
        amount = editIncome.amount.toString();
        currency = editIncome.currency;
        date = editIncome.date;
        note = editIncome.note ?? '';
      }
    } catch (e) {
      setError('errorFormDataLoad');
    } finally {
      setLoading(false);
    }
  }

  String? validateAmount() => Validators.amount(amount);

  bool validate() => validateAmount() == null;

  Future<void> submit() async {
    if (!validate()) return;
    setLoading(true);
    clearError();
    try {
      final now = DateTime.now();
      final income = IncomeModel(
        id: _editingIncome?.id ?? IdUtils.generate(),
        sourcePlatform:
            sourcePlatform.trim().isEmpty ? null : sourcePlatform.trim(),
        clientId: selectedClientId,
        amount: Validators.parseAmount(amount)!,
        currency: currency,
        date: date,
        note: note.trim().isEmpty ? null : note.trim(),
        createdAt: _editingIncome?.createdAt ?? now,
        updatedAt: now,
      );
      if (isEditMode) {
        await _incomeRepo.update(income);
      } else {
        await _incomeRepo.create(income);
      }
      _saved = true;
      notifyListeners();
    } catch (e) {
      setError('errorIncomeSave');
    } finally {
      setLoading(false);
    }
  }
}
