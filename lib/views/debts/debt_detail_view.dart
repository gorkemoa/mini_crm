import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/debts_viewmodel.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/app_card.dart';
import '../widgets/info_row.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class DebtDetailView extends StatelessWidget {
  final String debtId;
  const DebtDetailView({super.key, required this.debtId});

  @override
  Widget build(BuildContext context) {
    return Consumer<DebtsViewModel>(
      builder: (context, vm, _) {
        final debt = vm.debts.firstWhere((d) => d.id == debtId, orElse: () => vm.debts.first);
        final client = vm.clientFor(debt.clientId);
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.debtDetailTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/debts/form', arguments: debt);
                  if (context.mounted) vm.refresh();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.error,
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: context.l10n.deleteConfirmTitle,
                    message: 'Delete "${debt.title}"?',
                  );
                  if (confirmed && context.mounted) {
                    await vm.delete(debt.id);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          body: ListView(
            padding: AppSpacing.screenPaddingAll,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(debt.title, style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          CurrencyUtils.format(debt.amount, debt.currency),
                          style: AppTextStyles.amount.copyWith(color: AppColors.primary),
                        ),
                        StatusBadge.fromDebtStatus(debt.status, context),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  children: [
                    InfoRow(label: context.l10n.labelClient, value: client?.fullName ?? 'Unknown'),
                    InfoRow(label: context.l10n.labelDueDate, value: AppDateUtils.formatDate(debt.dueDate)),
                    InfoRow(label: context.l10n.labelCurrency, value: debt.currency),
                    InfoRow(label: context.l10n.labelCreatedAt, value: AppDateUtils.formatDate(debt.createdAt), showDivider: false),
                  ],
                ),
              ),
              if (debt.note != null) ...[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.labelNote, style: AppTextStyles.labelLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(debt.note!, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
