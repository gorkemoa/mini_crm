import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? color;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = color ??
        (isDark ? AppColors.surfaceDark : AppColors.surfaceLight);
    final borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;

    final content = Padding(
      padding: padding ?? AppSpacing.cardPaddingAll,
      child: child,
    );

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: borderColor, width: 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(AppRadii.card),
              child: content,
            )
          : content,
    );
  }
}
