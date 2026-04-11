import '../core/base/base_viewmodel.dart';
import '../models/reminder_model.dart';
import '../services/repositories/reminder_repository.dart';

enum ReminderFilter { all, today, upcoming, overdue, completed }

class RemindersViewModel extends BaseViewModel {
  final ReminderRepository _repository;
  RemindersViewModel(this._repository);

  List<ReminderModel> _all = [];
  ReminderFilter _filter = ReminderFilter.all;

  ReminderFilter get filter => _filter;
  bool get isEmpty => _all.isEmpty;

  List<ReminderModel> get reminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return switch (_filter) {
      ReminderFilter.all => _all.where((r) => !r.isCompleted).toList(),
      ReminderFilter.today => _all
          .where((r) =>
              !r.isCompleted &&
              r.reminderDate.isAfter(today.subtract(const Duration(seconds: 1))) &&
              r.reminderDate.isBefore(todayEnd.add(const Duration(seconds: 1))))
          .toList(),
      ReminderFilter.upcoming => _all
          .where((r) =>
              !r.isCompleted && r.reminderDate.isAfter(todayEnd))
          .toList(),
      ReminderFilter.overdue => _all
          .where((r) => !r.isCompleted && r.reminderDate.isBefore(today))
          .toList(),
      ReminderFilter.completed => _all.where((r) => r.isCompleted).toList(),
    };
  }

  Future<void> load() async {
    setLoading(true);
    clearError();
    final result = await _repository.getAll();
    result.fold(
      onSuccess: (data) => _all = data,
      onFailure: (e) => setError(e),
    );
    setLoading(false);
  }

  Future<void> refresh() => load();

  void setFilter(ReminderFilter f) {
    _filter = f;
    safeNotify();
  }

  Future<bool> toggleComplete(ReminderModel reminder) async {
    final updated = reminder.copyWith(isCompleted: !reminder.isCompleted, updatedAt: DateTime.now());
    final result = await _repository.update(updated);
    if (result.isSuccess) {
      final idx = _all.indexWhere((r) => r.id == reminder.id);
      if (idx >= 0) _all[idx] = updated;
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }

  Future<bool> delete(String id) async {
    final result = await _repository.delete(id);
    if (result.isSuccess) {
      _all.removeWhere((r) => r.id == id);
      safeNotify();
      return true;
    }
    setError(result.error);
    return false;
  }
}
