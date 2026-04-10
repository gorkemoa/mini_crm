import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_spacing.dart';

class InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;
  final Widget? valueWidget;

  const InfoRow({
    super.key,
    required this.label,
    this.value = '',
    this.isLast = false,
    this.valueWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.tileVertical,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: Text(
                  label,
                  style: AppTextStyles.subheadline.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: valueWidget ??
                    Text(
                      value,
                      style: AppTextStyles.subheadline,
                      textAlign: TextAlign.end,
                    ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
            height: 1,
            thickness: 0.5,
            indent: 0,
            endIndent: 0,
          ),
      ],
    );
  }
}
