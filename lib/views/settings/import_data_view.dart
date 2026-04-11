import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/data_viewmodel.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/confirm_dialog.dart';

class ImportDataView extends StatelessWidget {
  const ImportDataView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.importTitle)),
      body: Consumer<DataViewModel>(
        builder: (context, vm, _) {
          return Padding(
            padding: AppSpacing.screenPaddingAll,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.download_rounded, size: 64, color: AppColors.info),
                const SizedBox(height: AppSpacing.lg),
                Text(context.l10n.importTitle, style: AppTextStyles.h2, textAlign: TextAlign.center),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.l10n.importDesc,
                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondaryLight),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xl),
                if (vm.previewBundle != null) _buildPreview(context, vm),
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
                if (vm.previewBundle == null)
                  ElevatedButton.icon(
                    onPressed: vm.isLoading ? null : () => vm.pickImportFile(),
                    icon: const Icon(Icons.folder_open_rounded),
                    label: Text(context.l10n.importButton),
                  ),
                if (vm.previewBundle != null) ...[
                  FilledButton(
                    style: FilledButton.styleFrom(backgroundColor: AppColors.error),
                    onPressed: vm.isLoading
                        ? null
                        : () async {
                            final confirmed = await showConfirmDialog(
                              context,
                              title: context.l10n.importTitle,
                              message: context.l10n.importWarning,
                              confirmLabel: context.l10n.actionImport,
                              isDangerous: true,
                            );
                            if (confirmed && context.mounted) {
                              final success = await vm.confirmImport();
                              if (success && context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(context.l10n.importSuccess),
                                    backgroundColor: AppColors.success,
                                  ),
                                );
                                Navigator.of(context).pop();
                              }
                            }
                          },
                    child: vm.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(context.l10n.actionConfirm),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    onPressed: vm.clearPreview,
                    child: Text(context.l10n.actionCancel),
                  ),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildPreview(BuildContext context, DataViewModel vm) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bundle = vm.previewBundle!;
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: AppSpacing.cardPaddingAll,
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Preview', style: AppTextStyles.labelLarge),
          const SizedBox(height: AppSpacing.sm),
          _previewRow('Exported on', AppDateUtils.formatDate(bundle.exportDate)),
          _previewRow('Schema version', bundle.schemaVersion),
          _previewRow('Clients', '${bundle.clients.length}'),
          _previewRow('Debts', '${bundle.debts.length}'),
          _previewRow('Projects', '${bundle.projects.length}'),
          _previewRow('Leads', '${bundle.leads.length}'),
          _previewRow('Income records', '${bundle.incomes.length}'),
          _previewRow('Reminders', '${bundle.reminders.length}'),
        ],
      ),
    );
  }

  Widget _previewRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
          Text(value, style: AppTextStyles.labelSmall),
        ],
      ),
    );
  }
}
