import 'client_model.dart';
import 'debt_model.dart';
import 'project_model.dart';
import 'lead_model.dart';
import 'income_model.dart';
import 'reminder_model.dart';
import 'app_user_model.dart';

class ExportBundleModel {
  final String appVersion;
  final String exportVersion;
  final String exportDate;
  final List<ClientModel> clients;
  final List<DebtModel> debts;
  final List<ProjectModel> projects;
  final List<LeadModel> leads;
  final List<IncomeModel> incomes;
  final List<ReminderModel> reminders;
  final AppUserModel? user;

  const ExportBundleModel({
    required this.appVersion,
    required this.exportVersion,
    required this.exportDate,
    required this.clients,
    required this.debts,
    required this.projects,
    required this.leads,
    required this.incomes,
    required this.reminders,
    this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'app_version': appVersion,
      'export_version': exportVersion,
      'export_date': exportDate,
      'clients': clients.map((c) => c.toJson()).toList(),
      'debts': debts.map((d) => d.toJson()).toList(),
      'projects': projects.map((p) => p.toJson()).toList(),
      'leads': leads.map((l) => l.toJson()).toList(),
      'incomes': incomes.map((i) => i.toJson()).toList(),
      'reminders': reminders.map((r) => r.toJson()).toList(),
      'user': user?.toJson(),
    };
  }

  factory ExportBundleModel.fromJson(Map<String, dynamic> json) {
    return ExportBundleModel(
      appVersion: json['app_version'] as String? ?? '',
      exportVersion: json['export_version'] as String? ?? '1',
      exportDate: json['export_date'] as String? ?? '',
      clients: (json['clients'] as List<dynamic>? ?? [])
          .map((e) => ClientModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      debts: (json['debts'] as List<dynamic>? ?? [])
          .map((e) => DebtModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      projects: (json['projects'] as List<dynamic>? ?? [])
          .map((e) => ProjectModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      leads: (json['leads'] as List<dynamic>? ?? [])
          .map((e) => LeadModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      incomes: (json['incomes'] as List<dynamic>? ?? [])
          .map((e) => IncomeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reminders: (json['reminders'] as List<dynamic>? ?? [])
          .map((e) => ReminderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      user: json['user'] != null
          ? AppUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}
