import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/income_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/income_form_viewmodel.dart';
import '../widgets/primary_button.dart';

class IncomeFormView extends StatefulWidget {
  final IncomeModel? initialIncome;

  const IncomeFormView({super.key, this.initialIncome});

  @override
  State<IncomeFormView> createState() => _IncomeFormViewState();
}

class _IncomeFormViewState extends State<IncomeFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    final inc = widget.initialIncome;
    _amountCtrl = TextEditingController(
        text: inc != null ? inc.amount.toStringAsFixed(2) : '');
    _noteCtrl = TextEditingController(text: inc?.note ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<IncomeFormViewModel>().init(editIncome: inc);
    });
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IncomeFormViewModel>(
      builder: (context, vm, _) {
        if (vm.saved) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (context.mounted) Navigator.pop(context, true);
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(
              widget.initialIncome == null ? 'Yeni Gelir' : 'Geliri Düzenle',
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
                  _FormSection(children: [
                    _Label('Müşteri'),
                    DropdownButton<String?>(
                      value: vm.selectedClientId,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      hint: Text('Müşteri seç (isteğe bağlı)',
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.textTertiary)),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('— Müşterisiz —')),
                        ...vm.clients.map((c) => DropdownMenuItem(
                            value: c.id, child: Text(c.displayName))),
                      ],
                      onChanged: (v) => vm.selectedClientId = v,
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Amount + currency
                  _FormSection(children: [
                    Row(children: [
                      Expanded(
                        child: _AppTextField(
                          controller: _amountCtrl,
                          label: 'Tutar',
                          hint: '0.00',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          validator: (_) => vm.validateAmount(),
                          onChanged: (v) => vm.amount = v,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      DropdownButton<String>(
                        value: vm.currency,
                        underline: const SizedBox.shrink(),
                        items: AppConstants.currencies
                            .map((c) =>
                                DropdownMenuItem(value: c, child: Text(c)))
                            .toList(),
                        onChanged: (v) {
                          if (v != null) {
                            vm.currency = v;
                            setState(() {});
                          }
                        },
                      ),
                    ]),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Platform + date
                  _FormSection(children: [
                    _Label('Platform'),
                    DropdownButton<String?>(
                      value: vm.sourcePlatform.isEmpty ? null : vm.sourcePlatform,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      hint: Text('Platform seç',
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.textTertiary)),
                      items: [
                        const DropdownMenuItem(
                            value: null, child: Text('— Belirtilmemiş —')),
                        ...AppConstants.leadSources.map((s) =>
                            DropdownMenuItem(value: s, child: Text(s))),
                      ],
                      onChanged: (v) {
                        vm.sourcePlatform = v ?? '';
                        setState(() {});
                      },
                    ),
                    _Divider(),
                    _DatePickerRow(
                      label: 'Alınma Tarihi',
                      value: vm.date,
                      onPicked: (d) {
                        if (d != null) {
                          vm.date = d;
                          setState(() {});
                        }
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Notes
                  _FormSection(children: [
                    _AppTextField(
                      controller: _noteCtrl,
                      label: 'Not',
                      hint: 'Ek notlar...',
                      maxLines: 4,
                      onChanged: (v) => vm.note = v,
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.lg),

                  if (vm.hasError)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        vm.errorMessage!,
                        style: AppTextStyles.footnote
                            .copyWith(color: AppColors.danger),
                        textAlign: TextAlign.center,
                      ),
                    ),

                  PrimaryButton(
                    label: widget.initialIncome == null ? 'Kaydet' : 'Güncelle',
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

// ── helpers ──

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
          horizontal: AppSpacing.cardPadding, vertical: 4),
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
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
      child: Text(text,
          style: AppTextStyles.caption1
              .copyWith(color: AppColors.textSecondary)),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 0.5);
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
  final DateTime value;
  final ValueChanged<DateTime?> onPicked;

  const _DatePickerRow({
    required this.label,
    required this.value,
    required this.onPicked,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final d = await showDatePicker(
          context: context,
          initialDate: value,
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
          locale: const Locale('tr', 'TR'),
        );
        if (d != null) onPicked(d);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: AppTextStyles.body),
            Text(
              '${value.day}.${value.month}.${value.year}',
              style: AppTextStyles.body.copyWith(color: AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}
