import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../../models/reminder_model.dart';
import '../widgets/app_card.dart';
import '../widgets/section_header.dart';
import '../widgets/empty_state.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      body: Consumer<DashboardViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: true,
                  pinned: false,
                  expandedHeight: 120,
                  flexibleSpace: FlexibleSpaceBar(
                    titlePadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    title: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          context.l10n.appTitle,
                          style: AppTextStyles.h1.copyWith(
                            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                          ),
                        ),
                        Text(
                          context.l10n.dashboardOverview,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (vm.isLoading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else
                  SliverPadding(
                    padding: AppSpacing.screenPaddingAll,
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildStatsGrid(context, vm),
                        const SizedBox(height: AppSpacing.lg),
                        SectionHeader(
                          title: context.l10n.dashboardTodayReminders,
                          actionLabel: vm.todayReminders.isNotEmpty ? context.l10n.actionViewAll : null,
                          onAction: () => Navigator.pushNamed(context, '/reminders'),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        _buildReminders(context, vm),
                        const SizedBox(height: AppSpacing.xl),
                      ]),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, DashboardViewModel vm) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: context.l10n.dashboardPendingDebts,
                value: CurrencyUtils.formatCompact(vm.pendingDebtTotal, 'USD'),
                icon: Icons.account_balance_wallet_rounded,
                color: AppColors.warning,
                bgColor: AppColors.warningBg,
                onTap: () => Navigator.pushNamed(context, '/debts'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatCard(
                label: context.l10n.dashboardActiveClients,
                value: vm.activeClients.toString(),
                icon: Icons.people_rounded,
                color: AppColors.primary,
                bgColor: AppColors.primaryContainer,
                onTap: () => Navigator.pushNamed(context, '/clients'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(
              child: _StatCard(
                label: context.l10n.dashboardActiveProjects,
                value: vm.activeProjects.toString(),
                icon: Icons.folder_rounded,
                color: AppColors.info,
                bgColor: AppColors.infoBg,
                onTap: () => Navigator.pushNamed(context, '/projects'),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _StatCard(
                label: context.l10n.dashboardLeadsToFollow,
                value: vm.leadsToFollow.toString(),
                icon: Icons.trending_up_rounded,
                color: AppColors.success,
                bgColor: AppColors.successBg,
                onTap: () => Navigator.pushNamed(context, '/leads'),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        _StatCard(
          label: context.l10n.dashboardMonthlyIncome,
          value: CurrencyUtils.formatCompact(vm.monthlyIncome, 'USD'),
          icon: Icons.bar_chart_rounded,
          color: AppColors.success,
          bgColor: AppColors.successBg,
          onTap: () => Navigator.pushNamed(context, '/income'),
          isWide: true,
        ),
      ],
    );
  }

  Widget _buildReminders(BuildContext context, DashboardViewModel vm) {
    if (vm.todayReminders.isEmpty) {
      return AppCard(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
          child: EmptyState(
            icon: Icons.check_circle_outline_rounded,
            title: "All clear!",
            description: context.l10n.dashboardNoRemindersToday,
          ),
        ),
      );
    }

    return Column(
      children: vm.todayReminders
          .map((r) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: _ReminderItem(reminder: r),
              ))
          .toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;
  final VoidCallback? onTap;
  final bool isWide;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
    this.onTap,
    this.isWide = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(AppRadii.md),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: AppTextStyles.h2.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.chevron_right_rounded,
            color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
            size: 18,
          ),
        ],
      ),
    );
  }
}

class _ReminderItem extends StatelessWidget {
  final ReminderModel reminder;

  const _ReminderItem({required this.reminder});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  reminder.title,
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Text(
                  AppDateUtils.formatDateTime(reminder.reminderDate),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
