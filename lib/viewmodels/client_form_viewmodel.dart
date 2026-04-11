import '../core/base/base_viewmodel.dart';
import '../core/utils/id_utils.dart';
import '../models/client_model.dart';
import '../models/enums.dart';
import '../services/repositories/client_repository.dart';

class ClientFormViewModel extends BaseViewModel {
  final ClientRepository _repository;
  ClientFormViewModel(this._repository);

  bool get isEditMode => _editId != null;
  String? _editId;

  String fullName = '';
  String companyName = '';
  String email = '';
  String phone = '';
  String notes = '';
  ClientStatus status = ClientStatus.active;

  void loadForEdit(ClientModel client) {
    _editId = client.id;
    fullName = client.fullName;
    companyName = client.companyName ?? '';
    email = client.email ?? '';
    phone = client.phone ?? '';
    notes = client.notes ?? '';
    status = client.status;
    safeNotify();
  }

  Future<bool> submit() async {
    setLoading(true);
    clearError();

    final now = DateTime.now();
    final client = ClientModel(
      id: _editId ?? IdUtils.generate(),
      fullName: fullName.trim(),
      companyName: companyName.trim().isEmpty ? null : companyName.trim(),
      email: email.trim().isEmpty ? null : email.trim(),
      phone: phone.trim().isEmpty ? null : phone.trim(),
      notes: notes.trim().isEmpty ? null : notes.trim(),
      status: status,
      createdAt: isEditMode ? now : now,
      updatedAt: now,
    );

    final result = isEditMode
        ? await _repository.update(client)
        : await _repository.create(client);

    setLoading(false);
    if (result.isFailure) {
      setError(result.error);
      return false;
    }
    return true;
  }
}
