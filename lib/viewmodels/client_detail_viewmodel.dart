import '../core/base/base_viewmodel.dart';
import '../models/client_model.dart';
import '../models/debt_model.dart';
import '../models/project_model.dart';
import '../models/enums.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/debt_repository.dart';
import '../services/repositories/project_repository.dart';

class ClientDetailViewModel extends BaseViewModel {
  final ClientRepository _clientRepo;
  final DebtRepository _debtRepo;
  final ProjectRepository _projectRepo;

  ClientDetailViewModel({
    required ClientRepository clientRepo,
    required DebtRepository debtRepo,
    required ProjectRepository projectRepo,
  })  : _clientRepo = clientRepo,
        _debtRepo = debtRepo,
        _projectRepo = projectRepo;

  ClientModel? _client;
  List<DebtModel> _debts = [];
  List<ProjectModel> _projects = [];

  ClientModel? get client => _client;
  List<DebtModel> get debts => _debts;
  List<ProjectModel> get projects => _projects;

  double get totalDebt => _debts
      .where((d) => d.status != DebtStatus.paid)
      .fold(0.0, (sum, d) => sum + d.amount);

  int get activeProjectCount =>
      _projects.where((p) => p.status == ProjectStatus.active).length;

  Future<void> load(String clientId) async {
    setLoading(true);
    clearError();

    final results = await Future.wait([
      _clientRepo.getById(clientId),
      _debtRepo.getAll(clientId: clientId),
      _projectRepo.getAll(clientId: clientId),
    ]);

    final clientResult = results[0];
    final debtsResult = results[1];
    final projectsResult = results[2];

    if (clientResult.isSuccess) _client = clientResult.data as ClientModel?;
    if (debtsResult.isSuccess) _debts = debtsResult.data as List<DebtModel>;
    if (projectsResult.isSuccess) _projects = projectsResult.data as List<ProjectModel>;

    if (clientResult.isFailure) setError(clientResult.error);

    setLoading(false);
  }

  Future<void> refresh() {
    if (_client == null) return Future.value();
    return load(_client!.id);
  }

  Future<bool> deleteClient() async {
    if (_client == null) return false;
    final result = await _clientRepo.delete(_client!.id);
    return result.isSuccess;
  }
}
