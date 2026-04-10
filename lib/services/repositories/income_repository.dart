import 'package:sqflite/sqflite.dart';
import '../../models/income_model.dart';
import '../../core/utils/id_utils.dart';
import '../database/local_database_service.dart';

class IncomeRepository {
  final LocalDatabaseService _dbService;

  IncomeRepository(this._dbService);

  Database get _db => _dbService.db;

  static const String _joinQuery = '''
    SELECT incomes.*, clients.full_name as client_name
    FROM incomes
    LEFT JOIN clients ON incomes.client_id = clients.id
  ''';

  Future<List<IncomeModel>> getAll() async {
    final rows = await _db.rawQuery(
      '$_joinQuery ORDER BY incomes.date DESC',
    );
    return rows.map((r) => IncomeModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<IncomeModel?> getById(String id) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE incomes.id = ?',
      [id],
    );
    if (rows.isEmpty) return null;
    return IncomeModel.fromMap(rows.first, clientName: rows.first['client_name'] as String?);
  }

  Future<List<IncomeModel>> getByClientId(String clientId) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE incomes.client_id = ? ORDER BY incomes.date DESC',
      [clientId],
    );
    return rows.map((r) => IncomeModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<double> getTotalThisMonth() async {
    final now = DateTime.now();
    final firstDay = DateTime(now.year, now.month, 1).toIso8601String();
    final lastDay = DateTime(now.year, now.month + 1, 0, 23, 59, 59).toIso8601String();
    final result = await _db.rawQuery(
      'SELECT SUM(amount) as total FROM incomes WHERE date >= ? AND date <= ?',
      [firstDay, lastDay],
    );
    return ((result.first['total'] as num?) ?? 0).toDouble();
  }

  Future<Map<String, double>> getTotalByPlatform() async {
    final rows = await _db.rawQuery(
      'SELECT source_platform, SUM(amount) as total FROM incomes GROUP BY source_platform',
    );
    return {
      for (final row in rows)
        (row['source_platform'] as String? ?? 'Diğer'):
            ((row['total'] as num?) ?? 0).toDouble(),
    };
  }

  Future<IncomeModel> create(IncomeModel income) async {
    final now = DateTime.now();
    final model = income.copyWith(
      id: IdUtils.generate(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('incomes', model.toMap());
    return model;
  }

  Future<IncomeModel> update(IncomeModel income) async {
    final model = income.copyWith(updatedAt: DateTime.now());
    await _db.update(
      'incomes',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  Future<void> delete(String id) async {
    await _db.delete('incomes', where: 'id = ?', whereArgs: [id]);
  }
}
