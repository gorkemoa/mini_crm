import 'package:flutter/material.dart';
import '../../core/utils/app_localizations_ext.dart';
import '../../models/enums.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_text_styles.dart';

class StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;

  const StatusBadge({
    super.key,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  factory StatusBadge.fromClientStatus(ClientStatus status, BuildContext context) {
    return switch (status) {
      ClientStatus.active => StatusBadge(label: context.l10n.clientStatusActive, color: AppColors.success, bgColor: AppColors.successBg),
      ClientStatus.inactive => StatusBadge(label: context.l10n.clientStatusInactive, color: AppColors.warning, bgColor: AppColors.warningBg),
      ClientStatus.archived => StatusBadge(label: context.l10n.clientStatusArchived, color: AppColors.textTertiaryLight, bgColor: AppColors.surfaceVariantLight),
    };
  }

  factory StatusBadge.fromDebtStatus(DebtStatus status, BuildContext context) {
    return switch (status) {
      DebtStatus.pending => StatusBadge(label: context.l10n.debtStatusPending, color: AppColors.warning, bgColor: AppColors.warningBg),
      DebtStatus.overdue => StatusBadge(label: context.l10n.debtStatusOverdue, color: AppColors.error, bgColor: AppColors.errorBg),
      DebtStatus.paid => StatusBadge(label: context.l10n.debtStatusPaid, color: AppColors.success, bgColor: AppColors.successBg),
      DebtStatus.partial => StatusBadge(label: context.l10n.debtStatusPartial, color: AppColors.info, bgColor: AppColors.infoBg),
    };
  }

  factory StatusBadge.fromProjectStatus(ProjectStatus status, BuildContext context) {
    return switch (status) {
      ProjectStatus.planned => StatusBadge(label: context.l10n.projectStatusPlanned, color: AppColors.primary, bgColor: AppColors.primaryContainer),
      ProjectStatus.startingSoon => StatusBadge(label: context.l10n.projectStatusStartingSoon, color: AppColors.info, bgColor: AppColors.infoBg),
      ProjectStatus.active => StatusBadge(label: context.l10n.projectStatusActive, color: AppColors.success, bgColor: AppColors.successBg),
      ProjectStatus.paused => StatusBadge(label: context.l10n.projectStatusPaused, color: AppColors.warning, bgColor: AppColors.warningBg),
      ProjectStatus.completed => StatusBadge(label: context.l10n.projectStatusCompleted, color: AppColors.success, bgColor: AppColors.successBg),
      ProjectStatus.cancelled => StatusBadge(label: context.l10n.projectStatusCancelled, color: AppColors.error, bgColor: AppColors.errorBg),
    };
  }

  factory StatusBadge.fromLeadStage(LeadStage stage, BuildContext context) {
    return switch (stage) {
      LeadStage.newLead => StatusBadge(label: context.l10n.leadStageNew, color: AppColors.leadNew, bgColor: AppColors.primaryContainer),
      LeadStage.contacted => StatusBadge(label: context.l10n.leadStageContacted, color: AppColors.leadContacted, bgColor: AppColors.infoBg),
      LeadStage.proposalSent => StatusBadge(label: context.l10n.leadStageProposalSent, color: AppColors.leadProposal, bgColor: AppColors.warningBg),
      LeadStage.negotiating => StatusBadge(label: context.l10n.leadStageNegotiating, color: AppColors.leadNegotiating, bgColor: AppColors.errorBg),
      LeadStage.won => StatusBadge(label: context.l10n.leadStageWon, color: AppColors.leadWon, bgColor: AppColors.successBg),
      LeadStage.lost => StatusBadge(label: context.l10n.leadStageLost, color: AppColors.leadLost, bgColor: AppColors.surfaceVariantLight),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadii.badge),
      ),
      child: Text(
        label,
        style: AppTextStyles.labelSmall.copyWith(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}
