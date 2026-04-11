import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/projects_viewmodel.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/app_card.dart';
import '../widgets/info_row.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class ProjectDetailView extends StatelessWidget {
  final String projectId;
  const ProjectDetailView({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsViewModel>(
      builder: (context, vm, _) {
        final project = vm.projects.firstWhere((p) => p.id == projectId, orElse: () => vm.projects.first);
        final client = vm.clientFor(project.clientId);
        return Scaffold(
          appBar: AppBar(
            title: const Text('Project Details'),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_rounded),
                onPressed: () async {
                  await Navigator.pushNamed(context, '/projects/form', arguments: project);
                  if (context.mounted) vm.refresh();
                },
              ),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded),
                color: AppColors.error,
                onPressed: () async {
                  final confirmed = await showConfirmDialog(
                    context,
                    title: 'Delete Project',
                    message: 'Delete "${project.title}"?',
                  );
                  if (confirmed && context.mounted) {
                    await vm.delete(project.id);
                    if (context.mounted) Navigator.pop(context);
                  }
                },
              ),
            ],
          ),
          body: ListView(
            padding: AppSpacing.screenPaddingAll,
            children: [
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title, style: AppTextStyles.h2),
                    const SizedBox(height: AppSpacing.sm),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (project.budget != null)
                          Text(
                            CurrencyUtils.format(project.budget!, project.currency),
                            style: AppTextStyles.amount.copyWith(color: AppColors.primary),
                          )
                        else
                          const Text('No budget set'),
                        StatusBadge.fromProjectStatus(project.status),
                      ],
                    ),
                    if (project.description != null) ...[
                      const SizedBox(height: AppSpacing.sm),
                      Text(project.description!, style: AppTextStyles.bodyMedium),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  children: [
                    InfoRow(label: 'Client', value: client?.fullName ?? 'None'),
                    InfoRow(label: 'Start Date', value: AppDateUtils.formatDate(project.startDate)),
                    InfoRow(label: 'End Date', value: AppDateUtils.formatDate(project.endDate)),
                    InfoRow(label: 'Currency', value: project.currency),
                    InfoRow(label: 'Created', value: AppDateUtils.formatDate(project.createdAt), showDivider: false),
                  ],
                ),
              ),
              if (project.note != null) ...[
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Note', style: AppTextStyles.labelLarge),
                      const SizedBox(height: AppSpacing.sm),
                      Text(project.note!, style: AppTextStyles.bodyMedium),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
