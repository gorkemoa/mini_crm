import '../core/base/base_viewmodel.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/id_utils.dart';
import '../core/utils/validators.dart';
import '../models/lead_model.dart';
import '../services/repositories/lead_repository.dart';

class LeadFormViewModel extends BaseViewModel {
  final LeadRepository _repo;

  LeadFormViewModel({required LeadRepository leadRepository})
      : _repo = leadRepository;

  LeadModel? _editingLead;
  bool get isEditMode => _editingLead != null;

  String name = '';
  String source = '';
  LeadStage stage = LeadStage.newLead;
  String estimatedBudget = '';
  String currency = AppConstants.defaultCurrency;
  DateTime? nextFollowUpDate;
  String note = '';

  bool _saved = false;
  bool get saved => _saved;

  void loadForEdit(LeadModel lead) {
    _editingLead = lead;
    name = lead.name;
    source = lead.source ?? '';
    stage = lead.stage;
    estimatedBudget = lead.estimatedBudget?.toString() ?? '';
    currency = lead.currency;
    nextFollowUpDate = lead.nextFollowUpDate;
    note = lead.note ?? '';
    notifyListeners();
  }

  String? validateName() => Validators.required(name, fieldName: 'İsim');

  bool validate() => validateName() == null;

  Future<void> submit() async {
    if (!validate()) return;
    setLoading(true);
    clearError();
    try {
      final now = DateTime.now();
      final lead = LeadModel(
        id: _editingLead?.id ?? IdUtils.generate(),
        name: name.trim(),
        source: source.trim().isEmpty ? null : source.trim(),
        stage: stage,
        estimatedBudget: estimatedBudget.trim().isEmpty
            ? null
            : Validators.parseAmount(estimatedBudget),
        currency: currency,
        nextFollowUpDate: nextFollowUpDate,
        note: note.trim().isEmpty ? null : note.trim(),
        createdAt: _editingLead?.createdAt ?? now,
        updatedAt: now,
      );
      if (isEditMode) {
        await _repo.update(lead);
      } else {
        await _repo.create(lead);
      }
      _saved = true;
      notifyListeners();
    } catch (e) {
      setError('Lead kaydedilemedi.');
    } finally {
      setLoading(false);
    }
  }
}
