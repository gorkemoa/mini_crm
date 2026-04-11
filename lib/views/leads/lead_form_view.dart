import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/lead_form_viewmodel.dart';
import '../../models/lead_model.dart';
import '../../models/enums.dart';
import '../../core/utils/currency_utils.dart';
import '../../core/utils/app_date_utils.dart';
import '../../core/utils/validators.dart';

class LeadFormView extends StatefulWidget {
  final LeadModel? editLead;
  const LeadFormView({super.key, this.editLead});

  @override
  State<LeadFormView> createState() => _LeadFormViewState();
}

class _LeadFormViewState extends State<LeadFormView> {
  final _formKey = GlobalKey<FormState>();
  late final LeadFormViewModel _vm;

  final _nameCtrl = TextEditingController();
  final _sourceCtrl = TextEditingController();
  final _budgetCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = context.read<LeadFormViewModel>();
    if (widget.editLead != null) {
      _vm.loadForEdit(widget.editLead!);
      _nameCtrl.text = _vm.name;
      _sourceCtrl.text = _vm.source;
      _budgetCtrl.text = _vm.estimatedBudget;
      _noteCtrl.text = _vm.note;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _sourceCtrl.dispose();
    _budgetCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _vm.nextFollowUpDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) setState(() => _vm.nextFollowUpDate = date);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _vm.name = _nameCtrl.text;
    _vm.source = _sourceCtrl.text;
    _vm.estimatedBudget = _budgetCtrl.text;
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
        title: Text(widget.editLead != null ? context.l10n.leadsEditTitle : context.l10n.leadsAddTitle),
      ),
      body: Consumer<LeadFormViewModel>(
        builder: (context, vm, _) {
          return SingleChildScrollView(
            padding: AppSpacing.screenPaddingAll,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _nameCtrl,
                    decoration: InputDecoration(labelText: '${context.l10n.labelName} *'),
                    validator: Validators.required,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _sourceCtrl,
                    decoration: InputDecoration(
                      labelText: context.l10n.labelSource,
                      hintText: 'e.g. LinkedIn, Website, Referral',
                    ),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  DropdownButtonFormField<LeadStage>(
                    value: vm.stage,
                    decoration: InputDecoration(labelText: context.l10n.labelStage),
                    items: LeadStage.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_stageLabel(s, context)),
                    )).toList(),
                    onChanged: (s) => setState(() => vm.stage = s ?? LeadStage.newLead),
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: TextFormField(
                          controller: _budgetCtrl,
                          decoration: InputDecoration(labelText: context.l10n.labelEstimatedBudget),
                          keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          validator: Validators.positiveNumber,
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
                      decoration: InputDecoration(labelText: context.l10n.labelFollowUpDate),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            vm.nextFollowUpDate != null ? AppDateUtils.formatDate(vm.nextFollowUpDate) : 'Select date',
                            style: AppTextStyles.bodyMedium,
                          ),
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
                        : Text(widget.editLead != null ? context.l10n.actionSave : context.l10n.leadsAddTitle),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _stageLabel(LeadStage s, BuildContext context) => switch (s) {
        LeadStage.newLead => context.l10n.leadStageNew,
        LeadStage.contacted => context.l10n.leadStageContacted,
        LeadStage.proposalSent => context.l10n.leadStageProposalSent,
        LeadStage.negotiating => context.l10n.leadStageNegotiating,
        LeadStage.won => context.l10n.leadStageWon,
        LeadStage.lost => context.l10n.leadStageLost,
      };
}
