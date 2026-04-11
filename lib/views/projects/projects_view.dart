import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/projects_viewmodel.dart';
import '../../models/project_model.dart';
import '../../models/enums.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/search_field.dart';
import '../widgets/status_badge.dart';
import '../widgets/confirm_dialog.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsViewModel>().load();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Projects'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              await Navigator.pushNamed(context, '/projects/form');
              if (context.mounted) context.read<ProjectsViewModel>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<ProjectsViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                Padding(
                  padding: AppSpacing.screenPaddingH.copyWith(
                    top: AppSpacing.sm,
                    bottom: AppSpacing.sm,
                  ),
                  child: Column(
                    children: [
                      SearchField(
                        controller: _searchCtrl,
                        hint: 'Search projects...',
                        onChanged: vm.setSearch,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      _buildFilterRow(context, vm),
                    ],
                  ),
                ),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.isEmpty
                          ? EmptyState(
                              icon: Icons.work_outline_rounded,
                              title: 'No projects yet',
                              description: 'Add your first project',
                              actionLabel: 'Add Project',
                              onAction: () async {
                                await Navigator.pushNamed(context, '/projects/form');
                                if (context.mounted) vm.refresh();
                              },
                            )
                          : _buildList(context, vm),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/projects/form');
          if (context.mounted) context.read<ProjectsViewModel>().refresh();
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, ProjectsViewModel vm) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _Chip(label: 'All', selected: vm.statusFilter == null, onTap: () => vm.setStatusFilter(null)),
          const SizedBox(width: AppSpacing.xs),
          _Chip(label: 'Active', selected: vm.statusFilter == ProjectStatus.active, onTap: () => vm.setStatusFilter(ProjectStatus.active)),
          const SizedBox(width: AppSpacing.xs),
          _Chip(label: 'Paused', selected: vm.statusFilter == ProjectStatus.paused, onTap: () => vm.setStatusFilter(ProjectStatus.paused)),
          const SizedBox(width: AppSpacing.xs),
          _Chip(label: 'Completed', selected: vm.statusFilter == ProjectStatus.completed, onTap: () => vm.setStatusFilter(ProjectStatus.completed)),
          const SizedBox(width: AppSpacing.xs),
          _Chip(label: 'Cancelled', selected: vm.statusFilter == ProjectStatus.cancelled, onTap: () => vm.setStatusFilter(ProjectStatus.cancelled)),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, ProjectsViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 80),
      itemCount: vm.projects.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final project = vm.projects[i];
        final client = vm.clientFor(project.clientId);
        return _ProjectTile(
          project: project,
          clientName: client?.fullName,
          onTap: () async {
            await Navigator.pushNamed(context, '/projects/detail', arguments: project.id);
            if (context.mounted) vm.refresh();
          },
          onDelete: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: 'Delete Project',
              message: 'Delete "${project.title}"?',
            );
            if (confirmed && context.mounted) vm.delete(project.id);
          },
        );
      },
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final ProjectModel project;
  final String? clientName;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ProjectTile({required this.project, this.clientName, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: AppSpacing.cardPaddingAll,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(project.title, style: AppTextStyles.labelLarge),
                    if (clientName != null) ...[
                      const SizedBox(height: 2),
                      Text(clientName!, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight)),
                    ],
                    if (project.endDate != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        'Deadline: ${AppDateUtils.formatDate(project.endDate)}',
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textTertiaryLight),
                      ),
                    ],
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (project.budget != null)
                    Text(CurrencyUtils.format(project.budget!, project.currency), style: AppTextStyles.amountSmall),
                  const SizedBox(height: 4),
                  StatusBadge.fromProjectStatus(project.status),
                ],
              ),
              const SizedBox(width: AppSpacing.sm),
              IconButton(
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                color: AppColors.error,
                onPressed: onDelete,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _Chip({required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppRadii.chip),
          border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
        ),
        child: Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: selected ? Colors.white : AppColors.textSecondaryLight,
          ),
        ),
      ),
    );
  }
}
