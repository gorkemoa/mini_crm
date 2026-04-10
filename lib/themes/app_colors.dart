import 'package:flutter/material.dart';

abstract class AppColors {
  // ─── Backgrounds ───────────────────────────────────────────────────────────
  static const Color background = Color(0xFFF2F2F7);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceSecondary = Color(0xFFEFEFF4);
  static const Color surfaceGrouped = Color(0xFFF2F2F7);

  // ─── Text ──────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF000000);
  static const Color textSecondary = Color(0xFF6C6C70);
  static const Color textTertiary = Color(0xFFAEAEB2);
  static const Color textInverse = Color(0xFFFFFFFF);
  static const Color textLink = Color(0xFF007AFF);

  // ─── Brand / Primary ───────────────────────────────────────────────────────
  static const Color primary = Color(0xFF007AFF);
  static const Color primaryMuted = Color(0xFFE5F1FF);

  // ─── Semantic Status ───────────────────────────────────────────────────────
  static const Color success = Color(0xFF34C759);
  static const Color successMuted = Color(0xFFE6F9EC);
  static const Color warning = Color(0xFFFF9500);
  static const Color warningMuted = Color(0xFFFFF3E0);
  static const Color danger = Color(0xFFFF3B30);
  static const Color dangerMuted = Color(0xFFFFEBEA);
  static const Color info = Color(0xFF5AC8FA);
  static const Color infoMuted = Color(0xFFE3F5FD);
  static const Color purple = Color(0xFFAF52DE);
  static const Color purpleMuted = Color(0xFFF2E6FA);

  // ─── Separators ────────────────────────────────────────────────────────────
  static const Color separator = Color(0xFFE5E5EA);
  static const Color separatorOpaque = Color(0xFFC6C6C8);

  // ─── Debt Status ───────────────────────────────────────────────────────────
  static const Color debtPending = Color(0xFFFF9500);
  static const Color debtPendingMuted = Color(0xFFFFF3E0);
  static const Color debtOverdue = Color(0xFFFF3B30);
  static const Color debtOverdueMuted = Color(0xFFFFEBEA);
  static const Color debtPaid = Color(0xFF34C759);
  static const Color debtPaidMuted = Color(0xFFE6F9EC);
  static const Color debtPartial = Color(0xFF5AC8FA);
  static const Color debtPartialMuted = Color(0xFFE3F5FD);

  // ─── Project Status ────────────────────────────────────────────────────────
  static const Color projectPlanned = Color(0xFF5AC8FA);
  static const Color projectPlannedMuted = Color(0xFFE3F5FD);
  static const Color projectStartingSoon = Color(0xFFFF9500);
  static const Color projectStartingSoonMuted = Color(0xFFFFF3E0);
  static const Color projectActive = Color(0xFF34C759);
  static const Color projectActiveMuted = Color(0xFFE6F9EC);
  static const Color projectPaused = Color(0xFFAEAEB2);
  static const Color projectPausedMuted = Color(0xFFF2F2F7);
  static const Color projectCompleted = Color(0xFF007AFF);
  static const Color projectCompletedMuted = Color(0xFFE5F1FF);
  static const Color projectCancelled = Color(0xFFFF3B30);
  static const Color projectCancelledMuted = Color(0xFFFFEBEA);

  // ─── Lead Stage ────────────────────────────────────────────────────────────
  static const Color leadNew = Color(0xFF5AC8FA);
  static const Color leadNewMuted = Color(0xFFE3F5FD);
  static const Color leadContacted = Color(0xFF007AFF);
  static const Color leadContactedMuted = Color(0xFFE5F1FF);
  static const Color leadProposal = Color(0xFFFF9500);
  static const Color leadProposalMuted = Color(0xFFFFF3E0);
  static const Color leadNegotiating = Color(0xFFAF52DE);
  static const Color leadNegotiatingMuted = Color(0xFFF2E6FA);
  static const Color leadWon = Color(0xFF34C759);
  static const Color leadWonMuted = Color(0xFFE6F9EC);
  static const Color leadLost = Color(0xFFFF3B30);
  static const Color leadLostMuted = Color(0xFFFFEBEA);

  // ─── Client Status ─────────────────────────────────────────────────────────
  static const Color clientActive = Color(0xFF34C759);
  static const Color clientActiveMuted = Color(0xFFE6F9EC);
  static const Color clientInactive = Color(0xFFAEAEB2);
  static const Color clientInactiveMuted = Color(0xFFF2F2F7);
  static const Color clientLost = Color(0xFFFF3B30);
  static const Color clientLostMuted = Color(0xFFFFEBEA);
}
