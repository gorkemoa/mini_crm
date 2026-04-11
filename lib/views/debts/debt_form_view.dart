import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
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
        title: Text(widget.editDebt != null ? context.l10n.debtsEditTitle : context.l10n.debtsAddTitle),
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
                    decoration: InputDecoration(labelText: '${context.l10n.labelClient} *'),
                    validator: (v) => v == null ? context.l10n.validationRequired : null,
                    items: vm.clients
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.fullName)))
                        .toList(),
                    onChanged: (v) => setState(() => vm.selectedClientId = v),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _titleCtrl,
                    decoration: InputDecoration(labelText: '${context.l10n.labelTitle} *'),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _amountCtrl,
                          decoration: InputDecoration(labelText: '${context.l10n.labelAmount} *'),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.amount,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: vm.currency,
                          decoration: InputDecoration(labelText: context.l10n.labelCurrency),
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
                      decoration: InputDecoration(labelText: context.l10n.labelDueDate),
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
                    decoration: InputDecoration(labelText: context.l10n.labelStatus),
                    items: DebtStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_statusLabel(s, context)),
                    )).toList(),
                    onChanged: (s) => setState(() => vm.status = s ?? DebtStatus.pending),
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
                        : Text(widget.editDebt != null ? context.l10n.actionSave : context.l10n.debtsAddTitle),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(DebtStatus s, BuildContext context) => switch (s) {
        DebtStatus.pending => context.l10n.debtStatusPending,
        DebtStatus.overdue => context.l10n.debtStatusOverdue,
        DebtStatus.paid => context.l10n.debtStatusPaid,
        DebtStatus.partial => context.l10n.debtStatusPartial,
      };
}
