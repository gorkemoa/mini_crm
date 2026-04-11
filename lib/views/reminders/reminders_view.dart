import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../themes/app_radii.dart';
import '../../viewmodels/reminders_viewmodel.dart';
import '../../models/reminder_model.dart';
import '../../core/utils/app_date_utils.dart';
import '../widgets/empty_state.dart';
import '../widgets/confirm_dialog.dart';

class RemindersView extends StatefulWidget {
  const RemindersView({super.key});

  @override
  State<RemindersView> createState() => _RemindersViewState();
}

class _RemindersViewState extends State<RemindersView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RemindersViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Reminders'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded),
            onPressed: () async {
              await Navigator.pushNamed(context, '/reminders/form');
              if (context.mounted) context.read<RemindersViewModel>().refresh();
            },
          ),
        ],
      ),
      body: Consumer<RemindersViewModel>(
        builder: (context, vm, _) {
          return RefreshIndicator(
            onRefresh: vm.refresh,
            child: Column(
              children: [
                _buildFilterRow(context, vm),
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.isEmpty
                          ? EmptyState(
                              icon: Icons.alarm_outlined,
                              title: 'No reminders',
                              description: 'Add reminders for follow-ups and tasks',
                              actionLabel: 'Add Reminder',
                              onAction: () async {
                                await Navigator.pushNamed(context, '/reminders/form');
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
          await Navigator.pushNamed(context, '/reminders/form');
          if (context.mounted) context.read<RemindersViewModel>().refresh();
        },
        child: const Icon(Icons.add_rounded),
      ),
    );
  }

  Widget _buildFilterRow(BuildContext context, RemindersViewModel vm) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ReminderFilter.values.map((f) {
            final selected = vm.filter == f;
            return Padding(
              padding: const EdgeInsets.only(right: AppSpacing.xs),
              child: GestureDetector(
                onTap: () => vm.setFilter(f),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(AppRadii.chip),
                    border: Border.all(color: selected ? AppColors.primary : AppColors.borderLight),
                  ),
                  child: Text(
                    _filterLabel(f),
                    style: AppTextStyles.labelSmall.copyWith(
                      color: selected ? Colors.white : AppColors.textSecondaryLight,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildList(BuildContext context, RemindersViewModel vm) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
      itemCount: vm.reminders.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, i) {
        final reminder = vm.reminders[i];
        return _ReminderTile(
          reminder: reminder,
          onToggle: () => vm.toggleComplete(reminder),
          onTap: () async {
            await Navigator.pushNamed(context, '/reminders/form', arguments: reminder);
            if (context.mounted) vm.refresh();
          },
          onDelete: () async {
            final confirmed = await showConfirmDialog(
              context,
              title: 'Delete Reminder',
              message: 'Delete "${reminder.title}"?',
            );
            if (confirmed && context.mounted) vm.delete(reminder.id);
          },
        );
      },
    );
  }

  String _filterLabel(ReminderFilter f) => switch (f) {
        ReminderFilter.all => 'All',
        ReminderFilter.today => 'Today',
        ReminderFilter.upcoming => 'Upcoming',
        ReminderFilter.overdue => 'Overdue',
        ReminderFilter.completed => 'Completed',
      };
}

class _ReminderTile extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ReminderTile({required this.reminder, required this.onToggle, required this.onTap, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverdue = reminder.isOverdue && !reminder.isCompleted;
    final isToday = reminder.isToday && !reminder.isCompleted;
    Color borderColor;
    if (isOverdue) {
      borderColor = AppColors.error.withValues(alpha: 0.5);
    } else if (isToday) {
      borderColor = AppColors.warning.withValues(alpha: 0.5);
    } else {
      borderColor = isDark ? AppColors.borderDark : AppColors.borderLight;
    }

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(AppRadii.card),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadii.card),
        child: Padding(
          padding: AppSpacing.cardPaddingAll,
          child: Row(
            children: [
              GestureDetector(
                onTap: onToggle,
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: reminder.isCompleted ? AppColors.success : Colors.transparent,
                    border: Border.all(
                      color: reminder.isCompleted ? AppColors.success : AppColors.borderLight,
                      width: 2,
                    ),
                  ),
                  child: reminder.isCompleted
                      ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                      : null,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: AppTextStyles.labelLarge.copyWith(
                        decoration: reminder.isCompleted ? TextDecoration.lineThrough : null,
                        color: reminder.isCompleted ? AppColors.textTertiaryLight : null,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      AppDateUtils.formatDate(reminder.reminderDate),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: isOverdue
                            ? AppColors.error
                            : isToday
                                ? AppColors.warning
                                : AppColors.textTertiaryLight,
                      ),
                    ),
                    if (reminder.note != null)
                      Text(
                        reminder.note!,
                        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondaryLight),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
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
