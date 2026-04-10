import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../services/database/local_database_service.dart';
import '../../services/repositories/client_repository.dart';
import '../../services/repositories/debt_repository.dart';
import '../../services/repositories/income_repository.dart';
import '../../services/repositories/lead_repository.dart';
import '../../services/repositories/project_repository.dart';
import '../../services/repositories/reminder_repository.dart';
import '../../services/storage/file_export_service.dart';
import '../../services/storage/file_import_service.dart';
import '../../themes/app_theme.dart';
import '../../viewmodels/client_detail_viewmodel.dart';
import '../../viewmodels/client_form_viewmodel.dart';
import '../../viewmodels/clients_viewmodel.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../viewmodels/debt_form_viewmodel.dart';
import '../../viewmodels/debts_viewmodel.dart';
import '../../viewmodels/income_form_viewmodel.dart';
import '../../viewmodels/income_viewmodel.dart';
import '../../viewmodels/lead_form_viewmodel.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../../viewmodels/project_form_viewmodel.dart';
import '../../viewmodels/projects_viewmodel.dart';
import '../../viewmodels/reminders_viewmodel.dart';
import '../../viewmodels/settings_viewmodel.dart';
import '../clients/clients_view.dart';
import '../dashboard/dashboard_view.dart';
import '../debts/debts_view.dart';
import '../more/more_view.dart';
import '../projects/projects_view.dart';
import 'app_router.dart';

class App extends StatelessWidget {
  final LocalDatabaseService dbService;

  const App({super.key, required this.dbService});

  @override
  Widget build(BuildContext context) {
    // ── Build repositories ──────────────────────────────────
    final clientRepo = ClientRepository(dbService);
    final debtRepo = DebtRepository(dbService);
    final projectRepo = ProjectRepository(dbService);
    final leadRepo = LeadRepository(dbService);
    final incomeRepo = IncomeRepository(dbService);
    final reminderRepo = ReminderRepository(dbService);

    final exportService = FileExportService(
      clientRepository: clientRepo,
      debtRepository: debtRepo,
      projectRepository: projectRepo,
      leadRepository: leadRepo,
      incomeRepository: incomeRepo,
      reminderRepository: reminderRepo,
    );

    final importService = FileImportService(
      clientRepository: clientRepo,
      debtRepository: debtRepo,
      projectRepository: projectRepo,
      leadRepository: leadRepo,
      incomeRepository: incomeRepo,
      reminderRepository: reminderRepo,
    );

    return MultiProvider(
      providers: [
        // ── Dashboard
        ChangeNotifierProvider(
          create: (_) => DashboardViewModel(
            debtRepository: debtRepo,
            projectRepository: projectRepo,
            leadRepository: leadRepo,
            incomeRepository: incomeRepo,
            reminderRepository: reminderRepo,
          ),
        ),

        // ── Clients
        ChangeNotifierProvider(
          create: (_) => ClientsViewModel(clientRepository: clientRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientDetailViewModel(
            clientRepository: clientRepo,
            debtRepository: debtRepo,
            projectRepository: projectRepo,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ClientFormViewModel(clientRepository: clientRepo),
        ),

        // ── Debts
        ChangeNotifierProvider(
          create: (_) => DebtsViewModel(debtRepository: debtRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => DebtFormViewModel(
            debtRepository: debtRepo,
            clientRepository: clientRepo,
          ),
        ),

        // ── Projects
        ChangeNotifierProvider(
          create: (_) => ProjectsViewModel(projectRepository: projectRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectFormViewModel(
            projectRepository: projectRepo,
            clientRepository: clientRepo,
          ),
        ),

        // ── Leads
        ChangeNotifierProvider(
          create: (_) => LeadsViewModel(leadRepository: leadRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => LeadFormViewModel(leadRepository: leadRepo),
        ),

        // ── Income
        ChangeNotifierProvider(
          create: (_) => IncomeViewModel(incomeRepository: incomeRepo),
        ),
        ChangeNotifierProvider(
          create: (_) => IncomeFormViewModel(
            incomeRepository: incomeRepo,
            clientRepository: clientRepo,
          ),
        ),

        // ── Reminders
        ChangeNotifierProvider(
          create: (_) =>
              RemindersViewModel(reminderRepository: reminderRepo),
        ),

        // ── Settings (loads saved locale on creation)
        ChangeNotifierProvider(
          create: (_) {
            final vm = SettingsViewModel(
              exportService: exportService,
              importService: importService,
            );
            vm.loadLocale();
            return vm;
          },
        ),
      ],
      child: Consumer<SettingsViewModel>(
        builder: (context, settingsVm, _) {
          return MaterialApp(
            title: 'Mini CRM',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            locale: settingsVm.locale,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback: (locale, supported) {
              if (locale == null) return supported.first;
              for (final sl in supported) {
                if (sl.languageCode == locale.languageCode) return sl;
              }
              return supported.first;
            },
            onGenerateRoute: AppRouter.generateRoute,
            home: const AppShell(),
          );
        },
      ),
    );
  }
}

// ─── Bottom navigation shell ──────────────────────────────────────────────────

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  final List<Widget> _tabs = const [
    DashboardView(),
    ClientsView(),
    DebtsView(),
    ProjectsView(),
    MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.grid_view_outlined),
            activeIcon: const Icon(Icons.grid_view),
            label: l10n.navDashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people_outline),
            activeIcon: const Icon(Icons.people),
            label: l10n.navClients,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            activeIcon: const Icon(Icons.account_balance_wallet),
            label: l10n.navDebts,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.work_outline),
            activeIcon: const Icon(Icons.work),
            label: l10n.navProjects,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            activeIcon: const Icon(Icons.more_horiz),
            label: l10n.navMore,
          ),
        ],
      ),
    );
  }
}
