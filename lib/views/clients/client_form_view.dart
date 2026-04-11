import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
        title: Text(widget.editClient != null ? 'Edit Client' : 'Add Client'),
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
                    decoration: const InputDecoration(labelText: 'Full Name *'),
                    validator: Validators.required,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _companyCtrl,
                    decoration: const InputDecoration(labelText: 'Company Name'),
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _emailCtrl,
                    decoration: const InputDecoration(labelText: 'Email'),
                    keyboardType: TextInputType.emailAddress,
                    validator: Validators.email,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _phoneCtrl,
                    decoration: const InputDecoration(labelText: 'Phone'),
                    keyboardType: TextInputType.phone,
                    validator: Validators.phone,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  // Status selector
                  DropdownButtonFormField<ClientStatus>(
                    value: vm.status,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: ClientStatus.values.map((s) => DropdownMenuItem(
                      value: s,
                      child: Text(_statusLabel(s)),
                    )).toList(),
                    onChanged: (s) => vm.status = s ?? ClientStatus.active,
                  ),
                  const SizedBox(height: AppSpacing.formFieldSpacing),
                  TextFormField(
                    controller: _notesCtrl,
                    decoration: const InputDecoration(labelText: 'Notes'),
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
                        : Text(widget.editClient != null ? 'Save Changes' : 'Add Client'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _statusLabel(ClientStatus s) => switch (s) {
        ClientStatus.active => 'Active',
        ClientStatus.inactive => 'Inactive',
        ClientStatus.archived => 'Archived',
      };
}
