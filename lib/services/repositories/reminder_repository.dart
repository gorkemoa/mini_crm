import 'package:sqflite/sqflite.dart';

import '../../core/base/result.dart';
import '../../models/reminder_model.dart';
import '../database/local_database_service.dart';

class ReminderRepository {
  final LocalDatabaseService _db;
  ReminderRepository(this._db);

  Future<Result<List<ReminderModel>>> getAll({bool? completed}) async {
    try {
      final db = await _db.database;
      final maps = await db.query(
        'reminders',
        where: completed != null ? 'is_completed = ?' : null,
        whereArgs: completed != null ? [completed ? 1 : 0] : null,
        orderBy: 'reminder_date ASC',
      );
      return Result.success(maps.map(ReminderModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ReminderModel?>> getById(String id) async {
    try {
      final db = await _db.database;
      final maps = await db.query('reminders', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.success(null);
      return Result.success(ReminderModel.fromMap(maps.first));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ReminderModel>> create(ReminderModel reminder) async {
    try {
      final db = await _db.database;
      await db.insert('reminders', reminder.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
      return Result.success(reminder);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ReminderModel>> update(ReminderModel reminder) async {
    try {
      final db = await _db.database;
      await db.update('reminders', reminder.toMap(), where: 'id = ?', whereArgs: [reminder.id]);
      return Result.success(reminder);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final db = await _db.database;
      await db.delete('reminders', where: 'id = ?', whereArgs: [id]);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<ReminderModel>>> getTodayReminders() async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final maps = await db.query(
        'reminders',
        where: 'reminder_date >= ? AND reminder_date <= ? AND is_completed = 0',
        whereArgs: [start.toIso8601String(), end.toIso8601String()],
        orderBy: 'reminder_date ASC',
      );
      return Result.success(maps.map(ReminderModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<int>> getTodayCount() async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, now.day);
      final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
      final result = await db.rawQuery(
        'SELECT COUNT(*) as count FROM reminders WHERE reminder_date >= ? AND reminder_date <= ? AND is_completed = 0',
        [start.toIso8601String(), end.toIso8601String()],
      );
      return Result.success(Sqflite.firstIntValue(result) ?? 0);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> insertAll(List<ReminderModel> reminders) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      for (final r in reminders) {
        batch.insert('reminders', r.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
      }
      await batch.commit(noResult: true);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> deleteAll() async {
    try {
      final db = await _db.database;
      await db.delete('reminders');
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
