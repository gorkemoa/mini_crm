import '../core/base/base_viewmodel.dart';
import '../core/utils/id_utils.dart';
import '../models/lead_model.dart';
import '../models/enums.dart';
import '../services/repositories/lead_repository.dart';

class LeadFormViewModel extends BaseViewModel {
  final LeadRepository _repository;
  LeadFormViewModel(this._repository);

  bool get isEditMode => _editId != null;
  String? _editId;

  String name = '';
  String source = '';
  LeadStage stage = LeadStage.newLead;
  String estimatedBudget = '';
  String currency = 'USD';
  DateTime? nextFollowUpDate;
  String note = '';

  void loadForEdit(LeadModel lead) {
    _editId = lead.id;
    name = lead.name;
    source = lead.source ?? '';
    stage = lead.stage;
    estimatedBudget = lead.estimatedBudget?.toString() ?? '';
    currency = lead.currency ?? 'USD';
    nextFollowUpDate = lead.nextFollowUpDate;
    note = lead.note ?? '';
    safeNotify();
  }

  Future<bool> submit() async {
    setLoading(true);
    clearError();

    final parsedBudget = estimatedBudget.trim().isEmpty
        ? null
        : double.tryParse(estimatedBudget.replaceAll(',', '.'));
    if (estimatedBudget.trim().isNotEmpty && parsedBudget == null) {
      setError('Please enter a valid budget');
      setLoading(false);
      return false;
    }

    final now = DateTime.now();
    final lead = LeadModel(
      id: _editId ?? IdUtils.generate(),
      name: name.trim(),
      source: source.trim().isEmpty ? null : source.trim(),
      stage: stage,
      estimatedBudget: parsedBudget,
      currency: estimatedBudget.trim().isEmpty ? null : currency,
      nextFollowUpDate: nextFollowUpDate,
      note: note.trim().isEmpty ? null : note.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final result = isEditMode ? await _repository.update(lead) : await _repository.create(lead);
    setLoading(false);
    if (result.isFailure) {
      setError(result.error);
      return false;
    }
    return true;
  }
}
