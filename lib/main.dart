import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'l10n/app_localizations.dart';
import 'themes/app_theme.dart';
import 'core/constants/app_constants.dart';
import 'core/constants/route_names.dart';
import 'services/database/local_database_initializer.dart';
import 'services/database/local_database_service.dart';
import 'services/repositories/client_repository.dart';
import 'services/repositories/debt_repository.dart';
import 'services/repositories/project_repository.dart';
import 'services/repositories/lead_repository.dart';
import 'services/repositories/income_repository.dart';
import 'services/repositories/reminder_repository.dart';
import 'services/storage/app_settings_service.dart';
import 'services/storage/file_export_service.dart';
import 'services/storage/file_import_service.dart';
import 'viewmodels/dashboard_viewmodel.dart';
import 'viewmodels/clients_viewmodel.dart';
import 'viewmodels/client_detail_viewmodel.dart';
import 'viewmodels/client_form_viewmodel.dart';
import 'viewmodels/debts_viewmodel.dart';
import 'viewmodels/debt_form_viewmodel.dart';
import 'viewmodels/projects_viewmodel.dart';
import 'viewmodels/project_form_viewmodel.dart';
import 'viewmodels/leads_viewmodel.dart';
import 'viewmodels/lead_form_viewmodel.dart';
import 'viewmodels/income_viewmodel.dart';
import 'viewmodels/income_form_viewmodel.dart';
import 'viewmodels/reminders_viewmodel.dart';
import 'viewmodels/reminder_form_viewmodel.dart';
import 'viewmodels/settings_viewmodel.dart';
import 'viewmodels/data_viewmodel.dart';
import 'models/client_model.dart';
import 'models/debt_model.dart';
import 'models/project_model.dart';
import 'models/lead_model.dart';
import 'models/income_model.dart';
import 'models/reminder_model.dart';
import 'views/app/app.dart';
import 'views/clients/client_detail_view.dart';
import 'views/clients/client_form_view.dart';
import 'views/debts/debt_detail_view.dart';
import 'views/debts/debt_form_view.dart';
import 'views/projects/projects_view.dart';
import 'views/projects/project_detail_view.dart';
import 'views/projects/project_form_view.dart';
import 'views/leads/lead_detail_view.dart';
import 'views/leads/lead_form_view.dart';
import 'views/income/income_view.dart';
import 'views/income/income_form_view.dart';
import 'views/reminders/reminders_view.dart';
import 'views/reminders/reminder_form_view.dart';
import 'views/settings/settings_view.dart';
import 'views/settings/export_data_view.dart';
import 'views/settings/import_data_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDatabaseFactory();

  final prefs = await SharedPreferences.getInstance();
  final db = LocalDatabaseService();

  final clientRepo = ClientRepository(db);
  final debtRepo = DebtRepository(db);
  final projectRepo = ProjectRepository(db);
  final leadRepo = LeadRepository(db);
  final incomeRepo = IncomeRepository(db);
  final reminderRepo = ReminderRepository(db);

  final settingsService = AppSettingsService(prefs);

  final exportService = FileExportService(
    clients: clientRepo,
    debts: debtRepo,
    projects: projectRepo,
    leads: leadRepo,
    incomes: incomeRepo,
    reminders: reminderRepo,
  );
  final importService = FileImportService(
    clients: clientRepo,
    debts: debtRepo,
    projects: projectRepo,
    leads: leadRepo,
    incomes: incomeRepo,
    reminders: reminderRepo,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SettingsViewModel(settingsService)..load(),
        ),
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            clients: clientRepo,
            debts: debtRepo,
            projects: projectRepo,
            leads: leadRepo,
            incomes: incomeRepo,
            reminders: reminderRepo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientsViewModel(clientRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => DebtsViewModel(
            debtRepo: debtRepo,
            clientRepo: clientRepo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectsViewModel(
            projectRepo: projectRepo,
            clientRepo: clientRepo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => LeadsViewModel(leadRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => IncomeViewModel(
            incomeRepo: incomeRepo,
            clientRepo: clientRepo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => RemindersViewModel(reminderRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => DataViewModel(
            exportService: exportService,
            importService: importService,
          ),
        ),
      ],
      child: _MiniCrmApp(
        clientRepo: clientRepo,
        debtRepo: debtRepo,
        projectRepo: projectRepo,
        leadRepo: leadRepo,
        incomeRepo: incomeRepo,
        reminderRepo: reminderRepo,
        settingsService: settingsService,
        exportService: exportService,
        importService: importService,
      ),
    ),
  );
}

class _MiniCrmApp extends StatelessWidget {
  final ClientRepository clientRepo;
  final DebtRepository debtRepo;
  final ProjectRepository projectRepo;
  final LeadRepository leadRepo;
  final IncomeRepository incomeRepo;
  final ReminderRepository reminderRepo;
  final AppSettingsService settingsService;
  final FileExportService exportService;
  final FileImportService importService;

  const _MiniCrmApp({
    required this.clientRepo,
    required this.debtRepo,
    required this.projectRepo,
    required this.leadRepo,
    required this.incomeRepo,
    required this.reminderRepo,
    required this.settingsService,
    required this.exportService,
    required this.importService,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsViewModel>(
      builder: (context, settings, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: settings.flutterThemeMode,
          locale: settings.locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AppShell(),
          onGenerateRoute: _generateRoute,
        );
      },
    );
  }

  Route<dynamic>? _generateRoute(RouteSettings routeSettings) {
    final args = routeSettings.arguments;
    switch (routeSettings.name) {
      // Screens pushed on top of AppShell (not in bottom nav tabs)
      case RouteNames.projects:
        return MaterialPageRoute(builder: (_) => const ProjectsView());

      case RouteNames.income:
        return MaterialPageRoute(builder: (_) => const IncomeView());

      case RouteNames.reminders:
        return MaterialPageRoute(builder: (_) => const RemindersView());

      case RouteNames.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());

      case RouteNames.exportData:
        return MaterialPageRoute(builder: (_) => const ExportDataView());

      case RouteNames.importData:
        return MaterialPageRoute(builder: (_) => const ImportDataView());

      // Client routes
      case RouteNames.clientDetail:
        final clientId = args as String;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ClientDetailViewModel(
              clientRepo: clientRepo,
              debtRepo: debtRepo,
              projectRepo: projectRepo,
            ),
            child: ClientDetailView(clientId: clientId),
          ),
        );

      case RouteNames.clientForm:
        final editClient = args as ClientModel?;
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ClientFormViewModel(clientRepo),
            child: ClientFormView(editClient: editClient),
          ),
        );

      // Debt routes
      case RouteNames.debtDetail:
        final debtId = args as String;
        return MaterialPageRoute(
          builder: (_) => DebtDetailView(debtId: debtId),
        );

      case RouteNames.debtForm:
        DebtModel? editDebt;
        String? preselectedClientId;
        if (args is DebtModel) {
          editDebt = args;
        } else if (args is Map) {
          preselectedClientId = args['clientId'] as String?;
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => DebtFormViewModel(
              debtRepo: debtRepo,
              clientRepo: clientRepo,
            ),
            child: DebtFormView(
              editDebt: editDebt,
              preselectedClientId: preselectedClientId,
            ),
          ),
        );

      // Project routes
      case RouteNames.projectDetail:
        final projectId = args as String;
        return MaterialPageRoute(
          builder: (_) => ProjectDetailView(projectId: projectId),
        );

      case RouteNames.projectForm:
        ProjectModel? editProject;
        String? preselectedClientId;
        if (args is ProjectModel) {
          editProject = args;
        } else if (args is Map) {
          preselectedClientId = args['clientId'] as String?;
        }
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ProjectFormViewModel(
              projectRepo: projectRepo,
              clientRepo: clientRepo,
            ),
            child: ProjectFormView(
              editProject: editProject,
              preselectedClientId: preselectedClientId,
            ),
          ),
        );

      // Lead routes
      case RouteNames.leadDetail:
        final leadId = args as String;
        return MaterialPageRoute(
          builder: (_) => LeadDetailView(leadId: leadId),
        );

      case RouteNames.leadForm:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => LeadFormViewModel(leadRepo),
            child: LeadFormView(editLead: args as LeadModel?),
          ),
        );

      // Income routes
      case RouteNames.incomeForm:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => IncomeFormViewModel(
              incomeRepo: incomeRepo,
              clientRepo: clientRepo,
            ),
            child: IncomeFormView(editIncome: args as IncomeModel?),
          ),
        );

      // Reminder routes
      case RouteNames.reminderForm:
        return MaterialPageRoute(
          builder: (_) => ChangeNotifierProvider(
            create: (_) => ReminderFormViewModel(reminderRepo),
            child: ReminderFormView(editReminder: args as ReminderModel?),
          ),
        );

      default:
        return null;
    }
  }
}

