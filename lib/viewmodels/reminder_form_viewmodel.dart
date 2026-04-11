import 'package:flutter/material.dart';

import '../core/base/base_viewmodel.dart';
import '../core/utils/id_utils.dart';
import '../models/reminder_model.dart';
import '../models/enums.dart';
import '../services/repositories/reminder_repository.dart';

class ReminderFormViewModel extends BaseViewModel {
  final ReminderRepository _repository;
  ReminderFormViewModel(this._repository);

  bool get isEditMode => _editId != null;
  String? _editId;

  String title = '';
  DateTime reminderDate = DateTime.now().add(const Duration(hours: 1));
  TimeOfDay reminderTime = TimeOfDay.now();
  ReminderRelatedType? relatedType;
  String? relatedId;
  String note = '';

  void loadForEdit(ReminderModel reminder) {
    _editId = reminder.id;
    title = reminder.title;
    reminderDate = reminder.reminderDate;
    reminderTime = TimeOfDay.fromDateTime(reminder.reminderDate);
    relatedType = reminder.relatedType;
    relatedId = reminder.relatedId;
    note = reminder.note ?? '';
    safeNotify();
  }

  Future<bool> submit() async {
    setLoading(true);
    clearError();

    final dateTime = DateTime(
      reminderDate.year,
      reminderDate.month,
      reminderDate.day,
      reminderTime.hour,
      reminderTime.minute,
    );

    final now = DateTime.now();
    final reminder = ReminderModel(
      id: _editId ?? IdUtils.generate(),
      title: title.trim(),
      reminderDate: dateTime,
      relatedType: relatedType,
      relatedId: relatedId,
      note: note.trim().isEmpty ? null : note.trim(),
      createdAt: now,
      updatedAt: now,
    );

    final result = isEditMode ? await _repository.update(reminder) : await _repository.create(reminder);
    setLoading(false);
    if (result.isFailure) {
      setError(result.error);
      return false;
    }
    return true;
  }
}
