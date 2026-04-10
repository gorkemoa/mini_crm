import 'package:flutter/material.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? action;
  final VoidCallback? onAction;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.lg,
        bottom: AppSpacing.sm,
      ),
      child: Row(
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.sectionHeader,
          ),
          if (action != null) ...[
            const Spacer(),
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: AppTextStyles.footnote.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
