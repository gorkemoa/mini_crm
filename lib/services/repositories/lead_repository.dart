import 'package:sqflite/sqflite.dart';
import '../../models/lead_model.dart';
import '../../core/utils/id_utils.dart';
import '../database/local_database_service.dart';

class LeadRepository {
  final LocalDatabaseService _dbService;

  LeadRepository(this._dbService);

  Database get _db => _dbService.db;

  Future<List<LeadModel>> getAll() async {
    final rows = await _db.query(
      'leads',
      orderBy: 'created_at DESC',
    );
    return rows.map(LeadModel.fromMap).toList();
  }

  Future<LeadModel?> getById(String id) async {
    final rows = await _db.query(
      'leads',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) return null;
    return LeadModel.fromMap(rows.first);
  }

  Future<List<LeadModel>> getByStage(LeadStage stage) async {
    final rows = await _db.query(
      'leads',
      where: 'stage = ?',
      whereArgs: [stage.name],
      orderBy: 'created_at DESC',
    );
    return rows.map(LeadModel.fromMap).toList();
  }

  Future<List<LeadModel>> getActive() async {
    final rows = await _db.rawQuery(
      "SELECT * FROM leads WHERE stage NOT IN ('won', 'lost') ORDER BY next_follow_up_date ASC",
    );
    return rows.map(LeadModel.fromMap).toList();
  }

  Future<int> countActive() async {
    final result = await _db.rawQuery(
      "SELECT COUNT(*) as count FROM leads WHERE stage NOT IN ('won', 'lost')",
    );
    return (result.first['count'] as int?) ?? 0;
  }

  Future<LeadModel> create(LeadModel lead) async {
    final now = DateTime.now();
    final model = lead.copyWith(
      id: IdUtils.generate(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('leads', model.toMap());
    return model;
  }

  Future<LeadModel> update(LeadModel lead) async {
    final model = lead.copyWith(updatedAt: DateTime.now());
    await _db.update(
      'leads',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  Future<void> delete(String id) async {
    await _db.delete('leads', where: 'id = ?', whereArgs: [id]);
  }
}
