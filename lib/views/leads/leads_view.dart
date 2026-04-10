import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_names.dart';
import '../../l10n/app_localizations.dart';
import '../../models/lead_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/leads_viewmodel.dart';
import '../widgets/badges.dart';
import '../widgets/empty_state.dart';

class LeadsView extends StatefulWidget {
  const LeadsView({super.key});

  @override
  State<LeadsView> createState() => _LeadsViewState();
}

class _LeadsViewState extends State<LeadsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LeadsViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadsViewModel>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.screenPaddingV,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(l10n.leadsTitle, style: AppTextStyles.largeTitle),
                          if (!vm.isLoading && vm.items.isNotEmpty)
                            Text(
                              '${vm.items.where((l) => l.isActive).length} ${l10n.leadsActiveCount}',
                              style: AppTextStyles.footnote
                                  .copyWith(color: AppColors.primary),
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
                            RouteNames.leadForm,
                          );
                          if (context.mounted) vm.refresh();
                        },
                      ),
                    ],
                  ),
                ),

                // Stage filter chips
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
                          label: l10n.all,
                          isSelected: vm.stageFilter == null,
                          onTap: () => vm.filterByStage(null),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        ...LeadStage.values.map((s) => Padding(
                              padding: const EdgeInsets.only(
                                  right: AppSpacing.xs),
                              child: _Chip(
                                label: switch (s) {
                                  LeadStage.newLead => l10n.leadNew,
                                  LeadStage.contacted => l10n.leadContacted,
                                  LeadStage.proposalSent => l10n.leadProposalSent,
                                  LeadStage.negotiating => l10n.leadNegotiating,
                                  LeadStage.won => l10n.leadWon,
                                  LeadStage.lost => l10n.leadLost,
                                },
                                isSelected: vm.stageFilter == s,
                                onTap: () => vm.filterByStage(s),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                // List
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.items.isEmpty
                          ? EmptyState(
                              icon: Icons.person_search_outlined,
                              title: l10n.noLeadsYet,
                              subtitle: l10n.noLeadsSubtitle,
                              actionLabel: l10n.addLead,
                              onAction: () async {
                                await Navigator.pushNamed(
                                  context,
                                  RouteNames.leadForm,
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
                                itemBuilder: (context, i) => _LeadTile(
                                  lead: vm.items[i],
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      RouteNames.leadForm,
                                      arguments: vm.items[i],
                                    );
                                    if (context.mounted) vm.refresh();
                                  },
                                  onDelete: () => vm.delete(vm.items[i].id),
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
  const _Chip(
      {required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 4, vertical: AppSpacing.xs + 2),
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

class _LeadTile extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _LeadTile({
    required this.lead,
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
                // Initials
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    lead.name.isNotEmpty
                        ? lead.name[0].toUpperCase()
                        : '?',
                    style: AppTextStyles.subheadline.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        lead.name,
                        style: AppTextStyles.subheadline
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      if (lead.source != null)
                        Text(lead.source!,
                            style: AppTextStyles.caption1),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    LeadStageBadge(stage: lead.stage),
                    if (lead.estimatedBudget != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${lead.estimatedBudget!.toStringAsFixed(0)} ${lead.currency}',
                        style: AppTextStyles.caption1
                            .copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz,
                      color: AppColors.textTertiary, size: 20),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                        value: 'edit', child: Text(AppLocalizations.of(context)!.edit)),
                    PopupMenuItem(
                      value: 'delete',
                      child: Text(AppLocalizations.of(context)!.delete,
                          style: const TextStyle(color: AppColors.danger)),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'edit') onTap();
                    if (v == 'delete') onDelete();
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
