import 'package:sqflite/sqflite.dart';

import '../../core/base/result.dart';
import '../../models/client_model.dart';
import '../../models/enums.dart';
import '../database/local_database_service.dart';

class ClientRepository {
  final LocalDatabaseService _db;
  ClientRepository(this._db);

  Future<Result<List<ClientModel>>> getAll({ClientStatus? status}) async {
    try {
      final db = await _db.database;
      final maps = await db.query(
        'clients',
        where: status != null ? 'status = ?' : null,
        whereArgs: status != null ? [status.name] : null,
        orderBy: 'full_name ASC',
      );
      return Result.success(maps.map(ClientModel.fromMap).toList());
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ClientModel?>> getById(String id) async {
    try {
      final db = await _db.database;
      final maps = await db.query('clients', where: 'id = ?', whereArgs: [id]);
      if (maps.isEmpty) return Result.success(null);
      return Result.success(ClientModel.fromMap(maps.first));
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ClientModel>> create(ClientModel client) async {
    try {
      final db = await _db.database;
      await db.insert('clients', client.toMap(), conflictAlgorithm: ConflictAlgorithm.fail);
      return Result.success(client);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<ClientModel>> update(ClientModel client) async {
    try {
      final db = await _db.database;
      await db.update('clients', client.toMap(), where: 'id = ?', whereArgs: [client.id]);
      return Result.success(client);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> delete(String id) async {
    try {
      final db = await _db.database;
      await db.delete('clients', where: 'id = ?', whereArgs: [id]);
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<int>> getCount() async {
    try {
      final db = await _db.database;
      final result = await db.rawQuery(
          'SELECT COUNT(*) as count FROM clients WHERE status = ?', ['active']);
      return Result.success(Sqflite.firstIntValue(result) ?? 0);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }

  Future<Result<void>> insertAll(List<ClientModel> clients) async {
    try {
      final db = await _db.database;
      final batch = db.batch();
      for (final c in clients) {
        batch.insert('clients', c.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
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
      await db.delete('clients');
      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
