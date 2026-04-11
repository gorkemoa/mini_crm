import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/debt_form_viewmodel.dart';
import '../../models/debt_model.dart';
import '../../models/enums.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/validators.dart';

class DebtFormView extends StatefulWidget {
  final DebtModel? editDebt;
  final String? preselectedClientId;
  const DebtFormView({super.key, this.editDebt, this.preselectedClientId});

  @override
  State<DebtFormView> createState() => _DebtFormViewState();
}

class _DebtFormViewState extends State<DebtFormView> {
  final _formKey = GlobalKey<FormState>();
  late final DebtFormViewModel _vm;

  final _titleCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = context.read<DebtFormViewModel>();
    _vm.loadClients().then((_) {
      if (widget.editDebt != null) {
        _vm.loadForEdit(widget.editDebt!);
        _titleCtrl.text = _vm.title;
        _amountCtrl.text = _vm.amount;
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
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _vm.title = _titleCtrl.text;
    _vm.amount = _amountCtrl.text;
    _vm.note = _noteCtrl.text;
    final success = await _vm.submit();
    if (success && mounted) Navigator.pop(context, true);
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _vm.dueDate ?? DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      setState(() => _vm.dueDate = date);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(widget.editDebt != null ? 'Edit Debt' : 'Add Debt'),
      ),
      body: Consumer<DebtFormViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPaddingAll,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Client selector
                  DropdownButtonFormField<String>(
                    value: vm.selectedClientId,
                    decoration: const InputDecoration(labelText: 'Client *'),
                    validator: (v) => v == null ? 'Please select a client' : null,
                    items: vm.clients
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.fullName)))
                        .toList(),
                    onChanged: (v) => setState(() => vm.selectedClientId = v),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title *'),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _amountCtrl,
                          decoration: const InputDecoration(labelText: 'Amount *'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.amount,
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
                  // Due Date
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: const InputDecoration(labelText: 'Due Date'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vm.dueDate != null ? AppDateUtils.formatDate(vm.dueDate) : 'Select date',
                            style: AppTextStyles.bodyMedium,
                          ),
                          const Icon(Icons.calendar_today_rounded, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  DropdownButtonFormField<DebtStatus>(
                    value: vm.status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: DebtStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_statusLabel(s)),
                    )).toList(),
                    onChanged: (s) => setState(() => vm.status = s ?? DebtStatus.pending),
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
                        : Text(widget.editDebt != null ? 'Save Changes' : 'Add Debt'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(DebtStatus s) => switch (s) {
        DebtStatus.pending => 'Pending',
        DebtStatus.overdue => 'Overdue',
        DebtStatus.paid => 'Paid',
        DebtStatus.partial => 'Partial',
      };
}
