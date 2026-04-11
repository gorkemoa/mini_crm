import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Mini CRM';

  @override
  String appVersion(String version) {
    return 'Version $version';
  }

  @override
  String get navDashboard => 'Dashboard';

  @override
  String get navClients => 'Clienti';

  @override
  String get navLeads => 'Lead';

  @override
  String get navDebts => 'Debiti';

  @override
  String get navProjects => 'Progetti';

  @override
  String get navIncome => 'Entrate';

  @override
  String get navReminders => 'Promemoria';

  @override
  String get navSettings => 'Impostazioni';

  @override
  String get navMore => 'Altro';

  @override
  String get navFinance => 'Finance';

  @override
  String get actionAdd => 'Aggiungi';

  @override
  String get actionEdit => 'Modifica';

  @override
  String get actionDelete => 'Elimina';

  @override
  String get actionSave => 'Salva';

  @override
  String get actionCancel => 'Annulla';

  @override
  String get actionBack => 'Back';

  @override
  String get actionSearch => 'Search';

  @override
  String get actionFilter => 'Filter';

  @override
  String get actionExport => 'Export';

  @override
  String get actionImport => 'Import';

  @override
  String get actionClose => 'Close';

  @override
  String get actionConfirm => 'Confirm';

  @override
  String get actionDone => 'Done';

  @override
  String get actionMarkComplete => 'Mark as Complete';

  @override
  String get actionMarkIncomplete => 'Mark as Incomplete';

  @override
  String get actionViewAll => 'View All';

  @override
  String get actionRefresh => 'Refresh';

  @override
  String get labelName => 'Name';

  @override
  String get labelTitle => 'Title';

  @override
  String get labelStatus => 'Status';

  @override
  String get labelDate => 'Date';

  @override
  String get labelAmount => 'Amount';

  @override
  String get labelCurrency => 'Currency';

  @override
  String get labelNote => 'Note';

  @override
  String get labelNotes => 'Notes';

  @override
  String get labelEmail => 'Email';

  @override
  String get labelPhone => 'Phone';

  @override
  String get labelCompany => 'Company';

  @override
  String get labelSource => 'Source';

  @override
  String get labelBudget => 'Budget';

  @override
  String get labelStartDate => 'Start Date';

  @override
  String get labelEndDate => 'End Date';

  @override
  String get labelDueDate => 'Due Date';

  @override
  String get labelCreatedAt => 'Created';

  @override
  String get labelDescription => 'Description';

  @override
  String get labelPlatform => 'Platform';

  @override
  String get labelClient => 'Client';

  @override
  String get labelSelectClient => 'Select Client';

  @override
  String get labelNoClient => 'No Client';

  @override
  String get labelOptional => 'Optional';

  @override
  String get labelStage => 'Stage';

  @override
  String get labelFollowUpDate => 'Follow-up Date';

  @override
  String get labelEstimatedBudget => 'Estimated Budget';

  @override
  String get labelReminderDate => 'Reminder Date';

  @override
  String get labelRelatedTo => 'Related To';

  @override
  String get labelAll => 'All';

  @override
  String get clientStatusActive => 'Active';

  @override
  String get clientStatusInactive => 'Inactive';

  @override
  String get clientStatusArchived => 'Archived';

  @override
  String get debtStatusPending => 'Pending';

  @override
  String get debtStatusOverdue => 'Overdue';

  @override
  String get debtStatusPaid => 'Paid';

  @override
  String get debtStatusPartial => 'Partial';

  @override
  String get projectStatusPlanned => 'Planned';

  @override
  String get projectStatusStartingSoon => 'Starting Soon';

  @override
  String get projectStatusActive => 'Active';

  @override
  String get projectStatusPaused => 'Paused';

  @override
  String get projectStatusCompleted => 'Completed';

  @override
  String get projectStatusCancelled => 'Cancelled';

  @override
  String get leadStageNew => 'New Lead';

  @override
  String get leadStageContacted => 'Contacted';

  @override
  String get leadStageProposalSent => 'Proposal Sent';

  @override
  String get leadStageNegotiating => 'Negotiating';

  @override
  String get leadStageWon => 'Won';

  @override
  String get leadStageLost => 'Lost';

  @override
  String get dashboardTitle => 'Dashboard';

  @override
  String get dashboardPendingDebts => 'Pending Debts';

  @override
  String get dashboardOverdueDebts => 'Overdue';

  @override
  String get dashboardProjectsThisWeek => 'This Week';

  @override
  String get dashboardLeadsToFollow => 'Leads to Follow';

  @override
  String get dashboardMonthlyIncome => 'This Month';

  @override
  String get dashboardTodayReminders => 'Today\'s Reminders';

  @override
  String get dashboardActiveClients => 'Active Clients';

  @override
  String get dashboardActiveProjects => 'Active Projects';

  @override
  String get dashboardNoRemindersToday => 'No reminders for today';

  @override
  String get dashboardGoodMorning => 'Good morning';

  @override
  String get dashboardOverview => 'Here\'s your overview';

  @override
  String get clientsTitle => 'Clients';

  @override
  String get clientsEmpty => 'No clients yet';

  @override
  String get clientsEmptyDesc => 'Add your first client to get started';

  @override
  String get clientsSearchHint => 'Search clients...';

  @override
  String get clientAddTitle => 'Add Client';

  @override
  String get clientEditTitle => 'Edit Client';

  @override
  String get clientDetailTitle => 'Client Details';

  @override
  String get clientFullName => 'Full Name';

  @override
  String get clientCompanyName => 'Company Name';

  @override
  String get clientDebts => 'Debts';

  @override
  String get clientProjects => 'Projects';

  @override
  String get clientTotalDebt => 'Total Debt';

  @override
  String get clientActiveProjects => 'Active Projects';

  @override
  String get debtsTitle => 'Debts';

  @override
  String get debtsEmpty => 'No debts yet';

  @override
  String get debtsEmptyDesc => 'Add your first debt record';

  @override
  String get debtsSearchHint => 'Search debts...';

  @override
  String get debtsTotal => 'Total';

  @override
  String get debtsOverdue => 'Overdue';

  @override
  String get debtsPending => 'Pending';

  @override
  String get debtsPaid => 'Paid';

  @override
  String get debtsAddTitle => 'Add Debt';

  @override
  String get debtsEditTitle => 'Edit Debt';

  @override
  String get debtDetailTitle => 'Debt Details';

  @override
  String get debtsClient => 'Client';

  @override
  String get debtsTotalAmount => 'Total Amount';

  @override
  String get debtsFilterAll => 'All';

  @override
  String get debtsFilterPending => 'Pending';

  @override
  String get debtsFilterOverdue => 'Overdue';

  @override
  String get debtsFilterPaid => 'Paid';

  @override
  String get projectsTitle => 'Projects';

  @override
  String get projectsEmpty => 'No projects yet';

  @override
  String get projectsEmptyDesc => 'Add your first project';

  @override
  String get projectsSearchHint => 'Search projects...';

  @override
  String get projectsAddTitle => 'Add Project';

  @override
  String get projectsEditTitle => 'Edit Project';

  @override
  String get projectDetailTitle => 'Project Details';

  @override
  String get projectClient => 'Client';

  @override
  String get projectBudget => 'Budget';

  @override
  String get projectDuration => 'Duration';

  @override
  String get leadsTitle => 'Leads';

  @override
  String get leadsEmpty => 'No leads yet';

  @override
  String get leadsEmptyDesc => 'Start tracking potential clients';

  @override
  String get leadsSearchHint => 'Search leads...';

  @override
  String get leadsAddTitle => 'Add Lead';

  @override
  String get leadsEditTitle => 'Edit Lead';

  @override
  String get leadDetailTitle => 'Lead Details';

  @override
  String get leadsConversionRate => 'Won Rate';

  @override
  String get leadsTotal => 'Total Leads';

  @override
  String get incomeTitle => 'Income';

  @override
  String get incomeEmpty => 'No income records yet';

  @override
  String get incomeEmptyDesc => 'Start recording your income';

  @override
  String get incomeSearchHint => 'Search income...';

  @override
  String get incomeAddTitle => 'Add Income';

  @override
  String get incomeEditTitle => 'Edit Income';

  @override
  String get incomeTotal => 'Total Income';

  @override
  String get incomeThisMonth => 'This Month';

  @override
  String get incomeDate => 'Income Date';

  @override
  String get remindersTitle => 'Reminders';

  @override
  String get remindersEmpty => 'No reminders';

  @override
  String get remindersEmptyDesc => 'Set reminders for important tasks';

  @override
  String get remindersAddTitle => 'Add Reminder';

  @override
  String get remindersEditTitle => 'Edit Reminder';

  @override
  String get remindersToday => 'Today';

  @override
  String get remindersUpcoming => 'Upcoming';

  @override
  String get remindersOverdue => 'Overdue';

  @override
  String get remindersCompleted => 'Completed';

  @override
  String get remindersAll => 'All';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsAppearance => 'Appearance';

  @override
  String get settingsTheme => 'Theme';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsData => 'Data Management';

  @override
  String get settingsExport => 'Export Data';

  @override
  String get settingsImport => 'Import Data';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsVersion => 'App Version';

  @override
  String get settingsExportDesc => 'Export all data as JSON file';

  @override
  String get settingsImportDesc => 'Import data from a JSON file';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String get themeSystem => 'System Default';

  @override
  String get exportTitle => 'Export Data';

  @override
  String get exportDesc => 'Your data will be exported as a JSON file. You can use this file to backup or restore your data.';

  @override
  String get exportSuccess => 'Data exported successfully';

  @override
  String get exportError => 'Export failed. Please try again.';

  @override
  String get exportButton => 'Export JSON';

  @override
  String get importTitle => 'Import Data';

  @override
  String get importDesc => 'Select a Mini CRM JSON file to import your data.';

  @override
  String get importSuccess => 'Data imported successfully';

  @override
  String get importError => 'Import failed. Invalid or corrupted file.';

  @override
  String get importWarning => 'Importing will replace ALL existing data. This action cannot be undone.';

  @override
  String get importButton => 'Select File';

  @override
  String get importReplace => 'Replace all existing data';

  @override
  String get deleteConfirmTitle => 'Delete';

  @override
  String get deleteConfirmMessage => 'Are you sure you want to delete this? This action cannot be undone.';

  @override
  String get deleteConfirmButton => 'Delete';

  @override
  String get validationRequired => 'This field is required';

  @override
  String get validationEmail => 'Please enter a valid email address';

  @override
  String get validationAmount => 'Please enter a valid amount';

  @override
  String get validationPositiveAmount => 'Amount must be greater than zero';

  @override
  String get validationDateInvalid => 'Please select a valid date';

  @override
  String get errorGeneric => 'Something went wrong. Please try again.';

  @override
  String get errorDatabase => 'Database error. Please restart the app.';

  @override
  String get errorLoadFailed => 'Failed to load data';

  @override
  String get errorSaveFailed => 'Failed to save';

  @override
  String get errorDeleteFailed => 'Failed to delete';

  @override
  String get currencyUSD => 'USD — US Dollar';

  @override
  String get currencyEUR => 'EUR — Euro';

  @override
  String get currencyTRY => 'TRY — Turkish Lira';

  @override
  String get currencyGBP => 'GBP — British Pound';

  @override
  String get currencyJPY => 'JPY — Japanese Yen';

  @override
  String get currencyCNY => 'CNY — Chinese Yuan';

  @override
  String get currencyINR => 'INR — Indian Rupee';

  @override
  String get currencyBRL => 'BRL — Brazilian Real';

  @override
  String get currencyAUD => 'AUD — Australian Dollar';

  @override
  String get currencyCAD => 'CAD — Canadian Dollar';

  @override
  String get reminderRelatedClient => 'Client';

  @override
  String get reminderRelatedDebt => 'Debt';

  @override
  String get reminderRelatedProject => 'Project';

  @override
  String get reminderRelatedLead => 'Lead';

  @override
  String get reminderRelatedIncome => 'Income';

  @override
  String get reminderRelatedGeneral => 'General';

  @override
  String daysOverdue(int days) {
    return '$days day(s) overdue';
  }

  @override
  String daysRemaining(int days) {
    return '$days day(s) remaining';
  }

  @override
  String get dueToday => 'Due today';

  @override
  String get dueTomorrow => 'Due tomorrow';
}
