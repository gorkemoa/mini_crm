import '../core/base/base_viewmodel.dart';
import '../core/utils/id_utils.dart';
import '../models/client_model.dart';
import '../models/project_model.dart';
import '../models/enums.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/project_repository.dart';

class ProjectFormViewModel extends BaseViewModel {
  final ProjectRepository _projectRepo;
  final ClientRepository _clientRepo;

  ProjectFormViewModel({required ProjectRepository projectRepo, required ClientRepository clientRepo})
      : _projectRepo = projectRepo,
        _clientRepo = clientRepo;

  bool get isEditMode => _editId != null;
  String? _editId;

  List<ClientModel> clients = [];
  String? selectedClientId;
  String title = '';
  String description = '';
  DateTime? startDate;
  DateTime? endDate;
  String budget = '';
  String currency = 'USD';
  ProjectStatus status = ProjectStatus.planned;
  String note = '';

  Future<void> loadClients() async {
    final result = await _clientRepo.getAll(status: ClientStatus.active);
    if (result.isSuccess) {
      clients = result.data!;
      safeNotify();
    }
  }

  void loadForEdit(ProjectModel project) {
    _editId = project.id;
    selectedClientId = project.clientId;
    title = project.title;
    description = project.description ?? '';
    startDate = project.startDate;
    endDate = project.endDate;
    budget = project.budget?.toString() ?? '';
    currency = project.currency;
    status = project.status;
    note = project.note ?? '';
    safeNotify();
  }

  Future<bool> submit() async {
    setLoading(true);
    clearError();

    final parsedBudget = budget.trim().isEmpty ? null : double.tryParse(budget.replaceAll(',', '.'));
    if (budget.trim().isNotEmpty && parsedBudget == null) {
      setError('Please enter a valid budget');
      setLoading(false);
      return false;
    }

    final now = DateTime.now();
    final project = ProjectModel(
      id: _editId ?? IdUtils.generate(),
      clientId: selectedClientId,
      title: title.trim(),
      description: description.trim().isEmpty ? null : description.trim(),
      startDate: startDate,
      endDate: endDate,
      budget: parsedBudget,
      currency: currency,
      status: status,
      note: note.trim().isEmpty ? null : note.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final result = isEditMode ? await _projectRepo.update(project) : await _projectRepo.create(project);
    setLoading(false);
    if (result.isFailure) {
      setError(result.error);
      return false;
    }
    return true;
  }
}
