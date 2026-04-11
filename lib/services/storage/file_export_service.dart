import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../core/base/result.dart';
import '../../core/constants/app_constants.dart';
import '../../models/export_bundle_model.dart';
import '../repositories/client_repository.dart';
import '../repositories/debt_repository.dart';
import '../repositories/project_repository.dart';
import '../repositories/lead_repository.dart';
import '../repositories/income_repository.dart';
import '../repositories/reminder_repository.dart';

class FileExportService {
  final ClientRepository _clients;
  final DebtRepository _debts;
  final ProjectRepository _projects;
  final LeadRepository _leads;
  final IncomeRepository _incomes;
  final ReminderRepository _reminders;

  FileExportService({
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

  Future<Result<String>> exportToJson() async {
    try {
      final clientsResult = await _clients.getAll();
      final debtsResult = await _debts.getAll();
      final projectsResult = await _projects.getAll();
      final leadsResult = await _leads.getAll();
      final incomesResult = await _incomes.getAll();
      final remindersResult = await _reminders.getAll();

      for (final r in [clientsResult, debtsResult, projectsResult, leadsResult, incomesResult, remindersResult]) {
        if (r.isFailure) return Result.failure(r.error!);
      }

      final bundle = ExportBundleModel(
        appVersion: AppConstants.appVersion,
        schemaVersion: AppConstants.exportSchemaVersion,
        exportDate: DateTime.now(),
        clients: clientsResult.data!,
        debts: debtsResult.data!,
        projects: projectsResult.data!,
        leads: leadsResult.data!,
        incomes: incomesResult.data!,
        reminders: remindersResult.data!,
      );

      final json = const JsonEncoder.withIndent('  ').convert(bundle.toJson());
      final dir = await getTemporaryDirectory();
      final filename =
          '${AppConstants.exportFilePrefix}_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${dir.path}/$filename');
      await file.writeAsString(json);

      final xFile = XFile(file.path, mimeType: 'application/json');
      await Share.shareXFiles([xFile], text: 'Mini CRM Export');

      return Result.success(file.path);
    } catch (e) {
      return Result.failure(e.toString());
    }
  }
}
