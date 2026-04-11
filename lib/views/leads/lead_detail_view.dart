import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/app_card.dart';
import '../widgets/info_row.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class LeadDetailView extends StatelessWidget {
  final String leadId;
  const LeadDetailView({super.key, required this.leadId});

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadsViewModel>(
      builder: (context, vm, _) {
        final lead = vm.leads.firstWhere((l) => l.id == leadId, orElse: () => vm.leads.first);
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.leadDetailTitle),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/leads/form', arguments: lead);
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
                    message: 'Delete "${lead.name}"?',
                  );
                  if (confirmed && context.mounted) {
                    await vm.delete(lead.id);
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
                    Text(lead.name, style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (lead.estimatedBudget != null)
                          Text(
                            CurrencyUtils.format(lead.estimatedBudget!, lead.currency ?? 'USD'),
                            style: AppTextStyles.amount.copyWith(color: AppColors.primary),
                          )
                        else
                          Text('No budget estimate', style: AppTextStyles.bodyMedium),
                        StatusBadge.fromLeadStage(lead.stage, context),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  children: [
                    InfoRow(label: context.l10n.labelSource, value: lead.source ?? '—'),
                    InfoRow(label: context.l10n.labelCurrency, value: lead.currency ?? 'USD'),
                    InfoRow(
                      label: context.l10n.labelFollowUpDate,
                      value: AppDateUtils.formatDate(lead.nextFollowUpDate),
                      valueColor: lead.isFollowUpOverdue ? AppColors.warning : null,
                    ),
                    InfoRow(label: context.l10n.labelCreatedAt, value: AppDateUtils.formatDate(lead.createdAt), showDivider: false),
                  ],
                ),
              ),
              if (lead.note != null) ...[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(context.l10n.labelNote, style: AppTextStyles.labelLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(lead.note!, style: AppTextStyles.bodyMedium),
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
