import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/reminder_form_viewmodel.dart';
import '../../models/reminder_model.dart';
import '../../models/enums.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/validators.dart';

class ReminderFormView extends StatefulWidget {
  final ReminderModel? editReminder;
  const ReminderFormView({super.key, this.editReminder});

  @override
  State<ReminderFormView> createState() => _ReminderFormViewState();
}

class _ReminderFormViewState extends State<ReminderFormView> {
  final _formKey = GlobalKey<FormState>();
  late final ReminderFormViewModel _vm;

  final _titleCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = context.read<ReminderFormViewModel>();
    if (widget.editReminder != null) {
      _vm.loadForEdit(widget.editReminder!);
      _titleCtrl.text = _vm.title;
      _noteCtrl.text = _vm.note;
    }
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _vm.reminderDate,
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => _vm.reminderDate = date);
  }

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _vm.reminderTime,
    );
    if (time != null) setState(() => _vm.reminderTime = time);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _vm.title = _titleCtrl.text;
    _vm.note = _noteCtrl.text;
    final success = await _vm.submit();
    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(widget.editReminder != null ? context.l10n.remindersEditTitle : context.l10n.remindersAddTitle),
      ),
      body: Consumer<ReminderFormViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPaddingAll,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(labelText: '${context.l10n.labelTitle} *'),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: _pickDate,
                          child: InputDecorator(
                            decoration: InputDecoration(labelText: context.l10n.labelDate),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(AppDateUtils.formatDate(vm.reminderDate), style: AppTextStyles.bodyMedium),
                                const Icon(Icons.calendar_today_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: InkWell(
                          onTap: _pickTime,
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Time'),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(vm.reminderTime.format(context), style: AppTextStyles.bodyMedium),
                                const Icon(Icons.access_time_rounded, size: 18),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  DropdownButtonFormField<ReminderRelatedType?>(
                    value: vm.relatedType,
                    decoration: InputDecoration(labelText: '${context.l10n.labelRelatedTo} (${context.l10n.labelOptional})'),
                    items: [
                      DropdownMenuItem<ReminderRelatedType?>(value: null, child: Text(context.l10n.labelNoClient)),
                      ...ReminderRelatedType.values.map((t) => DropdownMenuItem(
                        value: t,
                        child: Text(_relatedTypeLabel(t, context)),
                      )),
                    ],
                    onChanged: (t) => setState(() => vm.relatedType = t),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _noteCtrl,
                    decoration: InputDecoration(labelText: context.l10n.labelNote),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (vm.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(vm.errorMessage!, style: const TextStyle(color: AppColors.error), textAlign: TextAlign.center),
                    ),
                  ElevatedButton(
                    onPressed: vm.isLoading ? null : _submit,
                    child: vm.isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(widget.editReminder != null ? context.l10n.actionSave : context.l10n.remindersAddTitle),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _relatedTypeLabel(ReminderRelatedType t, BuildContext context) => switch (t) {
        ReminderRelatedType.client => context.l10n.reminderRelatedClient,
        ReminderRelatedType.debt => context.l10n.reminderRelatedDebt,
        ReminderRelatedType.project => context.l10n.reminderRelatedProject,
        ReminderRelatedType.lead => context.l10n.reminderRelatedLead,
        ReminderRelatedType.income => context.l10n.reminderRelatedIncome,
        ReminderRelatedType.general => context.l10n.reminderRelatedGeneral,
      };
}
