import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

import '../../core/base/result.dart';
import '../../models/export_bundle_model.dart';
import '../repositories/client_repository.dart';
import '../repositories/debt_repository.dart';
import '../repositories/project_repository.dart';
import '../repositories/lead_repository.dart';
import '../repositories/income_repository.dart';
import '../repositories/reminder_repository.dart';

class FileImportService {
  final ClientRepository _clients;
  final DebtRepository _debts;
  final ProjectRepository _projects;
  final LeadRepository _leads;
  final IncomeRepository _incomes;
  final ReminderRepository _reminders;

  FileImportService({
    required ClientRepository clients,
    required DebtRepository debts,
    required ProjectRepository projects,
    required LeadRepository leads,
    required IncomeRepository incomes,
    required ReminderRepository reminders,
  })  : _clients = clients,
        _debts = debts,
        _projects = projects,
        _leads = leads,
        _incomes = incomes,
        _reminders = reminders;

  Future<Result<ExportBundleModel?>> pickAndPreview() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        withData: true,
      );
      if (result == null || result.files.isEmpty) return Result.success(null);

      final file = result.files.first;
      final bytes = file.bytes ?? (file.path != null ? await File(file.path!).readAsBytes() : null);
      if (bytes == null) return Result.failure('Could not read file');

      final jsonStr = utf8.decode(bytes);
      final json = jsonDecode(jsonStr) as Map<String, dynamic>;
      final bundle = ExportBundleModel.fromJson(json);
      return Result.success(bundle);
    } catch (e) {
      return Result.failure('Invalid or corrupted file: ${e.toString()}');
    }
  }

  Future<Result<void>> importBundle(ExportBundleModel bundle) async {
    try {
      // Clear all data first
      await _reminders.deleteAll();
      await _incomes.deleteAll();
      await _leads.deleteAll();
      await _projects.deleteAll();
      await _debts.deleteAll();
      await _clients.deleteAll();

      // Insert new data
      if (bundle.clients.isNotEmpty) {
        final r = await _clients.insertAll(bundle.clients);
        if (r.isFailure) return Result.failure(r.error!);
      }
      if (bundle.debts.isNotEmpty) {
        final r = await _debts.insertAll(bundle.debts);
        if (r.isFailure) return Result.failure(r.error!);
      }
      if (bundle.projects.isNotEmpty) {
        final r = await _projects.insertAll(bundle.projects);
        if (r.isFailure) return Result.failure(r.error!);
      }
      if (bundle.leads.isNotEmpty) {
        final r = await _leads.insertAll(bundle.leads);
        if (r.isFailure) return Result.failure(r.error!);
      }
      if (bundle.incomes.isNotEmpty) {
        final r = await _incomes.insertAll(bundle.incomes);
        if (r.isFailure) return Result.failure(r.error!);
      }
      if (bundle.reminders.isNotEmpty) {
        final r = await _reminders.insertAll(bundle.reminders);
        if (r.isFailure) return Result.failure(r.error!);
      }

      return Result.success(null);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
