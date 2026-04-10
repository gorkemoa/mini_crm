import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/utils/l10n_utils.dart';
import '../../l10n/app_localizations.dart';
import '../../models/client_model.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../themes/app_text_styles.dart';
import '../../viewmodels/client_form_viewmodel.dart';
import '../widgets/primary_button.dart';

class ClientFormView extends StatefulWidget {
  final ClientModel? editClient;
  const ClientFormView({super.key, this.editClient});

  @override
  State<ClientFormView> createState() => _ClientFormViewState();
}

class _ClientFormViewState extends State<ClientFormView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _companyCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final vm = context.read<ClientFormViewModel>();
    if (widget.editClient != null) {
      vm.loadForEdit(widget.editClient!);
    }
    _fullNameCtrl = TextEditingController(text: vm.fullName);
    _companyCtrl = TextEditingController(text: vm.companyName);
    _emailCtrl = TextEditingController(text: vm.email);
    _phoneCtrl = TextEditingController(text: vm.phone);
    _notesCtrl = TextEditingController(text: vm.notes);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _companyCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ClientFormViewModel>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        if (vm.saved) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) Navigator.pop(context);
          });
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            title: Text(vm.isEditMode ? l10n.editClient : l10n.newClient),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.screenPaddingH),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FormSection(
                      children: [
                        _AppTextField(
                          controller: _fullNameCtrl,
                          label: l10n.fullName,
                          hint: l10n.fullNameHint,
                          onChanged: (v) => vm.fullName = v,
                          validator: (_) => localizeKey(l10n, vm.validateFullName()),
                          textCapitalization: TextCapitalization.words,
                        ),
                        _AppTextField(
                          controller: _companyCtrl,
                          label: l10n.companyOptional,
                          hint: l10n.companyHint,
                          onChanged: (v) => vm.companyName = v,
                          textCapitalization: TextCapitalization.words,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.formSectionGap),
                    _FormSection(
                      children: [
                        _AppTextField(
                          controller: _emailCtrl,
                          label: l10n.emailOptional,
                          hint: l10n.emailHint,
                          onChanged: (v) => vm.email = v,
                          validator: (_) => localizeKey(l10n, vm.validateEmail()),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        _AppTextField(
                          controller: _phoneCtrl,
                          label: l10n.phoneOptional,
                          hint: l10n.phoneHint,
                          onChanged: (v) => vm.phone = v,
                          validator: (_) => localizeKey(l10n, vm.validatePhone()),
                          keyboardType: TextInputType.phone,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.formSectionGap),
                    _FormSection(
                      children: [
                        _StatusPicker(
                          value: vm.status,
                          onChanged: (s) {
                            vm.status = s;
                            setState(() {});
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.formSectionGap),
                    _FormSection(
                      children: [
                        _AppTextField(
                          controller: _notesCtrl,
                          label: l10n.notesOptional,
                          hint: l10n.notesHint,
                          onChanged: (v) => vm.notes = v,
                          maxLines: 3,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    if (vm.hasError)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          localizeKey(l10n, vm.errorMessage),
                          style: AppTextStyles.footnote.copyWith(
                            color: AppColors.danger,
                          ),
                        ),
                      ),
                    PrimaryButton(
                      label: vm.isEditMode ? l10n.update : l10n.save,
                      isLoading: vm.isLoading,
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          vm.submit();
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.lg),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _FormSection extends StatelessWidget {
  final List<Widget> children;
  const _FormSection({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: children.asMap().entries.map((e) {
          if (e.key < children.length - 1) {
            return Column(
              children: [
                e.value,
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  indent: AppSpacing.cardPadding,
                ),
              ],
            );
          }
          return e.value;
        }).toList(),
      ),
    );
  }
}

class _AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final ValueChanged<String> onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType keyboardType;
  final int maxLines;
  final TextCapitalization textCapitalization;

  const _AppTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.onChanged,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.maxLines = 1,
    this.textCapitalization = TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: 2,
      ),
      child: TextFormField(
        controller: controller,
        onChanged: onChanged,
        validator: validator,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          filled: false,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
        style: AppTextStyles.subheadline,
      ),
    );
  }
}

class _StatusPicker extends StatelessWidget {
  final ClientStatus value;
  final ValueChanged<ClientStatus> onChanged;

  const _StatusPicker({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.cardPadding,
        vertical: 12,
      ),
      child: Row(
        children: [
          Text(l10n.status, style: AppTextStyles.subheadline),
          const Spacer(),
          DropdownButton<ClientStatus>(
            value: value,
            underline: const SizedBox.shrink(),
            style: AppTextStyles.subheadline,
            items: ClientStatus.values
                .map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(switch (s) {
                        ClientStatus.active => l10n.statusActive,
                        ClientStatus.inactive => l10n.statusInactive,
                        ClientStatus.lost => l10n.statusLost,
                      }),
                    ))
                .toList(),
            onChanged: (s) {
              if (s != null) onChanged(s);
            },
          ),
        ],
      ),
    );
  }
}
