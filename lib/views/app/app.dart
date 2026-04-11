import 'package:flutter/material.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../dashboard/dashboard_view.dart';
import '../clients/clients_view.dart';
import '../leads/leads_view.dart';
import '../debts/debts_view.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _selectedIndex = 0;

  static const List<Widget> _tabs = [
    DashboardView(),
    ClientsView(),
    LeadsView(),
    DebtsView(),
    _MoreView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _tabs,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard_rounded),
            label: context.l10n.navDashboard,
          ),
          NavigationDestination(
            icon: const Icon(Icons.people_outline_rounded),
            selectedIcon: const Icon(Icons.people_rounded),
            label: context.l10n.navClients,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_search_outlined),
            selectedIcon: const Icon(Icons.person_search_rounded),
            label: context.l10n.navLeads,
          ),
          NavigationDestination(
            icon: const Icon(Icons.account_balance_wallet_outlined),
            selectedIcon: const Icon(Icons.account_balance_wallet_rounded),
            label: context.l10n.navDebts,
          ),
          NavigationDestination(
            icon: const Icon(Icons.grid_view_outlined),
            selectedIcon: const Icon(Icons.grid_view_rounded),
            label: context.l10n.navMore,
          ),
        ],
      ),
    );
  }
}

class _MoreView extends StatelessWidget {
  const _MoreView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(title: Text(context.l10n.navMore)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MoreTile(
            icon: Icons.work_outline_rounded,
            color: AppColors.info,
            title: context.l10n.navProjects,
            subtitle: 'Manage your projects',
            onTap: () => Navigator.pushNamed(context, '/projects'),
          ),
          const SizedBox(height: 8),
          _MoreTile(
            icon: Icons.attach_money_rounded,
            color: AppColors.success,
            title: context.l10n.navIncome,
            subtitle: 'Track income records',
            onTap: () => Navigator.pushNamed(context, '/income'),
          ),
          const SizedBox(height: 8),
          _MoreTile(
            icon: Icons.alarm_rounded,
            color: AppColors.warning,
            title: context.l10n.navReminders,
            subtitle: 'Follow-ups & tasks',
            onTap: () => Navigator.pushNamed(context, '/reminders'),
          ),
          const SizedBox(height: 8),
          _MoreTile(
            icon: Icons.settings_outlined,
            color: AppColors.textSecondaryLight,
            title: context.l10n.navSettings,
            subtitle: 'Theme, language, data',
            onTap: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
    );
  }
}

class _MoreTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _MoreTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                    Text(subtitle, style: TextStyle(fontSize: 13, color: AppColors.textSecondaryLight)),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textTertiaryLight),
            ],
          ),
        ),
      ),
    );
  }
}
