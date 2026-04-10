import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import '../../core/errors/app_exceptions.dart';
import '../../models/export_bundle_model.dart';
import '../repositories/client_repository.dart';
import '../repositories/debt_repository.dart';
import '../repositories/project_repository.dart';
import '../repositories/lead_repository.dart';
import '../repositories/income_repository.dart';
import '../repositories/reminder_repository.dart';

class FileImportService {
  final ClientRepository _clientRepo;
  final DebtRepository _debtRepo;
  final ProjectRepository _projectRepo;
  final LeadRepository _leadRepo;
  final IncomeRepository _incomeRepo;
  final ReminderRepository _reminderRepo;

  FileImportService({
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

  Future<ExportBundleModel?> pickAndParse() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        allowMultiple: false,
      );
      if (result == null || result.files.isEmpty) return null;

      final path = result.files.first.path;
      if (path == null) throw const ImportException('Dosya yolu alınamadı.');

      final content = await File(path).readAsString();
      return _parse(content);
    } on ImportException {
      rethrow;
    } catch (e) {
      throw ImportException('Dosya okunamadı: $e');
    }
  }

  ExportBundleModel _parse(String content) {
    try {
      final json = jsonDecode(content) as Map<String, dynamic>;
      _validateVersion(json);
      return ExportBundleModel.fromJson(json);
    } on ImportException {
      rethrow;
    } catch (e) {
      throw ImportException('Dosya formatı geçersiz: $e');
    }
  }

  void _validateVersion(Map<String, dynamic> json) {
    final version = json['export_version'] as String?;
    if (version == null || version.isEmpty) {
      throw const ImportException('Yedek dosyası sürümü bulunamadı.');
    }
  }

  Future<void> importBundle(
    ExportBundleModel bundle, {
    bool replace = false,
  }) async {
    try {
      for (final client in bundle.clients) {
        await _clientRepo.create(client);
      }
      for (final debt in bundle.debts) {
        await _debtRepo.create(debt);
      }
      for (final project in bundle.projects) {
        await _projectRepo.create(project);
      }
      for (final lead in bundle.leads) {
        await _leadRepo.create(lead);
      }
      for (final income in bundle.incomes) {
        await _incomeRepo.create(income);
      }
      for (final reminder in bundle.reminders) {
        await _reminderRepo.create(reminder);
      }
    } catch (e) {
      throw ImportException('İçe aktarma sırasında hata: $e');
    }
  }
}
