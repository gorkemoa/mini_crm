import 'package:sqflite/sqflite.dart';

import '../../core/base/result.dart';
import '../../models/project_model.dart';
import '../../models/enums.dart';
import '../database/local_database_service.dart';

class ProjectRepository {
  final LocalDatabaseService _db;
  ProjectRepository(this._db);

  Future<Result<List<ProjectModel>>> getAll({ProjectStatus? status, String? clientId}) async {
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
        'projects',
        where: conditions.isEmpty ? null : conditions.join(' AND '),
        whereArgs: args.isEmpty ? null : args,
        orderBy: 'start_date ASC, created_at DESC',
      );
      return Result.success(maps.map(ProjectModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ProjectModel?>> getById(String id) async {
    try {
      final db = await _db.database;
      final maps = await db.query('projects', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.success(null);
      return Result.success(ProjectModel.fromMap(maps.first));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ProjectModel>> create(ProjectModel project) async {
    try {
      final db = await _db.database;
      await db.insert('projects', project.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
      return Result.success(project);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ProjectModel>> update(ProjectModel project) async {
    try {
      final db = await _db.database;
      await db.update('projects', project.toMap(), where: 'id = ?', whereArgs: [project.id]);
      return Result.success(project);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final db = await _db.database;
      await db.delete('projects', where: 'id = ?', whereArgs: [id]);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<List<ProjectModel>>> getStartingThisWeek() async {
    try {
      final db = await _db.database;
      final now = DateTime.now();
      final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
      final endOfWeek = startOfWeek.add(const Duration(days: 6));
      final maps = await db.query(
        'projects',
        where: "start_date >= ? AND start_date <= ? AND status IN ('planned','startingSoon')",
        whereArgs: [startOfWeek.toIso8601String(), endOfWeek.toIso8601String()],
      );
      return Result.success(maps.map(ProjectModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<int>> getActiveCount() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(
        "SELECT COUNT(*) as count FROM projects WHERE status = 'active'",
      );
      return Result.success(Sqflite.firstIntValue(result) ?? 0);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> insertAll(List<ProjectModel> projects) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      for (final p in projects) {
        batch.insert('projects', p.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
      await db.delete('projects');
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
