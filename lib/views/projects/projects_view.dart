import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/route_names.dart';
import '../../models/project_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/projects_viewmodel.dart';
import '../widgets/badges.dart';
import '../widgets/empty_state.dart';

class ProjectsView extends StatefulWidget {
  const ProjectsView({super.key});

  @override
  State<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends State<ProjectsView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectsViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.screenPaddingV,
                    AppSpacing.screenPaddingH,
                    0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Projeler', style: AppTextStyles.largeTitle),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: AppColors.primary,
                        onPressed: () async {
                          await Navigator.pushNamed(
                            context,
                            RouteNames.projectForm,
                          );
                          if (context.mounted) vm.refresh();
                        },
                      ),
                    ],
                  ),
                ),

                // Filter chips
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                    AppSpacing.screenPaddingH,
                    AppSpacing.sm,
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _Chip(
                          label: 'Tümü',
                          isSelected: vm.statusFilter == null,
                          onTap: () => vm.filterByStatus(null),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        ...ProjectStatus.values.map((s) => Padding(
                              padding: const EdgeInsets.only(
                                  right: AppSpacing.xs),
                              child: _Chip(
                                label: s.label,
                                isSelected: vm.statusFilter == s,
                                onTap: () => vm.filterByStatus(s),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),

                // List
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.items.isEmpty
                          ? EmptyState(
                              icon: Icons.work_outline,
                              title: 'Henüz proje yok',
                              subtitle: 'İlk projeyi ekleyerek başla.',
                              actionLabel: 'Proje Ekle',
                              onAction: () async {
                                await Navigator.pushNamed(
                                  context,
                                  RouteNames.projectForm,
                                );
                                if (context.mounted) vm.refresh();
                              },
                            )
                          : RefreshIndicator(
                              onRefresh: vm.refresh,
                              color: AppColors.primary,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(
                                  left: AppSpacing.screenPaddingH,
                                  right: AppSpacing.screenPaddingH,
                                  bottom: AppSpacing.xxxl,
                                ),
                                itemCount: vm.items.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(height: AppSpacing.xs),
                                itemBuilder: (context, i) => _ProjectTile(
                                  project: vm.items[i],
                                  onTap: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      RouteNames.projectDetail,
                                      arguments: vm.items[i],
                                    );
                                    if (context.mounted) vm.refresh();
                                  },
                                  onEdit: () async {
                                    await Navigator.pushNamed(
                                      context,
                                      RouteNames.projectForm,
                                      arguments: {'project': vm.items[i]},
                                    );
                                    if (context.mounted) vm.refresh();
                                  },
                                  onDelete: () => vm.delete(vm.items[i].id),
                                ),
                              ),
                            ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm + 4,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(
          label,
          style: AppTextStyles.caption1.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _ProjectTile extends StatelessWidget {
  final ProjectModel project;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ProjectTile({
    required this.project,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.cardPadding),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        project.title,
                        style: AppTextStyles.subheadline
                            .copyWith(fontWeight: FontWeight.w500),
                      ),
                      if (project.clientName != null)
                        Text(
                          project.clientName!,
                          style: AppTextStyles.caption1,
                        ),
                      if (project.endDate != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          'Bitiş: ${project.endDate!.day}.${project.endDate!.month}.${project.endDate!.year}',
                          style: AppTextStyles.caption2.copyWith(
                            color: AppColors.textTertiary,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ProjectStatusBadge(status: project.status),
                    if (project.budget != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        '${project.budget!.toStringAsFixed(0)} ${project.currency}',
                        style: AppTextStyles.caption1.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(width: AppSpacing.xs),
                PopupMenuButton<String>(
                  icon: const Icon(
                    Icons.more_horiz,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                  itemBuilder: (_) => [
                    const PopupMenuItem(value: 'edit', child: Text('Düzenle')),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Sil',
                          style: TextStyle(color: AppColors.danger)),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'edit') onEdit();
                    if (v == 'delete') onDelete();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
