import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/income_form_viewmodel.dart';
import '../../models/income_model.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/validators.dart';

class IncomeFormView extends StatefulWidget {
  final IncomeModel? editIncome;
  const IncomeFormView({super.key, this.editIncome});

  @override
  State<IncomeFormView> createState() => _IncomeFormViewState();
}

class _IncomeFormViewState extends State<IncomeFormView> {
  final _formKey = GlobalKey<FormState>();
  late final IncomeFormViewModel _vm;

  final _platformCtrl = TextEditingController();
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = context.read<IncomeFormViewModel>();
    _vm.loadClients().then((_) {
      if (widget.editIncome != null) {
        _vm.loadForEdit(widget.editIncome!);
        _platformCtrl.text = _vm.sourcePlatform;
        _amountCtrl.text = _vm.amount;
        _noteCtrl.text = _vm.note;
      }
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _platformCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _vm.date,
      firstDate: DateTime(2020),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (date != null) setState(() => _vm.date = date);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _vm.sourcePlatform = _platformCtrl.text;
    _vm.amount = _amountCtrl.text;
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
        title: Text(widget.editIncome != null ? context.l10n.incomeEditTitle : context.l10n.incomeAddTitle),
      ),
      body: Consumer<IncomeFormViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPaddingAll,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _platformCtrl,
                    decoration: InputDecoration(
                      labelText: context.l10n.labelPlatform,
                      hintText: 'e.g. Upwork, Fiverr, Direct',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  DropdownButtonFormField<String>(
                    value: vm.selectedClientId,
                    decoration: InputDecoration(labelText: '${context.l10n.labelClient} (${context.l10n.labelOptional})'),
                    items: [
                      DropdownMenuItem<String>(value: null, child: Text(context.l10n.labelNoClient)),
                      ...vm.clients.map((c) => DropdownMenuItem(value: c.id, child: Text(c.fullName))),
                    ],
                    onChanged: (v) => setState(() => vm.selectedClientId = v),
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
                  InkWell(
                    onTap: _pickDate,
                    child: InputDecorator(
                      decoration: InputDecoration(labelText: '${context.l10n.labelDate} *'),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(AppDateUtils.formatDate(vm.date), style: AppTextStyles.bodyMedium),
                          const Icon(Icons.calendar_today_rounded, size: 18),
                        ],
                      ),
                    ),
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
                        : Text(widget.editIncome != null ? context.l10n.actionSave : context.l10n.incomeAddTitle),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
