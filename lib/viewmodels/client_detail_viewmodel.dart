import '../core/base/base_viewmodel.dart';
import '../models/client_model.dart';
import '../models/debt_model.dart';
import '../models/project_model.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/debt_repository.dart';
import '../services/repositories/project_repository.dart';

class ClientDetailViewModel extends BaseViewModel {
  final ClientRepository _clientRepo;
  final DebtRepository _debtRepo;
  final ProjectRepository _projectRepo;

  ClientDetailViewModel({
    required ClientRepository clientRepository,
    required DebtRepository debtRepository,
    required ProjectRepository projectRepository,
  })  : _clientRepo = clientRepository,
        _debtRepo = debtRepository,
        _projectRepo = projectRepository;

  ClientModel? _client;
  List<DebtModel> _debts = [];
  List<ProjectModel> _projects = [];

  ClientModel? get client => _client;
  List<DebtModel> get debts => _debts;
  List<ProjectModel> get projects => _projects;

  Future<void> load(String clientId) async {
    setLoading(true);
    clearError();
    try {
      final results = await Future.wait([
        _clientRepo.getById(clientId),
        _debtRepo.getByClientId(clientId),
        _projectRepo.getByClientId(clientId),
      ]);
      _client = results[0] as ClientModel?;
      _debts = results[1] as List<DebtModel>;
      _projects = results[2] as List<ProjectModel>;
    } catch (e) {
      setError('errorClientDetailLoad');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh(String clientId) => load(clientId);
}
