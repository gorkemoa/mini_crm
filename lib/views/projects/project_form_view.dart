import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/project_form_viewmodel.dart';
import '../../models/project_model.dart';
import '../../models/enums.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/validators.dart';

class ProjectFormView extends StatefulWidget {
  final ProjectModel? editProject;
  final String? preselectedClientId;
  const ProjectFormView({super.key, this.editProject, this.preselectedClientId});

  @override
  State<ProjectFormView> createState() => _ProjectFormViewState();
}

class _ProjectFormViewState extends State<ProjectFormView> {
  final _formKey = GlobalKey<FormState>();
  late final ProjectFormViewModel _vm;

  final _titleCtrl = TextEditingController();
  final _descCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = context.read<ProjectFormViewModel>();
    _vm.loadClients().then((_) {
      if (widget.editProject != null) {
        _vm.loadForEdit(widget.editProject!);
        _titleCtrl.text = _vm.title;
        _descCtrl.text = _vm.description;
        _budgetCtrl.text = _vm.budget;
        _noteCtrl.text = _vm.note;
      } else if (widget.preselectedClientId != null) {
        _vm.selectedClientId = widget.preselectedClientId;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _budgetCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isStart) async {
    final initial = isStart
        ? (_vm.startDate ?? DateTime.now())
        : (_vm.endDate ?? DateTime.now().add(const Duration(days: 30)));
    final date = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() {
        if (isStart) {
          _vm.startDate = date;
        } else {
          _vm.endDate = date;
        }
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _vm.title = _titleCtrl.text;
    _vm.description = _descCtrl.text;
    _vm.budget = _budgetCtrl.text;
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
        title: Text(widget.editProject != null ? 'Edit Project' : 'Add Project'),
      ),
      body: Consumer<ProjectFormViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPaddingAll,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: vm.selectedClientId,
                    decoration: const InputDecoration(labelText: 'Client (optional)'),
                    items: [
                      const DropdownMenuItem<String>(value: null, child: Text('None')),
                      ...vm.clients.map((c) => DropdownMenuItem(value: c.id, child: Text(c.fullName))),
                    ],
                    onChanged: (v) => setState(() => vm.selectedClientId = v),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: 'Project Title *'),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _descCtrl,
                    decoration: const InputDecoration(labelText: 'Description'),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDate(true),
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'Start Date'),
                            child: Text(
                              AppDateUtils.formatDate(vm.startDate),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: InkWell(
                          onTap: () => _pickDate(false),
                          child: InputDecorator(
                            decoration: const InputDecoration(labelText: 'End Date'),
                            child: Text(
                              AppDateUtils.formatDate(vm.endDate),
                              style: AppTextStyles.bodyMedium,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _budgetCtrl,
                          decoration: const InputDecoration(labelText: 'Budget'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.positiveNumber,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: vm.currency,
                          decoration: const InputDecoration(labelText: 'Currency'),
                          items: CurrencyUtils.supportedCurrencies
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => vm.currency = v ?? 'USD'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  DropdownButtonFormField<ProjectStatus>(
                    value: vm.status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: ProjectStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_statusLabel(s)),
                    )).toList(),
                    onChanged: (s) => setState(() => vm.status = s ?? ProjectStatus.active),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _noteCtrl,
                    decoration: const InputDecoration(labelText: 'Note'),
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
                        : Text(widget.editProject != null ? 'Save Changes' : 'Add Project'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(ProjectStatus s) => switch (s) {
        ProjectStatus.planned => 'Planned',
        ProjectStatus.startingSoon => 'Starting Soon',
        ProjectStatus.active => 'Active',
        ProjectStatus.paused => 'Paused',
        ProjectStatus.completed => 'Completed',
        ProjectStatus.cancelled => 'Cancelled',
      };
}
