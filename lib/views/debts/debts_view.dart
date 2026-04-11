import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/debts_viewmodel.dart';
import '../../models/debt_model.dart';
import '../../models/enums.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_field.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class DebtsView extends StatefulWidget {
  const DebtsView({super.key});

  @override
  State<DebtsView> createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DebtsViewModel>().load();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Debts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              await Navigator.pushNamed(context, '/debts/form');
              if (context.mounted) context.read<DebtsViewModel>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<DebtsViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                if (!vm.isEmpty) _buildSummary(context, vm),
                Padding(
                  padding: AppSpacing.screenPaddingH.copyWith(
                    top: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      SearchField(
                        controller: _searchCtrl,
                        hint: 'Search debts...',
                        onChanged: vm.setSearch,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildFilterRow(context, vm),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.isEmpty
                          ? EmptyState(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'No debts yet',
                              description: 'Add your first debt record',
                              actionLabel: 'Add Debt',
                              onAction: () async {
                                await Navigator.pushNamed(context, '/debts/form');
                                if (context.mounted) vm.refresh();
                              },
                            )
                          : _buildList(context, vm),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/debts/form');
          if (context.mounted) context.read<DebtsViewModel>().refresh();
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, DebtsViewModel vm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(
              label: 'Pending',
              value: CurrencyUtils.formatCompact(vm.pendingTotal, 'USD'),
              color: AppColors.warning,
            ),
          ),
          Container(width: 1, height: 40, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          Expanded(
            child: _SummaryItem(
              label: 'Overdue',
              value: CurrencyUtils.formatCompact(vm.overdueTotal, 'USD'),
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, DebtsViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(label: 'All', selected: vm.statusFilter == null, onTap: () => vm.setStatusFilter(null)),
          const SizedBox(width: AppSpacing.xs),
          _Chip(label: 'Pending', selected: vm.statusFilter == DebtStatus.pending, onTap: () => vm.setStatusFilter(DebtStatus.pending)),
          const SizedBox(width: AppSpacing.xs),
          _Chip(label: 'Overdue', selected: vm.statusFilter == DebtStatus.overdue, onTap: () => vm.setStatusFilter(DebtStatus.overdue)),
          const SizedBox(width: AppSpacing.xs),
          _Chip(label: 'Paid', selected: vm.statusFilter == DebtStatus.paid, onTap: () => vm.setStatusFilter(DebtStatus.paid)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, DebtsViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: vm.debts.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final debt = vm.debts[i];
        final client = vm.clientFor(debt.clientId);
        return _DebtTile(
          debt: debt,
          clientName: client?.fullName ?? 'Unknown Client',
          onTap: () async {
            await Navigator.pushNamed(context, '/debts/detail', arguments: debt.id);
            if (context.mounted) vm.refresh();
          },
          onDelete: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: 'Delete Debt',
              message: 'Delete "${debt.title}"?',
            );
            if (confirmed && context.mounted) vm.delete(debt.id);
          },
        );
      },
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _SummaryItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight)),
        const SizedBox(height: 4),
        Text(value, style: AppTextStyles.amount.copyWith(color: color)),
      ],
    );
  }
}

class _DebtTile extends StatelessWidget {
  final DebtModel debt;
  final String clientName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DebtTile({required this.debt, required this.clientName, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverdue = debt.isOverdue || debt.status == DebtStatus.overdue;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(
          color: isOverdue ? AppColors.error.withValues(alpha: 0.4) : (isDark ? AppColors.borderDark : AppColors.borderLight),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: AppSpacing.cardPaddingAll,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(debt.title, style: AppTextStyles.labelLarge),
                    const SizedBox(height: 2),
                    Text(clientName, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
                    const SizedBox(height: 2),
                    if (debt.dueDate != null)
                      Text(
                        'Due: ${AppDateUtils.formatDate(debt.dueDate)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isOverdue ? AppColors.error : AppColors.textTertiaryLight,
                        ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyUtils.format(debt.amount, debt.currency),
                    style: AppTextStyles.amountSmall,
                  ),
                  const SizedBox(height: 4),
                  StatusBadge.fromDebtStatus(debt.status),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                color: AppColors.error,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: selected ? Colors.white : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}
