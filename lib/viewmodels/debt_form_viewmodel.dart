import '../core/base/base_viewmodel.dart';
import '../core/utils/id_utils.dart';
import '../models/client_model.dart';
import '../models/debt_model.dart';
import '../models/enums.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/debt_repository.dart';

class DebtFormViewModel extends BaseViewModel {
  final DebtRepository _debtRepo;
  final ClientRepository _clientRepo;

  DebtFormViewModel({required DebtRepository debtRepo, required ClientRepository clientRepo})
      : _debtRepo = debtRepo,
        _clientRepo = clientRepo;

  bool get isEditMode => _editId != null;
  String? _editId;

  List<ClientModel> clients = [];
  String? selectedClientId;
  String title = '';
  String amount = '';
  String currency = 'USD';
  DateTime? dueDate;
  DebtStatus status = DebtStatus.pending;
  String note = '';

  Future<void> loadClients() async {
    final result = await _clientRepo.getAll(status: ClientStatus.active);
    if (result.isSuccess) {
      clients = result.data!;
      safeNotify();
    }
  }

  void loadForEdit(DebtModel debt) {
    _editId = debt.id;
    selectedClientId = debt.clientId;
    title = debt.title;
    amount = debt.amount.toString();
    currency = debt.currency;
    dueDate = debt.dueDate;
    status = debt.status;
    note = debt.note ?? '';
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

    if (selectedClientId == null) {
      setError('Please select a client');
      setLoading(false);
      return false;
    }

    final now = DateTime.now();
    final debt = DebtModel(
      id: _editId ?? IdUtils.generate(),
      clientId: selectedClientId!,
      title: title.trim(),
      amount: parsedAmount,
      currency: currency,
      dueDate: dueDate,
      status: status,
      note: note.trim().isEmpty ? null : note.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final result = isEditMode ? await _debtRepo.update(debt) : await _debtRepo.create(debt);
    setLoading(false);
    if (result.isFailure) {
      setError(result.error);
      return false;
    }
    return true;
  }
}
