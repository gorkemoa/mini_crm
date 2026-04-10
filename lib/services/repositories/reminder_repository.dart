import 'package:sqflite/sqflite.dart';
import '../../models/reminder_model.dart';
import '../../core/utils/id_utils.dart';
import '../database/local_database_service.dart';

class ReminderRepository {
  final LocalDatabaseService _dbService;

  ReminderRepository(this._dbService);

  Database get _db => _dbService.db;

  Future<List<ReminderModel>> getAll() async {
    final rows = await _db.query(
      'reminders',
      orderBy: 'reminder_date ASC',
    );
    return rows.map(ReminderModel.fromMap).toList();
  }

  Future<ReminderModel?> getById(String id) async {
    final rows = await _db.query(
      'reminders',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ReminderModel.fromMap(rows.first);
  }

  Future<List<ReminderModel>> getToday() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).toIso8601String();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();
    final rows = await _db.rawQuery(
      'SELECT * FROM reminders WHERE reminder_date >= ? AND reminder_date <= ? AND is_completed = 0 ORDER BY reminder_date ASC',
      [todayStart, todayEnd],
    );
    return rows.map(ReminderModel.fromMap).toList();
  }

  Future<List<ReminderModel>> getPending() async {
    final rows = await _db.query(
      'reminders',
      where: 'is_completed = ?',
      whereArgs: [0],
      orderBy: 'reminder_date ASC',
    );
    return rows.map(ReminderModel.fromMap).toList();
  }

  Future<int> countToday() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day).toIso8601String();
    final todayEnd = DateTime(now.year, now.month, now.day, 23, 59, 59).toIso8601String();
    final result = await _db.rawQuery(
      'SELECT COUNT(*) as count FROM reminders WHERE reminder_date >= ? AND reminder_date <= ? AND is_completed = 0',
      [todayStart, todayEnd],
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<ReminderModel> create(ReminderModel reminder) async {
    final now = DateTime.now();
    final model = reminder.copyWith(
      id: IdUtils.generate(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('reminders', model.toMap());
    return model;
  }

  Future<ReminderModel> update(ReminderModel reminder) async {
    final model = reminder.copyWith(updatedAt: DateTime.now());
    await _db.update(
      'reminders',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  Future<void> markComplete(String id) async {
    await _db.update(
      'reminders',
      {
        'is_completed': 1,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(String id) async {
    await _db.delete('reminders', where: 'id = ?', whereArgs: [id]);
  }
}
