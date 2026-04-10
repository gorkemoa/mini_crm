import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../core/constants/app_constants.dart';
import '../../core/errors/app_exceptions.dart';
import '../../models/export_bundle_model.dart';
import '../repositories/client_repository.dart';
import '../repositories/debt_repository.dart';
import '../repositories/project_repository.dart';
import '../repositories/lead_repository.dart';
import '../repositories/income_repository.dart';
import '../repositories/reminder_repository.dart';

class FileExportService {
  final ClientRepository _clientRepo;
  final DebtRepository _debtRepo;
  final ProjectRepository _projectRepo;
  final LeadRepository _leadRepo;
  final IncomeRepository _incomeRepo;
  final ReminderRepository _reminderRepo;

  FileExportService({
    required ClientRepository clientRepository,
    required DebtRepository debtRepository,
    required ProjectRepository projectRepository,
    required LeadRepository leadRepository,
    required IncomeRepository incomeRepository,
    required ReminderRepository reminderRepository,
  })  : _clientRepo = clientRepository,
        _debtRepo = debtRepository,
        _projectRepo = projectRepository,
        _leadRepo = leadRepository,
        _incomeRepo = incomeRepository,
        _reminderRepo = reminderRepository;

  Future<void> exportAndShare() async {
    try {
      final bundle = await _buildBundle();
      final json = const JsonEncoder.withIndent('  ').convert(bundle.toJson());
      final dir = await getTemporaryDirectory();
      final timestamp = DateTime.now().toIso8601String().replaceAll(':', '-').substring(0, 19);
      final file = File('${dir.path}/mini_crm_backup_$timestamp.json');
      await file.writeAsString(json);
      await Share.shareXFiles(
        [XFile(file.path)],
        subject: 'Mini CRM Yedek — $timestamp',
      );
    } catch (e) {
      throw ExportException('Dışa aktarma başarısız: $e');
    }
  }

  Future<String> exportToJson() async {
    try {
      final bundle = await _buildBundle();
      return const JsonEncoder.withIndent('  ').convert(bundle.toJson());
    } catch (e) {
      throw ExportException('JSON oluşturma başarısız: $e');
    }
  }

  Future<ExportBundleModel> _buildBundle() async {
    final clients = await _clientRepo.getAll();
    final debts = await _debtRepo.getAll();
    final projects = await _projectRepo.getAll();
    final leads = await _leadRepo.getAll();
    final incomes = await _incomeRepo.getAll();
    final reminders = await _reminderRepo.getAll();

    return ExportBundleModel(
      appVersion: AppConstants.appVersion,
      exportVersion: AppConstants.exportVersion,
      exportDate: DateTime.now().toIso8601String(),
      clients: clients,
      debts: debts,
      projects: projects,
      leads: leads,
      incomes: incomes,
      reminders: reminders,
    );
  }
}
