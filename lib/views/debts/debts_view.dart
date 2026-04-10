import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_names.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/date_utils.dart';
import '../../models/debt_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/debts_viewmodel.dart';
import '../widgets/badges.dart';
import '../widgets/empty_state.dart';

class DebtsView extends StatefulWidget {
  const DebtsView({super.key});

  @override
  State<DebtsView> createState() => _DebtsViewState();
}

class _DebtsViewState extends State<DebtsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DebtsViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DebtsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // ─── Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.screenPaddingV,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alacaklar', style: AppTextStyles.largeTitle),
                          if (!vm.isLoading)
                            Text(
                              '${CurrencyUtils.format(vm.totalPending, 'TRY')} bekliyor',
                              style: AppTextStyles.footnote.copyWith(
                                color: AppColors.warning,
                              ),
                            ),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: AppColors.primary,
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteNames.debtForm,
                          );
                          if (context.mounted) vm.refresh();
                        },
                      ),
                    ],
                  ),
                ),

                // ─── Filter
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _Chip(
                          label: 'Tümü',
                          isSelected: vm.statusFilter == null,
                          onTap: () => vm.filterByStatus(null),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        ...DebtStatus.values.map((s) => Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              child: _Chip(
                                label: s.label,
                                isSelected: vm.statusFilter == s,
                                onTap: () => vm.filterByStatus(s),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                // ─── List
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.items.isEmpty
                          ? EmptyState(
                              icon: Icons.account_balance_wallet_outlined,
                              title: 'Henüz alacak yok',
                              subtitle: 'İlk alacağını ekleyerek başla.',
                              actionLabel: 'Alacak Ekle',
                              onAction: () async {
                                await Navigator.pushNamed(
                                  context,
                                  RouteNames.debtForm,
                                );
                                if (context.mounted) vm.refresh();
                              },
                            )
                          : RefreshIndicator(
                              onRefresh: vm.refresh,
                              color: AppColors.primary,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.screenPaddingH,
                                  right: AppSpacing.screenPaddingH,
                                  bottom: AppSpacing.xxxl,
                                ),
                                itemCount: vm.items.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.xs),
                                itemBuilder: (context, i) => _DebtTile(
                                  debt: vm.items[i],
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      RouteNames.debtForm,
                                      arguments: {'debt': vm.items[i]},
                                    );
                                    if (context.mounted) vm.refresh();
                                  },
                                  onDelete: () {
                                    vm.delete(vm.items[i].id);
                                  },
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 4,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption1.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _DebtTile extends StatelessWidget {
  final DebtModel debt;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _DebtTile({
    required this.debt,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        debt.title,
                        style: AppTextStyles.subheadline.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (debt.clientName != null)
                        Text(
                          debt.clientName!,
                          style: AppTextStyles.caption1,
                        ),
                      if (debt.dueDate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          AppDateUtils.relativeLabel(debt.dueDate!),
                          style: AppTextStyles.caption2.copyWith(
                            color: debt.isOverdue
                                ? AppColors.danger
                                : AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      CurrencyUtils.format(debt.amount, debt.currency),
                      style: AppTextStyles.amountSmall.copyWith(
                        color: debt.status == DebtStatus.paid
                            ? AppColors.success
                            : AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    DebtStatusBadge(status: debt.status),
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  itemBuilder: (_) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('Düzenle'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text(
                        'Sil',
                        style: TextStyle(color: AppColors.danger),
                      ),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'delete') onDelete();
                    if (v == 'edit') onTap();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
