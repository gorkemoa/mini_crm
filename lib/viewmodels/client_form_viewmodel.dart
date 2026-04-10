import '../core/base/base_viewmodel.dart';
import '../core/utils/id_utils.dart';
import '../core/utils/validators.dart';
import '../models/client_model.dart';
import '../services/repositories/client_repository.dart';

class ClientFormViewModel extends BaseViewModel {
  final ClientRepository _repo;

  ClientFormViewModel({required ClientRepository clientRepository})
      : _repo = clientRepository;

  ClientModel? _editingClient;
  bool get isEditMode => _editingClient != null;

  String fullName = '';
  String companyName = '';
  String email = '';
  String phone = '';
  String notes = '';
  ClientStatus status = ClientStatus.active;

  bool _saved = false;
  bool get saved => _saved;

  void loadForEdit(ClientModel client) {
    _editingClient = client;
    fullName = client.fullName;
    companyName = client.companyName ?? '';
    email = client.email ?? '';
    phone = client.phone ?? '';
    notes = client.notes ?? '';
    status = client.status;
    notifyListeners();
  }

  String? validateFullName() => Validators.required(fullName, fieldName: 'Ad Soyad');
  String? validateEmail() => Validators.email(email.isEmpty ? null : email);
  String? validatePhone() => Validators.phone(phone.isEmpty ? null : phone);

  bool validate() {
    return validateFullName() == null &&
        validateEmail() == null &&
        validatePhone() == null;
  }

  Future<void> submit() async {
    if (!validate()) return;
    setLoading(true);
    clearError();
    try {
      final now = DateTime.now();
      final client = ClientModel(
        id: _editingClient?.id ?? IdUtils.generate(),
        fullName: fullName.trim(),
        companyName: companyName.trim().isEmpty ? null : companyName.trim(),
        email: email.trim().isEmpty ? null : email.trim(),
        phone: phone.trim().isEmpty ? null : phone.trim(),
        notes: notes.trim().isEmpty ? null : notes.trim(),
        status: status,
        createdAt: _editingClient?.createdAt ?? now,
        updatedAt: now,
      );
      if (isEditMode) {
        await _repo.update(client);
      } else {
        await _repo.create(client);
      }
      _saved = true;
      notifyListeners();
    } catch (e) {
      setError('errorClientSave');
    } finally {
      setLoading(false);
    }
  }
}
