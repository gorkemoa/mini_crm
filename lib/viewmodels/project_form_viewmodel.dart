import '../core/base/base_viewmodel.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/id_utils.dart';
import '../core/utils/validators.dart';
import '../models/client_model.dart';
import '../models/project_model.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/project_repository.dart';

class ProjectFormViewModel extends BaseViewModel {
  final ProjectRepository _projectRepo;
  final ClientRepository _clientRepo;

  ProjectFormViewModel({
    required ProjectRepository projectRepository,
    required ClientRepository clientRepository,
  })  : _projectRepo = projectRepository,
        _clientRepo = clientRepository;

  ProjectModel? _editingProject;
  bool get isEditMode => _editingProject != null;

  List<ClientModel> clients = [];
  String? selectedClientId;
  String title = '';
  String description = '';
  DateTime? startDate;
  DateTime? endDate;
  String budget = '';
  String currency = AppConstants.defaultCurrency;
  ProjectStatus status = ProjectStatus.planned;
  String note = '';

  bool _saved = false;
  bool get saved => _saved;

  Future<void> init({ProjectModel? editProject, String? preselectedClientId}) async {
    setLoading(true);
    try {
      clients = await _clientRepo.getAll();
      if (editProject != null) {
        _editingProject = editProject;
        selectedClientId = editProject.clientId;
        title = editProject.title;
        description = editProject.description ?? '';
        startDate = editProject.startDate;
        endDate = editProject.endDate;
        budget = editProject.budget?.toString() ?? '';
        currency = editProject.currency;
        status = editProject.status;
        note = editProject.note ?? '';
      } else if (preselectedClientId != null) {
        selectedClientId = preselectedClientId;
      }
    } catch (e) {
      setError('Form verileri yüklenemedi.');
    } finally {
      setLoading(false);
    }
  }

  String? validateClient() =>
      selectedClientId == null ? 'Müşteri seçiniz.' : null;
  String? validateTitle() => Validators.required(title, fieldName: 'Başlık');

  bool validate() =>
      validateClient() == null && validateTitle() == null;

  Future<void> submit() async {
    if (!validate()) return;
    setLoading(true);
    clearError();
    try {
      final now = DateTime.now();
      final project = ProjectModel(
        id: _editingProject?.id ?? IdUtils.generate(),
        clientId: selectedClientId!,
        title: title.trim(),
        description: description.trim().isEmpty ? null : description.trim(),
        startDate: startDate,
        endDate: endDate,
        budget: budget.trim().isEmpty ? null : Validators.parseAmount(budget),
        currency: currency,
        status: status,
        note: note.trim().isEmpty ? null : note.trim(),
        createdAt: _editingProject?.createdAt ?? now,
        updatedAt: now,
      );
      if (isEditMode) {
        await _projectRepo.update(project);
      } else {
        await _projectRepo.create(project);
      }
      _saved = true;
      notifyListeners();
    } catch (e) {
      setError('Proje kaydedilemedi.');
    } finally {
      setLoading(false);
    }
  }
}
