import 'package:sqflite/sqflite.dart';
import '../../models/client_model.dart';
import '../../core/utils/id_utils.dart';
import '../database/local_database_service.dart';

class ClientRepository {
  final LocalDatabaseService _dbService;

  ClientRepository(this._dbService);

  Database get _db => _dbService.db;

  Future<List<ClientModel>> getAll() async {
    final rows = await _db.query(
      'clients',
      orderBy: 'full_name ASC',
    );
    return rows.map(ClientModel.fromMap).toList();
  }

  Future<ClientModel?> getById(String id) async {
    final rows = await _db.query(
      'clients',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return ClientModel.fromMap(rows.first);
  }

  Future<List<ClientModel>> search(String query) async {
    final q = '%${query.toLowerCase()}%';
    final rows = await _db.query(
      'clients',
      where: 'LOWER(full_name) LIKE ? OR LOWER(company_name) LIKE ?',
      whereArgs: [q, q],
      orderBy: 'full_name ASC',
    );
    return rows.map(ClientModel.fromMap).toList();
  }

  Future<List<ClientModel>> getByStatus(ClientStatus status) async {
    final rows = await _db.query(
      'clients',
      where: 'status = ?',
      whereArgs: [status.name],
      orderBy: 'full_name ASC',
    );
    return rows.map(ClientModel.fromMap).toList();
  }

  Future<ClientModel> create(ClientModel client) async {
    final now = DateTime.now();
    final model = client.copyWith(
      id: IdUtils.generate(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('clients', model.toMap());
    return model;
  }

  Future<ClientModel> update(ClientModel client) async {
    final model = client.copyWith(updatedAt: DateTime.now());
    await _db.update(
      'clients',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  Future<void> delete(String id) async {
    await _db.delete('clients', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> count() async {
    final result = await _db.rawQuery('SELECT COUNT(*) as count FROM clients');
    return (result.first['count'] as int?) ?? 0;
  }
}
