import 'package:flutter/material.dart';
import '../../core/constants/route_names.dart';
import '../../models/client_model.dart';
import '../../models/debt_model.dart';
import '../../models/income_model.dart';
import '../../models/lead_model.dart';
import '../../models/project_model.dart';
import '../clients/client_detail_view.dart';
import '../clients/client_form_view.dart';
import '../clients/clients_view.dart';
import '../dashboard/dashboard_view.dart';
import '../debts/debt_form_view.dart';
import '../debts/debts_view.dart';
import '../income/income_form_view.dart';
import '../income/income_view.dart';
import '../leads/lead_form_view.dart';
import '../leads/leads_view.dart';
import '../more/more_view.dart';
import '../projects/project_detail_view.dart';
import '../projects/project_form_view.dart';
import '../projects/projects_view.dart';
import '../reminders/reminders_view.dart';
import '../settings/settings_view.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteNames.dashboard:
        return _fade(const DashboardView());

      // ── Clients ──────────────────────────────────────────
      case RouteNames.clients:
        return _slide(const ClientsView());

      case RouteNames.clientDetail:
        final client = settings.arguments as ClientModel;
        return _slide(ClientDetailView(client: client));

      case RouteNames.clientForm:
        final client = settings.arguments as ClientModel?;
        return _slide(ClientFormView(editClient: client));

      // ── Debts ────────────────────────────────────────────
      case RouteNames.debts:
        return _slide(const DebtsView());

      case RouteNames.debtForm:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slide(DebtFormView(
          initialDebt: args?['debt'] as DebtModel?,
          initialClientId: args?['clientId'] as String?,
        ));

      // ── Projects ─────────────────────────────────────────
      case RouteNames.projects:
        return _slide(const ProjectsView());

      case RouteNames.projectDetail:
        final project = settings.arguments as ProjectModel;
        return _slide(ProjectDetailView(project: project));

      case RouteNames.projectForm:
        final args = settings.arguments as Map<String, dynamic>?;
        return _slide(ProjectFormView(
          initialProject: args?['project'] as ProjectModel?,
          initialClientId: args?['clientId'] as String?,
        ));

      // ── Leads ────────────────────────────────────────────
      case RouteNames.leads:
        return _slide(const LeadsView());

      case RouteNames.leadForm:
        final lead = settings.arguments as LeadModel?;
        return _slide(LeadFormView(initialLead: lead));

      // ── Income ───────────────────────────────────────────
      case RouteNames.income:
        return _slide(const IncomeView());

      case RouteNames.incomeForm:
        final income = settings.arguments as IncomeModel?;
        return _slide(IncomeFormView(initialIncome: income));

      // ── Reminders ────────────────────────────────────────
      case RouteNames.reminders:
        return _slide(const RemindersView());

      // ── Settings ─────────────────────────────────────────
      case RouteNames.settings:
        return _slide(const SettingsView());

      // ── More ─────────────────────────────────────────────
      default:
        return _fade(const MoreView());
    }
  }

  static PageRouteBuilder<T> _slide<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) {
        final tween = Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
            .chain(CurveTween(curve: Curves.easeInOutCubic));
        return SlideTransition(position: anim.drive(tween), child: child);
      },
      transitionDuration: const Duration(milliseconds: 280),
    );
  }

  static PageRouteBuilder<T> _fade<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, __, ___) => page,
      transitionsBuilder: (_, anim, __, child) =>
          FadeTransition(opacity: anim, child: child),
      transitionDuration: const Duration(milliseconds: 200),
    );
  }
}
