import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/data_viewmodel.dart';

class ExportDataView extends StatelessWidget {
  const ExportDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.exportTitle)),
      body: Consumer<DataViewModel>(
        builder: (context, vm, _) {
          return Padding(
            padding: AppSpacing.screenPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.upload_rounded, size: 64, color: AppColors.primary),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  context.l10n.exportTitle,
                  style: AppTextStyles.h2,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.exportDesc,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                if (vm.errorMessage != null)
                  Container(
                    padding: AppSpacing.cardPaddingAll,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      vm.errorMessage!,
                      style: const TextStyle(color: AppColors.error),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: vm.isLoading
                      ? null
                      : () async {
                          final success = await vm.export();
                          if (success && context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(context.l10n.exportSuccess),
                                backgroundColor: AppColors.success,
                              ),
                            );
                          }
                        },
                  icon: vm.isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.share_rounded),
                  label: Text(context.l10n.exportButton),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
