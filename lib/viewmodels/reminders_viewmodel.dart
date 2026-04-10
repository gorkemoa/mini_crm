import '../core/base/base_viewmodel.dart';
import '../models/reminder_model.dart';
import '../services/repositories/reminder_repository.dart';

enum ReminderFilter { all, today, upcoming, overdue, completed }

class RemindersViewModel extends BaseViewModel {
  final ReminderRepository _repo;

  RemindersViewModel({required ReminderRepository reminderRepository})
      : _repo = reminderRepository;

  List<ReminderModel> _all = [];
  List<ReminderModel> _filtered = [];
  ReminderFilter _filter = ReminderFilter.all;

  List<ReminderModel> get items => _filtered;
  ReminderFilter get filter => _filter;

  Future<void> load() async {
    setLoading(true);
    clearError();
    try {
      _all = await _repo.getAll();
      _applyFilter();
    } catch (e) {
      setError('Hatırlatıcılar yüklenemedi.');
    } finally {
      setLoading(false);
    }
  }

  Future<void> refresh() => load();

  void setFilter(ReminderFilter f) {
    _filter = f;
    _applyFilter();
  }

  void _applyFilter() {
    final now = DateTime.now();
    switch (_filter) {
      case ReminderFilter.all:
        _filtered = _all;
      case ReminderFilter.today:
        _filtered = _all.where((r) => r.isToday && !r.isCompleted).toList();
      case ReminderFilter.upcoming:
        _filtered = _all
            .where((r) =>
                !r.isCompleted &&
                r.reminderDate.isAfter(now) &&
                !r.isToday)
            .toList();
      case ReminderFilter.overdue:
        _filtered = _all.where((r) => r.isOverdue).toList();
      case ReminderFilter.completed:
        _filtered = _all.where((r) => r.isCompleted).toList();
    }
    notifyListeners();
  }

  Future<void> toggleComplete(ReminderModel reminder) async {
    try {
      if (!reminder.isCompleted) {
        await _repo.markComplete(reminder.id);
        final idx = _all.indexWhere((r) => r.id == reminder.id);
        if (idx >= 0) {
          _all[idx] = reminder.copyWith(isCompleted: true);
        }
      } else {
        final updated = reminder.copyWith(isCompleted: false);
        await _repo.update(updated);
        final idx = _all.indexWhere((r) => r.id == reminder.id);
        if (idx >= 0) _all[idx] = updated;
      }
      _applyFilter();
    } catch (e) {
      setError('Durum güncellenemedi.');
    }
  }

  Future<void> delete(String id) async {
    try {
      await _repo.delete(id);
      _all.removeWhere((r) => r.id == id);
      _applyFilter();
    } catch (e) {
      setError('Hatırlatıcı silinemedi.');
    }
  }

  Future<void> addReminder({
    required String title,
    required DateTime date,
    String? note,
    ReminderRelatedType type = ReminderRelatedType.general,
    String? relatedId,
  }) async {
    try {
      final now = DateTime.now();
      final reminder = ReminderModel(
        id: '',
        title: title.trim(),
        relatedType: type,
        relatedId: relatedId,
        reminderDate: date,
        isCompleted: false,
        note: note?.trim().isEmpty ?? true ? null : note?.trim(),
        createdAt: now,
        updatedAt: now,
      );
      final created = await _repo.create(reminder);
      _all.insert(0, created);
      _applyFilter();
    } catch (e) {
      setError('Hatırlatıcı eklenemedi.');
    }
  }
}
