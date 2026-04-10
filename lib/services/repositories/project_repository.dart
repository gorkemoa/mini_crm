import 'package:sqflite/sqflite.dart';
import '../../models/project_model.dart';
import '../../core/utils/id_utils.dart';
import '../database/local_database_service.dart';

class ProjectRepository {
  final LocalDatabaseService _dbService;

  ProjectRepository(this._dbService);

  Database get _db => _dbService.db;

  static const String _joinQuery = '''
    SELECT projects.*, clients.full_name as client_name
    FROM projects
    LEFT JOIN clients ON projects.client_id = clients.id
  ''';

  Future<List<ProjectModel>> getAll() async {
    final rows = await _db.rawQuery(
      '$_joinQuery ORDER BY projects.start_date ASC',
    );
    return rows.map((r) => ProjectModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<ProjectModel?> getById(String id) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE projects.id = ?',
      [id],
    );
    if (rows.isEmpty) return null;
    return ProjectModel.fromMap(rows.first, clientName: rows.first['client_name'] as String?);
  }

  Future<List<ProjectModel>> getByClientId(String clientId) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE projects.client_id = ? ORDER BY projects.created_at DESC',
      [clientId],
    );
    return rows.map((r) => ProjectModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<List<ProjectModel>> getByStatus(ProjectStatus status) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE projects.status = ? ORDER BY projects.start_date ASC',
      [status.name],
    );
    return rows.map((r) => ProjectModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<List<ProjectModel>> getActive() async {
    final rows = await _db.rawQuery(
      "$_joinQuery WHERE projects.status IN ('planned','startingSoon','active') ORDER BY projects.start_date ASC",
    );
    return rows.map((r) => ProjectModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<ProjectModel> create(ProjectModel project) async {
    final now = DateTime.now();
    final model = project.copyWith(
      id: IdUtils.generate(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('projects', model.toMap());
    return model;
  }

  Future<ProjectModel> update(ProjectModel project) async {
    final model = project.copyWith(updatedAt: DateTime.now());
    await _db.update(
      'projects',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  Future<void> delete(String id) async {
    await _db.delete('projects', where: 'id = ?', whereArgs: [id]);
  }
}
