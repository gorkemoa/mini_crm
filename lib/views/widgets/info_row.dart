import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String? value;
  final Widget? trailing;
  final bool showDivider;
  final Color? valueColor;

  const InfoRow({
    super.key,
    required this.label,
    this.value,
    this.trailing,
    this.showDivider = true,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
              ),
              Expanded(
                child: trailing ??
                    Text(
                      value ?? '—',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: valueColor ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
                      ),
                    ),
              ),
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
      ],
    );
  }
}
