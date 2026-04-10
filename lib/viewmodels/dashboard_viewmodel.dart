import '../core/base/base_viewmodel.dart';
import '../models/debt_model.dart';
import '../models/project_model.dart';
import '../models/reminder_model.dart';
import '../services/repositories/debt_repository.dart';
import '../services/repositories/project_repository.dart';
import '../services/repositories/lead_repository.dart';
import '../services/repositories/income_repository.dart';
import '../services/repositories/reminder_repository.dart';

class DashboardViewModel extends BaseViewModel {
  final DebtRepository _debtRepo;
  final ProjectRepository _projectRepo;
  final LeadRepository _leadRepo;
  final IncomeRepository _incomeRepo;
  final ReminderRepository _reminderRepo;

  DashboardViewModel({
    required DebtRepository debtRepository,
    required ProjectRepository projectRepository,
    required LeadRepository leadRepository,
    required IncomeRepository incomeRepository,
    required ReminderRepository reminderRepository,
  })  : _debtRepo = debtRepository,
        _projectRepo = projectRepository,
        _leadRepo = leadRepository,
        _incomeRepo = incomeRepository,
        _reminderRepo = reminderRepository;

  double _totalPendingDebt = 0;
  List<ProjectModel> _upcomingProjects = [];
  int _activeLeadCount = 0;
  double _thisMonthIncome = 0;
  List<ReminderModel> _todayReminders = [];
  List<DebtModel> _overdueDebts = [];

  double get totalPendingDebt => _totalPendingDebt;
  List<ProjectModel> get upcomingProjects => _upcomingProjects;
  int get activeLeadCount => _activeLeadCount;
  double get thisMonthIncome => _thisMonthIncome;
  List<ReminderModel> get todayReminders => _todayReminders;
  List<DebtModel> get overdueDebts => _overdueDebts;

  String get defaultCurrency => 'TRY';

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      final results = await Future.wait([
        _debtRepo.getTotalPending(),
        _projectRepo.getActive(),
        _leadRepo.countActive(),
        _incomeRepo.getTotalThisMonth(),
        _reminderRepo.getToday(),
        _debtRepo.getPendingAndOverdue(),
      ]);
      _totalPendingDebt = results[0] as double;
      _upcomingProjects = (results[1] as List<ProjectModel>).take(3).toList();
      _activeLeadCount = results[2] as int;
      _thisMonthIncome = results[3] as double;
      _todayReminders = results[4] as List<ReminderModel>;
      _overdueDebts = (results[5] as List<DebtModel>)
          .where((d) => d.isOverdue)
          .take(3)
          .toList();
    } catch (e) {
      setError('Veriler yüklenemedi.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() => load();
}
