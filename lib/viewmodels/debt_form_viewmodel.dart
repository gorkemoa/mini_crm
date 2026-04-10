import '../core/base/base_viewmodel.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/id_utils.dart';
import '../core/utils/validators.dart';
import '../models/client_model.dart';
import '../models/debt_model.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/debt_repository.dart';

class DebtFormViewModel extends BaseViewModel {
  final DebtRepository _debtRepo;
  final ClientRepository _clientRepo;

  DebtFormViewModel({
    required DebtRepository debtRepository,
    required ClientRepository clientRepository,
  })  : _debtRepo = debtRepository,
        _clientRepo = clientRepository;

  DebtModel? _editingDebt;
  bool get isEditMode => _editingDebt != null;

  List<ClientModel> clients = [];
  String? selectedClientId;
  String title = '';
  String amount = '';
  String currency = AppConstants.defaultCurrency;
  DateTime? dueDate;
  DebtStatus status = DebtStatus.pending;
  String note = '';

  bool _saved = false;
  bool get saved => _saved;

  Future<void> init({DebtModel? editDebt, String? preselectedClientId}) async {
    setLoading(true);
    try {
      clients = await _clientRepo.getAll();
      if (editDebt != null) {
        _editingDebt = editDebt;
        selectedClientId = editDebt.clientId;
        title = editDebt.title;
        amount = editDebt.amount.toString();
        currency = editDebt.currency;
        dueDate = editDebt.dueDate;
        status = editDebt.status;
        note = editDebt.note ?? '';
      } else if (preselectedClientId != null) {
        selectedClientId = preselectedClientId;
      }
    } catch (e) {
      setError('errorFormDataLoad');
    } finally {
      setLoading(false);
    }
  }

  String? validateClient() =>
      selectedClientId == null ? 'validationSelectClient' : null;
  String? validateTitle() => Validators.required(title, fieldName: 'Başlık');
  String? validateAmount() => Validators.amount(amount);

  bool validate() =>
      validateClient() == null &&
      validateTitle() == null &&
      validateAmount() == null;

  Future<void> submit() async {
    if (!validate()) return;
    setLoading(true);
    clearError();
    try {
      final now = DateTime.now();
      final debt = DebtModel(
        id: _editingDebt?.id ?? IdUtils.generate(),
        clientId: selectedClientId!,
        title: title.trim(),
        amount: Validators.parseAmount(amount)!,
        currency: currency,
        dueDate: dueDate,
        status: status,
        note: note.trim().isEmpty ? null : note.trim(),
        createdAt: _editingDebt?.createdAt ?? now,
        updatedAt: now,
      );
      if (isEditMode) {
        await _debtRepo.update(debt);
      } else {
        await _debtRepo.create(debt);
      }
      _saved = true;
      notifyListeners();
    } catch (e) {
      setError('errorDebtSave');
    } finally {
      setLoading(false);
    }
  }
}
