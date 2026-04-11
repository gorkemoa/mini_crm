import '../core/base/base_viewmodel.dart';
import '../services/repositories/client_repository.dart';
import '../services/repositories/debt_repository.dart';
import '../services/repositories/project_repository.dart';
import '../services/repositories/lead_repository.dart';
import '../services/repositories/income_repository.dart';
import '../services/repositories/reminder_repository.dart';
import '../models/reminder_model.dart';

class DashboardViewModel extends BaseViewModel {
  final ClientRepository _clients;
  final DebtRepository _debts;
  final ProjectRepository _projects;
  final LeadRepository _leads;
  final IncomeRepository _incomes;
  final ReminderRepository _reminders;

  DashboardViewModel({
    required ClientRepository clients,
    required DebtRepository debts,
    required ProjectRepository projects,
    required LeadRepository leads,
    required IncomeRepository incomes,
    required ReminderRepository reminders,
  })  : _clients = clients,
        _debts = debts,
        _projects = projects,
        _leads = leads,
        _incomes = incomes,
        _reminders = reminders;

  int _activeClients = 0;
  double _pendingDebtTotal = 0;
  int _activeProjects = 0;
  int _leadsToFollow = 0;
  double _monthlyIncome = 0;
  List<ReminderModel> _todayReminders = [];

  int get activeClients => _activeClients;
  double get pendingDebtTotal => _pendingDebtTotal;
  int get activeProjects => _activeProjects;
  int get leadsToFollow => _leadsToFollow;
  double get monthlyIncome => _monthlyIncome;
  List<ReminderModel> get todayReminders => _todayReminders;

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      final results = await Future.wait([
        _clients.getCount(),
        _debts.getPendingTotal(),
        _projects.getActiveCount(),
        _leads.getFollowUpCount(),
        _incomes.getMonthlyTotal(),
        _reminders.getTodayReminders(),
      ]);

      if (results[0].isSuccess) _activeClients = (results[0].data as int?) ?? 0;
      if (results[1].isSuccess) _pendingDebtTotal = (results[1].data as double?) ?? 0;
      if (results[2].isSuccess) _activeProjects = (results[2].data as int?) ?? 0;
      if (results[3].isSuccess) _leadsToFollow = (results[3].data as int?) ?? 0;
      if (results[4].isSuccess) _monthlyIncome = (results[4].data as double?) ?? 0;
      if (results[5].isSuccess) {
        _todayReminders = (results[5].data as List<ReminderModel>?) ?? [];
      }
    } catch (e) {
      setError(e.toString());
    }
    setLoading(false);
  }

  Future<void> refresh() => load();
}
