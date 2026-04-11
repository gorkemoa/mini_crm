import 'package:flutter/material.dart';
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
      ClientStatus.active => StatusBadge(label: 'Active', color: AppColors.success, bgColor: AppColors.successBg),
      ClientStatus.inactive => StatusBadge(label: 'Inactive', color: AppColors.warning, bgColor: AppColors.warningBg),
      ClientStatus.archived => StatusBadge(label: 'Archived', color: AppColors.textTertiaryLight, bgColor: AppColors.surfaceVariantLight),
    };
  }

  factory StatusBadge.fromDebtStatus(DebtStatus status) {
    return switch (status) {
      DebtStatus.pending => StatusBadge(label: 'Pending', color: AppColors.warning, bgColor: AppColors.warningBg),
      DebtStatus.overdue => StatusBadge(label: 'Overdue', color: AppColors.error, bgColor: AppColors.errorBg),
      DebtStatus.paid => StatusBadge(label: 'Paid', color: AppColors.success, bgColor: AppColors.successBg),
      DebtStatus.partial => StatusBadge(label: 'Partial', color: AppColors.info, bgColor: AppColors.infoBg),
    };
  }

  factory StatusBadge.fromProjectStatus(ProjectStatus status) {
    return switch (status) {
      ProjectStatus.planned => StatusBadge(label: 'Planned', color: AppColors.primary, bgColor: AppColors.primaryContainer),
      ProjectStatus.startingSoon => StatusBadge(label: 'Starting Soon', color: AppColors.info, bgColor: AppColors.infoBg),
      ProjectStatus.active => StatusBadge(label: 'Active', color: AppColors.success, bgColor: AppColors.successBg),
      ProjectStatus.paused => StatusBadge(label: 'Paused', color: AppColors.warning, bgColor: AppColors.warningBg),
      ProjectStatus.completed => StatusBadge(label: 'Completed', color: AppColors.success, bgColor: AppColors.successBg),
      ProjectStatus.cancelled => StatusBadge(label: 'Cancelled', color: AppColors.error, bgColor: AppColors.errorBg),
    };
  }

  factory StatusBadge.fromLeadStage(LeadStage stage) {
    return switch (stage) {
      LeadStage.newLead => StatusBadge(label: 'New Lead', color: AppColors.leadNew, bgColor: AppColors.primaryContainer),
      LeadStage.contacted => StatusBadge(label: 'Contacted', color: AppColors.leadContacted, bgColor: AppColors.infoBg),
      LeadStage.proposalSent => StatusBadge(label: 'Proposal Sent', color: AppColors.leadProposal, bgColor: AppColors.warningBg),
      LeadStage.negotiating => StatusBadge(label: 'Negotiating', color: AppColors.leadNegotiating, bgColor: AppColors.errorBg),
      LeadStage.won => StatusBadge(label: 'Won', color: AppColors.leadWon, bgColor: AppColors.successBg),
      LeadStage.lost => StatusBadge(label: 'Lost', color: AppColors.leadLost, bgColor: AppColors.surfaceVariantLight),
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
