import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/income_viewmodel.dart';
import '../../models/income_model.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_field.dart';
import '../widgets/confirm_dialog.dart';

class IncomeView extends StatefulWidget {
  const IncomeView({super.key});

  @override
  State<IncomeView> createState() => _IncomeViewState();
}

class _IncomeViewState extends State<IncomeView> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncomeViewModel>().load();
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
        title: Text(context.l10n.incomeTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              await Navigator.pushNamed(context, '/income/form');
              if (context.mounted) context.read<IncomeViewModel>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<IncomeViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                if (!vm.isEmpty) _buildSummary(context, vm),
                Padding(
                  padding: AppSpacing.screenPaddingH.copyWith(top: AppSpacing.sm, bottom: AppSpacing.sm),
                  child: SearchField(
                    controller: _searchCtrl,
                    hint: context.l10n.incomeSearchHint,
                    onChanged: vm.setSearch,
                  ),
                ),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.isEmpty
                          ? EmptyState(
                              icon: Icons.attach_money_rounded,
                              title: context.l10n.incomeEmpty,
                              description: context.l10n.incomeEmptyDesc,
                              actionLabel: context.l10n.incomeAddTitle,
                              onAction: () async {
                                await Navigator.pushNamed(context, '/income/form');
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
          await Navigator.pushNamed(context, '/income/form');
          if (context.mounted) context.read<IncomeViewModel>().refresh();
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, IncomeViewModel vm) {
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
            child: Column(
              children: [
                Text(context.l10n.incomeThisMonth, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Text(CurrencyUtils.formatCompact(vm.monthlyTotal, 'USD'), style: AppTextStyles.amount.copyWith(color: AppColors.success)),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          Expanded(
            child: Column(
              children: [
                Text(context.l10n.incomeTotal, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Text(CurrencyUtils.formatCompact(vm.total, 'USD'), style: AppTextStyles.amount.copyWith(color: AppColors.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, IncomeViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: vm.incomes.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final income = vm.incomes[i];
        final client = vm.clientFor(income.clientId)?.fullName;
        return _IncomeTile(
          income: income,
          clientName: client,
          onTap: () async {
            await Navigator.pushNamed(context, '/income/form', arguments: income);
            if (context.mounted) vm.refresh();
          },
          onDelete: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: context.l10n.deleteConfirmTitle,
              message: 'Delete this income record?',
            );
            if (confirmed && context.mounted) vm.delete(income.id);
          },
        );
      },
    );
  }
}

class _IncomeTile extends StatelessWidget {
  final IncomeModel income;
  final String? clientName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _IncomeTile({required this.income, this.clientName, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: AppSpacing.cardPaddingAll,
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadii.sm),
                ),
                child: const Icon(Icons.attach_money_rounded, color: AppColors.success, size: 20),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(income.sourcePlatform ?? 'Income', style: AppTextStyles.labelLarge),
                    if (clientName != null)
                      Text(clientName!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
                    Text(AppDateUtils.formatDate(income.date), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiaryLight)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    CurrencyUtils.format(income.amount, income.currency),
                    style: AppTextStyles.amountSmall.copyWith(color: AppColors.success),
                  ),
                ],
              ),
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
