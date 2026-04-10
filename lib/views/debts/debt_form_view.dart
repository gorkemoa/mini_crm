import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/l10n_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../models/debt_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/debt_form_viewmodel.dart';
import '../widgets/primary_button.dart';

class DebtFormView extends StatefulWidget {
  final DebtModel? initialDebt;
  final String? initialClientId;

  const DebtFormView({
    super.key,
    this.initialDebt,
    this.initialClientId,
  });

  @override
  State<DebtFormView> createState() => _DebtFormViewState();
}

class _DebtFormViewState extends State<DebtFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    final debt = widget.initialDebt;
    _titleCtrl = TextEditingController(text: debt?.title ?? '');
    _amountCtrl = TextEditingController(
      text: debt != null ? debt.amount.toStringAsFixed(2) : '',
    );
    _noteCtrl = TextEditingController(text: debt?.note ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DebtFormViewModel>().init(
            editDebt: widget.initialDebt,
            preselectedClientId: widget.initialClientId,
          );
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DebtFormViewModel>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        if (vm.saved) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.pop(context, true);
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              widget.initialDebt == null ? l10n.newDebt : l10n.editDebt,
              style: AppTextStyles.navTitle,
            ),
            backgroundColor: AppColors.surface,
          ),
          body: SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.screenPaddingH,
                  vertical: AppSpacing.md,
                ),
                children: [
                  // Client picker
                  _FormSection(
                    children: [
                      _Label(l10n.customer),
                      DropdownButton<String?>(
                        value: vm.selectedClientId,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        hint: Text(
                          l10n.selectCustomerOptional,
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.textTertiary),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: null,
                            child: Text(l10n.noCustomer),
                          ),
                          ...vm.clients.map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(c.displayName),
                            ),
                          ),
                        ],
                        onChanged: (v) => vm.selectedClientId = v,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Title + amount
                  _FormSection(
                    children: [
                      _AppTextField(
                        controller: _titleCtrl,
                        label: l10n.debtTitleLabel,
                        hint: l10n.debtTitleHint,
                        validator: (_) => localizeValidator(l10n, vm.validateTitle()),
                        onChanged: (v) => vm.title = v,
                      ),
                      _Divider(),
                      Row(
                        children: [
                          Expanded(
                            child: _AppTextField(
                              controller: _amountCtrl,
                              label: l10n.amount,
                              hint: l10n.amountHint,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                decimal: true,
                              ),
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp(r'^\d*\.?\d{0,2}'),
                                ),
                              ],
                              validator: (_) => localizeValidator(l10n, vm.validateAmount()),
                              onChanged: (v) => vm.amount = v,
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          DropdownButton<String>(
                            value: vm.currency,
                            underline: const SizedBox.shrink(),
                            items: AppConstants.currencies
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) vm.currency = v;
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Due date + status
                  _FormSection(
                    children: [
                      _DatePickerRow(
                        label: l10n.dueDate,
                        value: vm.dueDate,
                        onPicked: (d) => vm.dueDate = d,
                      ),
                      _Divider(),
                      _Label(l10n.status),
                      DropdownButton<DebtStatus>(
                        value: vm.status,
                        isExpanded: true,
                        underline: const SizedBox.shrink(),
                        items: DebtStatus.values
                            .map(
                              (s) => DropdownMenuItem(
                                value: s,
                                child: Text(switch (s) {
                                  DebtStatus.pending => l10n.debtPending,
                                  DebtStatus.overdue => l10n.debtOverdue,
                                  DebtStatus.paid => l10n.debtPaid,
                                  DebtStatus.partial => l10n.debtPartial,
                                }),
                              ),
                            )
                            .toList(),
                        onChanged: (v) {
                          if (v != null) vm.status = v;
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),

                  // Notes
                  _FormSection(
                    children: [
                      _AppTextField(
                        controller: _noteCtrl,
                        label: l10n.note,
                        hint: l10n.additionalNotesHint,
                        maxLines: 4,
                        onChanged: (v) => vm.note = v,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),

                  if (vm.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                          localizeKey(l10n, vm.errorMessage),
                        style: AppTextStyles.footnote
                            .copyWith(color: AppColors.danger),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  PrimaryButton(
                    label: widget.initialDebt == null ? l10n.save : l10n.update,
                    isLoading: vm.isLoading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        vm.submit();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ───────────────────────────────────── helpers

class _FormSection extends StatelessWidget {
  final List<Widget> children;
  const _FormSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadii.card),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 2),
      child: Text(
        text,
        style: AppTextStyles.caption1
            .copyWith(color: AppColors.textSecondary),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 0.5, indent: 0, endIndent: 0);
  }
}

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final ValueChanged<String> onChanged;

  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
    this.inputFormatters,
    this.validator,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: onChanged,
      style: AppTextStyles.body,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: InputBorder.none,
        enabledBorder: InputBorder.none,
        focusedBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        focusedErrorBorder: InputBorder.none,
      ),
    );
  }
}

class _DatePickerRow extends StatelessWidget {
  final String label;
  final DateTime? value;
  final ValueChanged<DateTime?> onPicked;

  const _DatePickerRow({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final picked = await showDatePicker(
          context: context,
          initialDate: value ?? now.add(const Duration(days: 7)),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
        );
        if (picked != null) onPicked(picked);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: AppTextStyles.body,
            ),
            Text(
              value != null
                  ? '${value!.day}.${value!.month}.${value!.year}'
                  : l10n.selectDate,
              style: AppTextStyles.body.copyWith(
                color:
                    value != null ? AppColors.primary : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
