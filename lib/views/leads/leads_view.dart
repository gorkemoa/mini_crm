import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../../models/lead_model.dart';
import '../../models/enums.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_field.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class LeadsView extends StatefulWidget {
  const LeadsView({super.key});

  @override
  State<LeadsView> createState() => _LeadsViewState();
}

class _LeadsViewState extends State<LeadsView> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeadsViewModel>().load();
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
        title: Text(context.l10n.leadsTitle),
      ),
      body: Consumer<LeadsViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                if (!vm.isEmpty) _buildWinRate(context, vm),
                Padding(
                  padding: AppSpacing.screenPaddingH.copyWith(top: AppSpacing.sm, bottom: AppSpacing.sm),
                  child: Column(
                    children: [
                      SearchField(
                        controller: _searchCtrl,
                        hint: context.l10n.leadsSearchHint,
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
                              icon: Icons.person_search_outlined,
                              title: context.l10n.leadsEmpty,
                              description: context.l10n.leadsEmptyDesc,
                              actionLabel: context.l10n.leadsAddTitle,
                              onAction: () async {
                                await Navigator.pushNamed(context, '/leads/form');
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
          await Navigator.pushNamed(context, '/leads/form');
          if (context.mounted) context.read<LeadsViewModel>().refresh();
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildWinRate(BuildContext context, LeadsViewModel vm) {
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
                Text(context.l10n.leadsTotal, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Text('${vm.leads.length}', style: AppTextStyles.amount),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          Expanded(
            child: Column(
              children: [
                Text(context.l10n.leadStageWon, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Text('${vm.wonCount}', style: AppTextStyles.amount.copyWith(color: AppColors.success)),
              ],
            ),
          ),
          Container(width: 1, height: 40, color: isDark ? AppColors.borderDark : AppColors.borderLight),
          Expanded(
            child: Column(
              children: [
                Text(context.l10n.leadsConversionRate, style: AppTextStyles.labelSmall.copyWith(color: AppColors.textSecondaryLight)),
                const SizedBox(height: 4),
                Text('${vm.winRate.toStringAsFixed(0)}%', style: AppTextStyles.amount.copyWith(color: AppColors.info)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, LeadsViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(label: context.l10n.labelAll, selected: vm.stageFilter == null, onTap: () => vm.setStageFilter(null)),
          const SizedBox(width: AppSpacing.xs),
          ...[LeadStage.newLead, LeadStage.contacted, LeadStage.proposalSent, LeadStage.negotiating, LeadStage.won, LeadStage.lost]
              .map((s) => Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xs),
                    child: _Chip(
                      label: _stageLabel(s, context),
                      selected: vm.stageFilter == s,
                      onTap: () => vm.setStageFilter(s),
                    ),
                  )),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, LeadsViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: vm.leads.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final lead = vm.leads[i];
        return _LeadTile(
          lead: lead,
          onTap: () async {
            await Navigator.pushNamed(context, '/leads/detail', arguments: lead.id);
            if (context.mounted) vm.refresh();
          },
          onDelete: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: context.l10n.deleteConfirmTitle,
              message: 'Delete "${lead.name}"?',
            );
            if (confirmed && context.mounted) vm.delete(lead.id);
          },
        );
      },
    );
  }

  String _stageLabel(LeadStage s, BuildContext context) => switch (s) {
        LeadStage.newLead => context.l10n.leadStageNew,
        LeadStage.contacted => context.l10n.leadStageContacted,
        LeadStage.proposalSent => context.l10n.leadStageProposalSent,
        LeadStage.negotiating => context.l10n.leadStageNegotiating,
        LeadStage.won => context.l10n.leadStageWon,
        LeadStage.lost => context.l10n.leadStageLost,
      };
}

class _LeadTile extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _LeadTile({required this.lead, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverdue = lead.isFollowUpOverdue;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(
          color: isOverdue ? AppColors.warning.withValues(alpha: 0.4) : (isDark ? AppColors.borderDark : AppColors.borderLight),
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
                    Text(lead.name, style: AppTextStyles.labelLarge),
                    if (lead.source != null) ...[
                      const SizedBox(height: 2),
                      Text(lead.source!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
                    ],
                    if (lead.nextFollowUpDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Follow-up: ${AppDateUtils.formatDate(lead.nextFollowUpDate)}',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: isOverdue ? AppColors.warning : AppColors.textTertiaryLight,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (lead.estimatedBudget != null)
                    Text(
                      CurrencyUtils.format(lead.estimatedBudget!, lead.currency ?? 'USD'),
                      style: AppTextStyles.amountSmall,
                    ),
                  const SizedBox(height: 4),
                  StatusBadge.fromLeadStage(lead.stage, context),
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
