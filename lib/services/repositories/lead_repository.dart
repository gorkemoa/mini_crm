import 'package:sqflite/sqflite.dart';

import '../../core/base/result.dart';
import '../../models/lead_model.dart';
import '../../models/enums.dart';
import '../database/local_database_service.dart';

class LeadRepository {
  final LocalDatabaseService _db;
  LeadRepository(this._db);

  Future<Result<List<LeadModel>>> getAll({LeadStage? stage}) async {
    try {
      final db = await _db.database;
      final maps = await db.query(
        'leads',
        where: stage != null ? 'stage = ?' : null,
        whereArgs: stage != null ? [stage.name] : null,
        orderBy: 'next_follow_up_date ASC, created_at DESC',
      );
      return Result.success(maps.map(LeadModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<LeadModel?>> getById(String id) async {
    try {
      final db = await _db.database;
      final maps = await db.query('leads', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.success(null);
      return Result.success(LeadModel.fromMap(maps.first));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<LeadModel>> create(LeadModel lead) async {
    try {
      final db = await _db.database;
      await db.insert('leads', lead.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
      return Result.success(lead);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<LeadModel>> update(LeadModel lead) async {
    try {
      final db = await _db.database;
      await db.update('leads', lead.toMap(), where: 'id = ?', whereArgs: [lead.id]);
      return Result.success(lead);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final db = await _db.database;
      await db.delete('leads', where: 'id = ?', whereArgs: [id]);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<int>> getFollowUpCount() async {
    try {
      final db = await _db.database;
      final now = DateTime.now().toIso8601String();
      final result = await db.rawQuery(
        "SELECT COUNT(*) as count FROM leads WHERE next_follow_up_date <= ? AND stage NOT IN ('won','lost')",
        [now],
      );
      return Result.success(Sqflite.firstIntValue(result) ?? 0);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> insertAll(List<LeadModel> leads) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      for (final l in leads) {
        batch.insert('leads', l.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
      await db.delete('leads');
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
