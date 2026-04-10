import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/dashboard_viewmodel.dart';
import '../widgets/empty_state.dart';
import '../widgets/section_header.dart';
import '../widgets/badges.dart';
import '../../core/constants/route_names.dart';

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
    return Consumer<DashboardViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: RefreshIndicator(
              onRefresh: vm.refresh,
              color: AppColors.primary,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  // ─── Header
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.screenPaddingH,
                        AppSpacing.screenPaddingV,
                        AppSpacing.screenPaddingH,
                        0,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Mini CRM',
                            style: AppTextStyles.largeTitle,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _greeting(),
                            style: AppTextStyles.footnote,
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ─── Loading
                  if (vm.isLoading)
                    const SliverFillRemaining(
                      child: Center(child: CircularProgressIndicator()),
                    )

                  // ─── Error
                  else if (vm.hasError)
                    SliverFillRemaining(
                      child: EmptyState(
                        icon: Icons.error_outline,
                        title: 'Bir hata oluştu',
                        subtitle: vm.errorMessage,
                        actionLabel: 'Tekrar Dene',
                        onAction: vm.refresh,
                      ),
                    )

                  else ...[
                    // ─── Stat Cards
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppSpacing.screenPaddingH,
                          AppSpacing.lg,
                          AppSpacing.screenPaddingH,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const _SectionLabel('ÖZET'),
                            const SizedBox(height: AppSpacing.sm),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              mainAxisSpacing: AppSpacing.cardGap,
                              crossAxisSpacing: AppSpacing.cardGap,
                              childAspectRatio: 1.25,
                              children: [
                                StatCard(
                                  title: 'Bekleyen Alacak',
                                  value: CurrencyUtils.formatCompact(
                                    vm.totalPendingDebt,
                                    vm.defaultCurrency,
                                  ),
                                  accentColor: AppColors.warning,
                                  icon: Icons.account_balance_wallet_outlined,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.debts,
                                  ),
                                ),
                                StatCard(
                                  title: 'Aktif Lead',
                                  value: vm.activeLeadCount.toString(),
                                  accentColor: AppColors.purple,
                                  icon: Icons.person_search_outlined,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.leads,
                                  ),
                                ),
                                StatCard(
                                  title: 'Bu Ay Gelir',
                                  value: CurrencyUtils.formatCompact(
                                    vm.thisMonthIncome,
                                    vm.defaultCurrency,
                                  ),
                                  accentColor: AppColors.success,
                                  icon: Icons.trending_up,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.income,
                                  ),
                                ),
                                StatCard(
                                  title: 'Bugün Hatırlatıcı',
                                  value: vm.todayReminders.length.toString(),
                                  accentColor: AppColors.danger,
                                  icon: Icons.notifications_outlined,
                                  onTap: () => Navigator.pushNamed(
                                    context,
                                    RouteNames.reminders,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    // ─── Overdue Debts
                    if (vm.overdueDebts.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPaddingH,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: 'Gecikmiş Alacaklar',
                                action: 'Tümü',
                                onAction: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.debts,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: vm.overdueDebts
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    final isLast =
                                        e.key == vm.overdueDebts.length - 1;
                                    return _OverdueDebtTile(
                                      debt: e.value,
                                      isLast: isLast,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // ─── Upcoming Projects
                    if (vm.upcomingProjects.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPaddingH,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: 'Aktif Projeler',
                                action: 'Tümü',
                                onAction: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.projects,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: vm.upcomingProjects
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    final isLast = e.key ==
                                        vm.upcomingProjects.length - 1;
                                    return _ProjectTile(
                                      project: e.value,
                                      isLast: isLast,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    // ─── Today Reminders
                    if (vm.todayReminders.isNotEmpty)
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.screenPaddingH,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SectionHeader(
                                title: 'Bugün',
                                action: 'Tümü',
                                onAction: () => Navigator.pushNamed(
                                  context,
                                  RouteNames.reminders,
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Column(
                                  children: vm.todayReminders
                                      .asMap()
                                      .entries
                                      .map((e) {
                                    final isLast =
                                        e.key == vm.todayReminders.length - 1;
                                    return _ReminderTile(
                                      title: e.value.title,
                                      note: e.value.note,
                                      isLast: isLast,
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    const SliverToBoxAdapter(
                      child: SizedBox(height: AppSpacing.xxxl),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _greeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Günaydın 👋';
    if (hour < 18) return 'İyi günler 👋';
    return 'İyi akşamlar 👋';
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.sectionHeader);
  }
}

class _OverdueDebtTile extends StatelessWidget {
  final debt;
  final bool isLast;
  const _OverdueDebtTile({required this.debt, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(debt.title, style: AppTextStyles.subheadline),
                    if (debt.clientName != null)
                      Text(
                        debt.clientName!,
                        style: AppTextStyles.caption1,
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyUtils.format(debt.amount, debt.currency),
                    style: AppTextStyles.amountSmall.copyWith(
                      color: AppColors.danger,
                    ),
                  ),
                  if (debt.dueDate != null)
                    Text(
                      AppDateUtils.relativeLabel(debt.dueDate!),
                      style: AppTextStyles.caption2.copyWith(
                        color: AppColors.danger,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: AppSpacing.cardPadding,
          ),
      ],
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final project;
  final bool isLast;
  const _ProjectTile({required this.project, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title, style: AppTextStyles.subheadline),
                    if (project.clientName != null)
                      Text(project.clientName!, style: AppTextStyles.caption1),
                  ],
                ),
              ),
              ProjectStatusBadge(status: project.status),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: AppSpacing.cardPadding,
          ),
      ],
    );
  }
}

class _ReminderTile extends StatelessWidget {
  final String title;
  final String? note;
  final bool isLast;
  const _ReminderTile({
    required this.title,
    this.note,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.cardPadding,
            vertical: 12,
          ),
          child: Row(
            children: [
              const Icon(
                Icons.circle,
                size: 8,
                color: AppColors.danger,
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.subheadline),
                    if (note != null)
                      Text(note!, style: AppTextStyles.caption1),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: AppSpacing.cardPadding,
          ),
      ],
    );
  }
}
