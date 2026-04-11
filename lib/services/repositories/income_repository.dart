import 'package:sqflite/sqflite.dart';

import '../../core/base/result.dart';
import '../../models/income_model.dart';
import '../database/local_database_service.dart';

class IncomeRepository {
  final LocalDatabaseService _db;
  IncomeRepository(this._db);

  Future<Result<List<IncomeModel>>> getAll({String? clientId}) async {
    try {
      final db = await _db.database;
      final maps = await db.query(
        'incomes',
        where: clientId != null ? 'client_id = ?' : null,
        whereArgs: clientId != null ? [clientId] : null,
        orderBy: 'date DESC',
      );
      return Result.success(maps.map(IncomeModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<IncomeModel?>> getById(String id) async {
    try {
      final db = await _db.database;
      final maps = await db.query('incomes', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.success(null);
      return Result.success(IncomeModel.fromMap(maps.first));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<IncomeModel>> create(IncomeModel income) async {
    try {
      final db = await _db.database;
      await db.insert('incomes', income.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
      return Result.success(income);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<IncomeModel>> update(IncomeModel income) async {
    try {
      final db = await _db.database;
      await db.update('incomes', income.toMap(), where: 'id = ?', whereArgs: [income.id]);
      return Result.success(income);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final db = await _db.database;
      await db.delete('incomes', where: 'id = ?', whereArgs: [id]);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<double>> getMonthlyTotal() async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final start = DateTime(now.year, now.month, 1);
      final end = DateTime(now.year, now.month + 1, 0);
      final result = await db.rawQuery(
        'SELECT SUM(amount) as total FROM incomes WHERE date >= ? AND date <= ?',
        [start.toIso8601String(), end.toIso8601String()],
      );
      final raw = result.first['total'];
      return Result.success(raw != null ? (raw as num).toDouble() : 0.0);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> insertAll(List<IncomeModel> incomes) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      for (final i in incomes) {
        batch.insert('incomes', i.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
      await db.delete('incomes');
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
