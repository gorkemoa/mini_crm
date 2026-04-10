import 'package:sqflite/sqflite.dart';
import '../../models/debt_model.dart';
import '../../core/utils/id_utils.dart';
import '../database/local_database_service.dart';

class DebtRepository {
  final LocalDatabaseService _dbService;

  DebtRepository(this._dbService);

  Database get _db => _dbService.db;

  static const String _joinQuery = '''
    SELECT debts.*, clients.full_name as client_name
    FROM debts
    LEFT JOIN clients ON debts.client_id = clients.id
  ''';

  Future<List<DebtModel>> getAll() async {
    final rows = await _db.rawQuery(
      '$_joinQuery ORDER BY debts.created_at DESC',
    );
    return rows.map((r) => DebtModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<DebtModel?> getById(String id) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE debts.id = ?',
      [id],
    );
    if (rows.isEmpty) return null;
    return DebtModel.fromMap(rows.first, clientName: rows.first['client_name'] as String?);
  }

  Future<List<DebtModel>> getByClientId(String clientId) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE debts.client_id = ? ORDER BY debts.created_at DESC',
      [clientId],
    );
    return rows.map((r) => DebtModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<List<DebtModel>> getByStatus(DebtStatus status) async {
    final rows = await _db.rawQuery(
      '$_joinQuery WHERE debts.status = ? ORDER BY debts.due_date ASC',
      [status.name],
    );
    return rows.map((r) => DebtModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<List<DebtModel>> getPendingAndOverdue() async {
    final rows = await _db.rawQuery(
      "$_joinQuery WHERE debts.status IN ('pending', 'overdue', 'partial') ORDER BY debts.due_date ASC",
    );
    return rows.map((r) => DebtModel.fromMap(r, clientName: r['client_name'] as String?)).toList();
  }

  Future<double> getTotalPending() async {
    final result = await _db.rawQuery(
      "SELECT SUM(amount) as total FROM debts WHERE status IN ('pending', 'overdue', 'partial')",
    );
    return ((result.first['total'] as num?) ?? 0).toDouble();
  }

  Future<DebtModel> create(DebtModel debt) async {
    final now = DateTime.now();
    final model = debt.copyWith(
      id: IdUtils.generate(),
      createdAt: now,
      updatedAt: now,
    );
    await _db.insert('debts', model.toMap());
    return model;
  }

  Future<DebtModel> update(DebtModel debt) async {
    final model = debt.copyWith(updatedAt: DateTime.now());
    await _db.update(
      'debts',
      model.toMap(),
      where: 'id = ?',
      whereArgs: [model.id],
    );
    return model;
  }

  Future<void> delete(String id) async {
    await _db.delete('debts', where: 'id = ?', whereArgs: [id]);
  }
}
