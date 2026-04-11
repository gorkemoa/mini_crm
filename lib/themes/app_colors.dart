import 'package:flutter/material.dart';

abstract class AppColors {
  // Primary
  static const Color primary = Color(0xFF4F46E5);
  static const Color primaryDark = Color(0xFF3730A3);
  static const Color primaryLight = Color(0xFF818CF8);
  static const Color primaryContainer = Color(0xFFEEF2FF);

  // Neutrals
  static const Color backgroundLight = Color(0xFFF8FAFC);
  static const Color backgroundDark = Color(0xFF0F172A);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);
  static const Color surfaceVariantDark = Color(0xFF263045);

  // Text - Light
  static const Color textPrimaryLight = Color(0xFF0F172A);
  static const Color textSecondaryLight = Color(0xFF475569);
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // Text - Dark
  static const Color textPrimaryDark = Color(0xFFF1F5F9);
  static const Color textSecondaryDark = Color(0xFF94A3B8);
  static const Color textTertiaryDark = Color(0xFF64748B);

  // Status
  static const Color success = Color(0xFF10B981);
  static const Color successBg = Color(0xFFECFDF5);
  static const Color successDarkBg = Color(0xFF052E16);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningBg = Color(0xFFFFFBEB);
  static const Color warningDarkBg = Color(0xFF292524);

  static const Color error = Color(0xFFEF4444);
  static const Color errorBg = Color(0xFFFEF2F2);
  static const Color errorDarkBg = Color(0xFF2D0707);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoBg = Color(0xFFEFF6FF);
  static const Color infoDarkBg = Color(0xFF0B1F3A);

  // Overdue / Warning accent
  static const Color overdue = Color(0xFFEF4444);
  static const Color pending = Color(0xFFF59E0B);
  static const Color paid = Color(0xFF10B981);

  // Border
  static const Color borderLight = Color(0xFFE2E8F0);
  static const Color borderDark = Color(0xFF334155);

  // Card shadow
  static const Color shadowLight = Color(0x0A000000);
  static const Color shadowDark = Color(0x40000000);

  // Lead stage colors
  static const Color leadNew = Color(0xFF6366F1);
  static const Color leadContacted = Color(0xFF3B82F6);
  static const Color leadProposal = Color(0xFFF59E0B);
  static const Color leadNegotiating = Color(0xFFEF4444);
  static const Color leadWon = Color(0xFF10B981);
  static const Color leadLost = Color(0xFF94A3B8);
}
