import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/date_utils.dart';
import '../../models/reminder_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/reminders_viewmodel.dart';
import '../widgets/empty_state.dart';

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
    return Consumer<RemindersViewModel>(
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
                      Text('Hatırlatıcılar',
                          style: AppTextStyles.largeTitle),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.add),
                        color: AppColors.primary,
                        onPressed: () => _showAddSheet(context, vm),
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
                      children: ReminderFilter.values
                          .map((f) => Padding(
                                padding: const EdgeInsets.only(
                                    right: AppSpacing.xs),
                                child: _Chip(
                                  label: f.label,
                                  isSelected: vm.filter == f,
                                  onTap: () => vm.setFilter(f),
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),

                // List
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : vm.items.isEmpty
                          ? EmptyState(
                              icon: Icons.notifications_none_outlined,
                              title: 'Hatırlatıcı yok',
                              subtitle:
                                  'Önemli tarihleri ve görevleri buraya ekle.',
                              actionLabel: 'Ekle',
                              onAction: () =>
                                  _showAddSheet(context, vm),
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
                                itemBuilder: (context, i) =>
                                    _ReminderTile(
                                  reminder: vm.items[i],
                                  onToggle: () => vm.toggleComplete(
                                      vm.items[i]),
                                  onDelete: () =>
                                      vm.delete(vm.items[i].id),
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

  void _showAddSheet(BuildContext context, RemindersViewModel vm) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _AddReminderSheet(onAdd: (title, date) {
        vm.addReminder(title: title, date: date);
      }),
    );
  }
}

class _Chip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  const _Chip(
      {required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm + 4, vertical: AppSpacing.xs + 2),
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

class _ReminderTile extends StatelessWidget {
  final ReminderModel reminder;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _ReminderTile({
    required this.reminder,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = reminder.isOverdue;
    final isCompleted = reminder.isCompleted;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onToggle,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.cardPadding,
              vertical: AppSpacing.sm + 4,
            ),
            child: Row(
              children: [
                // Checkbox
                GestureDetector(
                  onTap: onToggle,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isCompleted
                            ? AppColors.success
                            : isOverdue
                                ? AppColors.danger
                                : AppColors.separator,
                        width: 2,
                      ),
                      color: isCompleted
                          ? AppColors.success
                          : Colors.transparent,
                    ),
                    child: isCompleted
                        ? const Icon(Icons.check,
                            size: 14, color: Colors.white)
                        : null,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),

                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style: AppTextStyles.subheadline.copyWith(
                          fontWeight: FontWeight.w500,
                          decoration: isCompleted
                              ? TextDecoration.lineThrough
                              : null,
                          color: isCompleted
                              ? AppColors.textTertiary
                              : AppColors.textPrimary,
                        ),
                      ),
                      if (reminder.note != null &&
                          reminder.note!.isNotEmpty)
                        Text(
                          reminder.note!,
                          style: AppTextStyles.caption1.copyWith(
                              color: AppColors.textSecondary),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      Text(
                        AppDateUtils.relativeLabel(reminder.reminderDate),
                        style: AppTextStyles.caption2.copyWith(
                          color: reminder.isOverdue && !reminder.isCompleted
                              ? AppColors.danger
                              : AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),

                // Type pill
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceSecondary,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    reminder.relatedType.label,
                    style: AppTextStyles.caption2.copyWith(
                        color: AppColors.textSecondary),
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),

                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_horiz,
                      color: AppColors.textTertiary, size: 20),
                  itemBuilder: (_) => [
                    PopupMenuItem(
                      value: 'toggle',
                      child: Text(reminder.isCompleted
                          ? 'Tamamlanmadı olarak işaretle'
                          : 'Tamamlandı'),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Sil',
                          style: TextStyle(color: AppColors.danger)),
                    ),
                  ],
                  onSelected: (v) {
                    if (v == 'toggle') onToggle();
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

// ─── Add reminder bottom sheet ────────────────────────────────────────────────

class _AddReminderSheet extends StatefulWidget {
  final void Function(String title, DateTime date) onAdd;

  const _AddReminderSheet({required this.onAdd});

  @override
  State<_AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<_AddReminderSheet> {
  final _titleCtrl = TextEditingController();
  DateTime _date = DateTime.now().add(const Duration(days: 1));
  String? _error;

  @override
  void dispose() {
    _titleCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Container(
      margin: EdgeInsets.only(bottom: bottom),
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.screenPaddingH,
        AppSpacing.md,
        AppSpacing.screenPaddingH,
        AppSpacing.lg,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius:
            BorderRadius.vertical(top: Radius.circular(AppRadii.sheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.separator,
                borderRadius: BorderRadius.circular(100),
              ),
            ),
          ),
          Text('Hatırlatıcı Ekle', style: AppTextStyles.title3),
          const SizedBox(height: AppSpacing.md),

          // Title field
          TextField(
            controller: _titleCtrl,
            autofocus: true,
            style: AppTextStyles.body,
            decoration: InputDecoration(
              hintText: 'Hatırlatıcı başlığı...',
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadii.input),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: AppSpacing.xs),
            Text(_error!,
                style: AppTextStyles.footnote
                    .copyWith(color: AppColors.danger)),
          ],

          const SizedBox(height: AppSpacing.sm),

          // Date picker row
          GestureDetector(
            onTap: () async {
              final d = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime.now(),
                lastDate: DateTime(2030),
              );
              if (d != null) setState(() => _date = d);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm + 4, vertical: AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(AppRadii.input),
              ),
              child: Row(
                children: [
                  const Icon(Icons.calendar_today_outlined,
                      size: 18, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.xs),
                  Text(
                    '${_date.day}.${_date.month}.${_date.year}',
                    style: AppTextStyles.body
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                final t = _titleCtrl.text.trim();
                if (t.isEmpty) {
                  setState(() => _error = 'Başlık boş olamaz.');
                  return;
                }
                widget.onAdd(t, _date);
                Navigator.pop(context);
              },
              child: const Text('Kaydet'),
            ),
          ),
        ],
      ),
    );
  }
}

// extend ReminderFilter with label
extension _FilterLabel on ReminderFilter {
  String get label {
    switch (this) {
      case ReminderFilter.all:
        return 'Tümü';
      case ReminderFilter.today:
        return 'Bugün';
      case ReminderFilter.upcoming:
        return 'Yaklaşan';
      case ReminderFilter.overdue:
        return 'Geçmiş';
      case ReminderFilter.completed:
        return 'Tamamlanan';
    }
  }
}
