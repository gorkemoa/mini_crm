import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';

class SearchField extends StatelessWidget {
  final String hint;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;

  const SearchField({
    super.key,
    required this.hint,
    required this.onChanged,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextField(
      controller: controller,
      onChanged: onChanged,
      style: AppTextStyles.bodyMedium.copyWith(
        color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
      ),
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(
          Icons.search_rounded,
          color: isDark ? AppColors.textTertiaryDark : AppColors.textTertiaryLight,
          size: 20,
        ),
        filled: true,
        fillColor: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadii.input),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        isDense: true,
      ),
    );
  }
}
