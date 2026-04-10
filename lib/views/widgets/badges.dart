import 'package:flutter/material.dart';
import '../../models/client_model.dart';
import '../../models/debt_model.dart';
import '../../models/lead_model.dart';
import '../../models/project_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import 'status_badge.dart';

// ─── Client ────────────────────────────────────────────────────────────────

class ClientStatusBadge extends StatelessWidget {
  final ClientStatus status;
  const ClientStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (status) {
      ClientStatus.active => (AppColors.clientActive, AppColors.clientActiveMuted),
      ClientStatus.inactive => (AppColors.clientInactive, AppColors.clientInactiveMuted),
      ClientStatus.lost => (AppColors.clientLost, AppColors.clientLostMuted),
    };
    return StatusBadge(label: status.label, color: color, backgroundColor: bg);
  }
}

// ─── Debt ──────────────────────────────────────────────────────────────────

class DebtStatusBadge extends StatelessWidget {
  final DebtStatus status;
  const DebtStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (status) {
      DebtStatus.pending => (AppColors.debtPending, AppColors.debtPendingMuted),
      DebtStatus.overdue => (AppColors.debtOverdue, AppColors.debtOverdueMuted),
      DebtStatus.paid => (AppColors.debtPaid, AppColors.debtPaidMuted),
      DebtStatus.partial => (AppColors.debtPartial, AppColors.debtPartialMuted),
    };
    return StatusBadge(label: status.label, color: color, backgroundColor: bg);
  }
}

// ─── Project ───────────────────────────────────────────────────────────────

class ProjectStatusBadge extends StatelessWidget {
  final ProjectStatus status;
  const ProjectStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (status) {
      ProjectStatus.planned => (AppColors.projectPlanned, AppColors.projectPlannedMuted),
      ProjectStatus.startingSoon => (AppColors.projectStartingSoon, AppColors.projectStartingSoonMuted),
      ProjectStatus.active => (AppColors.projectActive, AppColors.projectActiveMuted),
      ProjectStatus.paused => (AppColors.projectPaused, AppColors.projectPausedMuted),
      ProjectStatus.completed => (AppColors.projectCompleted, AppColors.projectCompletedMuted),
      ProjectStatus.cancelled => (AppColors.projectCancelled, AppColors.projectCancelledMuted),
    };
    return StatusBadge(label: status.label, color: color, backgroundColor: bg);
  }
}

// ─── Lead ──────────────────────────────────────────────────────────────────

class LeadStageBadge extends StatelessWidget {
  final LeadStage stage;
  const LeadStageBadge({super.key, required this.stage});

  @override
  Widget build(BuildContext context) {
    final (color, bg) = switch (stage) {
      LeadStage.newLead => (AppColors.leadNew, AppColors.leadNewMuted),
      LeadStage.contacted => (AppColors.leadContacted, AppColors.leadContactedMuted),
      LeadStage.proposalSent => (AppColors.leadProposal, AppColors.leadProposalMuted),
      LeadStage.negotiating => (AppColors.leadNegotiating, AppColors.leadNegotiatingMuted),
      LeadStage.won => (AppColors.leadWon, AppColors.leadWonMuted),
      LeadStage.lost => (AppColors.leadLost, AppColors.leadLostMuted),
    };
    return StatusBadge(label: stage.label, color: color, backgroundColor: bg);
  }
}

// ─── Avatar ────────────────────────────────────────────────────────────────

class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final Color? color;

  const InitialsAvatar({
    super.key,
    required this.initials,
    this.size = 40,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: (color ?? AppColors.primary).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppRadii.avatar),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          fontSize: size * 0.35,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.primary,
        ),
      ),
    );
  }
}

// ─── Stat Card ─────────────────────────────────────────────────────────────

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final Color accentColor;
  final IconData icon;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    required this.accentColor,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.cardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadii.icon),
                  ),
                  child: Icon(icon, size: 16, color: accentColor),
                ),
                const Spacer(),
                if (onTap != null)
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: AppColors.textTertiary,
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w400,
                color: AppColors.textSecondary,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 2),
              Text(
                subtitle!,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.textTertiary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
