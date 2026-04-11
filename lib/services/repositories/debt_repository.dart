import 'package:sqflite/sqflite.dart';

import '../../core/base/result.dart';
import '../../models/debt_model.dart';
import '../../models/enums.dart';
import '../database/local_database_service.dart';

class DebtRepository {
  final LocalDatabaseService _db;
  DebtRepository(this._db);

  Future<Result<List<DebtModel>>> getAll({DebtStatus? status, String? clientId}) async {
    try {
      final db = await _db.database;
      final conditions = <String>[];
      final args = <dynamic>[];
      if (status != null) {
        conditions.add('status = ?');
        args.add(status.name);
      }
      if (clientId != null) {
        conditions.add('client_id = ?');
        args.add(clientId);
      }
      final maps = await db.query(
        'debts',
        where: conditions.isEmpty ? null : conditions.join(' AND '),
        whereArgs: args.isEmpty ? null : args,
        orderBy: 'due_date ASC, created_at DESC',
      );
      return Result.success(maps.map(DebtModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DebtModel?>> getById(String id) async {
    try {
      final db = await _db.database;
      final maps = await db.query('debts', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.success(null);
      return Result.success(DebtModel.fromMap(maps.first));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DebtModel>> create(DebtModel debt) async {
    try {
      final db = await _db.database;
      await db.insert('debts', debt.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
      return Result.success(debt);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<DebtModel>> update(DebtModel debt) async {
    try {
      final db = await _db.database;
      await db.update('debts', debt.toMap(), where: 'id = ?', whereArgs: [debt.id]);
      return Result.success(debt);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final db = await _db.database;
      await db.delete('debts', where: 'id = ?', whereArgs: [id]);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<Map<String, double>>> getTotalsByStatus() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(
        'SELECT status, SUM(amount) as total FROM debts GROUP BY status',
      );
      final totals = <String, double>{};
      for (final row in result) {
        totals[row['status'] as String] = (row['total'] as num?)?.toDouble() ?? 0;
      }
      return Result.success(totals);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<double>> getPendingTotal() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(
        "SELECT SUM(amount) as total FROM debts WHERE status IN ('pending','overdue')",
      );
      return Result.success((Sqflite.firstIntValue(result) ?? 0).toDouble());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> insertAll(List<DebtModel> debts) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      for (final d in debts) {
        batch.insert('debts', d.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
      await db.delete('debts');
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
