import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../models/lead_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/lead_form_viewmodel.dart';
import '../widgets/primary_button.dart';

class LeadFormView extends StatefulWidget {
  final LeadModel? initialLead;

  const LeadFormView({super.key, this.initialLead});

  @override
  State<LeadFormView> createState() => _LeadFormViewState();
}

class _LeadFormViewState extends State<LeadFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  late final TextEditingController _valueCtrl;
  late final TextEditingController _noteCtrl;

  @override
  void initState() {
    super.initState();
    final l = widget.initialLead;
    _nameCtrl = TextEditingController(text: l?.name ?? '');
    _valueCtrl = TextEditingController(
        text: l?.estimatedBudget != null
            ? l!.estimatedBudget!.toStringAsFixed(2)
            : '');
    _noteCtrl = TextEditingController(text: l?.note ?? '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialLead != null) {
        context.read<LeadFormViewModel>().loadForEdit(widget.initialLead!);
      }
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _valueCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LeadFormViewModel>(
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
              widget.initialLead == null ? 'Yeni Aday' : 'Adayı Düzenle',
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
                  // Name
                  _FormSection(children: [
                    _AppTextField(
                      controller: _nameCtrl,
                      label: 'Ad Soyad',
                      hint: 'ör. Ahmet Yılmaz',
                      validator: (_) => vm.validateName(),
                      onChanged: (v) => vm.name = v,
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Stage + source
                  _FormSection(children: [
                    _Label('Aşama'),
                    DropdownButton<LeadStage>(
                      value: vm.stage,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: LeadStage.values
                          .map((s) => DropdownMenuItem(
                              value: s, child: Text(s.label)))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) {
                          vm.stage = v;
                          setState(() {});
                        }
                      },
                    ),
                    _Divider(),
                    _Label('Kaynak'),
                    DropdownButton<String>(
                      value: vm.source.isEmpty ? null : vm.source,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      hint: Text('Kaynak seç',
                          style: AppTextStyles.body
                              .copyWith(color: AppColors.textTertiary)),
                      items: [
                        const DropdownMenuItem(
                            value: '', child: Text('— Belirtilmemiş —')),
                        ...AppConstants.leadSources.map((s) =>
                            DropdownMenuItem(value: s, child: Text(s))),
                      ],
                      onChanged: (v) {
                        vm.source = v ?? '';
                        setState(() {});
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Estimated budget
                  _FormSection(children: [
                    Row(children: [
                      Expanded(
                        child: _AppTextField(
                          controller: _valueCtrl,
                          label: 'Tahmini Bütçe',
                          hint: '0.00',
                          keyboardType: const TextInputType.numberWithOptions(
                              decimal: true),
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}')),
                          ],
                          onChanged: (v) => vm.estimatedBudget = v,
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
                    _Divider(),
                    _DatePickerRow(
                      label: 'Takip Tarihi',
                      value: vm.nextFollowUpDate,
                      onPicked: (d) {
                        vm.nextFollowUpDate = d;
                        setState(() {});
                      },
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Notes
                  _FormSection(children: [
                    _AppTextField(
                      controller: _noteCtrl,
                      label: 'Not',
                      hint: 'Görüşme notları...',
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
                    label: widget.initialLead == null ? 'Kaydet' : 'Güncelle',
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
  final DateTime? value;
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
        final now = DateTime.now();
        final d = await showDatePicker(
          context: context,
          initialDate: value ?? now.add(const Duration(days: 7)),
          firstDate: DateTime(2020),
          lastDate: DateTime(2030),
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
              value != null
                  ? '${value!.day}.${value!.month}.${value!.year}'
                  : 'Seç',
              style: AppTextStyles.body.copyWith(
                color: value != null
                    ? AppColors.primary
                    : AppColors.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
