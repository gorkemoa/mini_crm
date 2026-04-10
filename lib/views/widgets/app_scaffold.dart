import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? floatingActionButton;
  final bool showBack;
  final VoidCallback? onBack;
  final Widget? bottom;
  final bool useLargeTitle;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.floatingActionButton,
    this.showBack = false,
    this.onBack,
    this.bottom,
    this.useLargeTitle = false,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(title),
        leading: showBack
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, size: 18),
                onPressed: onBack ?? () => Navigator.of(context).pop(),
              )
            : null,
        actions: actions,
        bottom: bottom != null
            ? PreferredSize(
                preferredSize: const Size.fromHeight(48),
                child: bottom!,
              )
            : null,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPaddingH,
          ),
          child: body,
        ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
