import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_localizations_ext.dart';
import '../../themes/app_colors.dart';
import '../../themes/app_spacing.dart';
import '../../viewmodels/client_form_viewmodel.dart';
import '../../models/client_model.dart';
import '../../models/enums.dart';
import '../../core/utils/validators.dart';

class ClientFormView extends StatefulWidget {
  final ClientModel? editClient;
  const ClientFormView({super.key, this.editClient});

  @override
  State<ClientFormView> createState() => _ClientFormViewState();
}

class _ClientFormViewState extends State<ClientFormView> {
  final _formKey = GlobalKey<FormState>();
  late final ClientFormViewModel _vm;

  final _nameCtrl = TextEditingController();
  final _companyCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _vm = context.read<ClientFormViewModel>();
    if (widget.editClient != null) {
      _vm.loadForEdit(widget.editClient!);
      _nameCtrl.text = _vm.fullName;
      _companyCtrl.text = _vm.companyName;
      _emailCtrl.text = _vm.email;
      _phoneCtrl.text = _vm.phone;
      _notesCtrl.text = _vm.notes;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _companyCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _vm.fullName = _nameCtrl.text;
    _vm.companyName = _companyCtrl.text;
    _vm.email = _emailCtrl.text;
    _vm.phone = _phoneCtrl.text;
    _vm.notes = _notesCtrl.text;
    final success = await _vm.submit();
    if (success && mounted) Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(widget.editClient != null ? context.l10n.clientEditTitle : context.l10n.clientAddTitle),
      ),
      body: Consumer<ClientFormViewModel>(
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
                    decoration: InputDecoration(labelText: '${context.l10n.clientFullName} *'),
                    validator: Validators.required,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _companyCtrl,
                    decoration: InputDecoration(labelText: context.l10n.clientCompanyName),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: InputDecoration(labelText: context.l10n.labelEmail),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: InputDecoration(labelText: context.l10n.labelPhone),
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  // Status selector
                  DropdownButtonFormField<ClientStatus>(
                    value: vm.status,
                    decoration: InputDecoration(labelText: context.l10n.labelStatus),
                    items: ClientStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_statusLabel(s, context)),
                    )).toList(),
                    onChanged: (s) => vm.status = s ?? ClientStatus.active,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _notesCtrl,
                    decoration: InputDecoration(labelText: context.l10n.labelNotes),
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  if (vm.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text(
                        vm.errorMessage!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ElevatedButton(
                    onPressed: vm.isLoading ? null : _submit,
                    child: vm.isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(widget.editClient != null ? context.l10n.actionSave : context.l10n.clientAddTitle),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(ClientStatus s, BuildContext context) => switch (s) {
        ClientStatus.active => context.l10n.clientStatusActive,
        ClientStatus.inactive => context.l10n.clientStatusInactive,
        ClientStatus.archived => context.l10n.clientStatusArchived,
      };
}
