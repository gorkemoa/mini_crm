import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_constants.dart';
import '../../core/utils/l10n_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../models/project_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_radii.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/project_form_viewmodel.dart';
import '../widgets/primary_button.dart';

class ProjectFormView extends StatefulWidget {
  final ProjectModel? initialProject;
  final String? initialClientId;

  const ProjectFormView({
    super.key,
    this.initialProject,
    this.initialClientId,
  });

  @override
  State<ProjectFormView> createState() => _ProjectFormViewState();
}

class _ProjectFormViewState extends State<ProjectFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleCtrl;
  late final TextEditingController _descCtrl;
  late final TextEditingController _budgetCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.initialProject;
    _titleCtrl = TextEditingController(text: p?.title ?? '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _budgetCtrl = TextEditingController(
        text: p?.budget != null ? p!.budget!.toStringAsFixed(2) : '');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectFormViewModel>().init(
            editProject: p,
            preselectedClientId: widget.initialClientId,
          );
    });
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _descCtrl.dispose();
    _budgetCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProjectFormViewModel>(
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
              widget.initialProject == null ? l10n.newProject : l10n.editProject,
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
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Title + description
                  _FormSection(children: [
                    _AppTextField(
                      controller: _titleCtrl,
                      label: l10n.projectName,
                      hint: l10n.projectNameHint,
                      validator: (_) => localizeValidator(l10n, vm.validateTitle()),
                      onChanged: (v) => vm.title = v,
                    ),
                    _Divider(),
                    _AppTextField(
                      controller: _descCtrl,
                      label: l10n.description,
                      hint: l10n.projectDetails,
                      maxLines: 3,
                      onChanged: (v) => vm.description = v,
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Budget + currency
                  _FormSection(children: [
                    Row(
                      children: [
                        Expanded(
                          child: _AppTextField(
                            controller: _budgetCtrl,
                            label: l10n.budget,
                            hint: l10n.amountHint,
                            keyboardType:
                                const TextInputType.numberWithOptions(
                                    decimal: true),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                            onChanged: (v) => vm.budget = v,
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
                            if (v != null) vm.currency = v;
                          },
                        ),
                      ],
                    ),
                  ]),
                  const SizedBox(height: AppSpacing.md),

                  // Dates + status
                  _FormSection(children: [
                    _DatePickerRow(
                      label: l10n.startDate,
                      value: vm.startDate,
                      onPicked: (d) => vm.startDate = d,
                    ),
                    _Divider(),
                    _DatePickerRow(
                      label: l10n.endDate,
                      value: vm.endDate,
                      onPicked: (d) => vm.endDate = d,
                    ),
                    _Divider(),
                    _Label(l10n.status),
                    DropdownButton<ProjectStatus>(
                      value: vm.status,
                      isExpanded: true,
                      underline: const SizedBox.shrink(),
                      items: ProjectStatus.values
                          .map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(switch (s) {
                                  ProjectStatus.planned => l10n.projectPlanned,
                                  ProjectStatus.startingSoon => l10n.projectStartingSoon,
                                  ProjectStatus.active => l10n.projectActive,
                                  ProjectStatus.paused => l10n.projectPaused,
                                  ProjectStatus.completed => l10n.projectCompleted,
                                  ProjectStatus.cancelled => l10n.projectCancelled,
                                }),
                              ))
                          .toList(),
                      onChanged: (v) {
                        if (v != null) vm.status = v;
                      },
                    ),
                  ]),
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
                    label: widget.initialProject == null
                        ? l10n.save
                        : l10n.update,
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

// ── helpers ──────────────────────────────────────────────────────────────────

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
    final l10n = AppLocalizations.of(context)!;
    return GestureDetector(
      onTap: () async {
        final now = DateTime.now();
        final d = await showDatePicker(
          context: context,
          initialDate: value ?? now,
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
