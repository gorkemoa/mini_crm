import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fa.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fa'),
    Locale('fr'),
    Locale('hi'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('th'),
    Locale('tr'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mini CRM'**
  String get appTitle;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get navClients;

  /// No description provided for @navLeads.
  ///
  /// In en, this message translates to:
  /// **'Leads'**
  String get navLeads;

  /// No description provided for @navDebts.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get navDebts;

  /// No description provided for @navProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get navProjects;

  /// No description provided for @navIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get navIncome;

  /// No description provided for @navReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get navReminders;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navFinance.
  ///
  /// In en, this message translates to:
  /// **'Finance'**
  String get navFinance;

  /// No description provided for @actionAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get actionAdd;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get actionSave;

  /// No description provided for @actionCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get actionCancel;

  /// No description provided for @actionBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get actionBack;

  /// No description provided for @actionSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get actionSearch;

  /// No description provided for @actionFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get actionFilter;

  /// No description provided for @actionExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get actionExport;

  /// No description provided for @actionImport.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get actionImport;

  /// No description provided for @actionClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get actionClose;

  /// No description provided for @actionConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get actionConfirm;

  /// No description provided for @actionDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get actionDone;

  /// No description provided for @actionMarkComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Complete'**
  String get actionMarkComplete;

  /// No description provided for @actionMarkIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as Incomplete'**
  String get actionMarkIncomplete;

  /// No description provided for @actionViewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get actionViewAll;

  /// No description provided for @actionRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get actionRefresh;

  /// No description provided for @labelName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get labelName;

  /// No description provided for @labelTitle.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get labelTitle;

  /// No description provided for @labelStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get labelStatus;

  /// No description provided for @labelDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get labelDate;

  /// No description provided for @labelAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get labelAmount;

  /// No description provided for @labelCurrency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get labelCurrency;

  /// No description provided for @labelNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get labelNote;

  /// No description provided for @labelNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get labelNotes;

  /// No description provided for @labelEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get labelEmail;

  /// No description provided for @labelPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get labelPhone;

  /// No description provided for @labelCompany.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get labelCompany;

  /// No description provided for @labelSource.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get labelSource;

  /// No description provided for @labelBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get labelBudget;

  /// No description provided for @labelStartDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get labelStartDate;

  /// No description provided for @labelEndDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get labelEndDate;

  /// No description provided for @labelDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get labelDueDate;

  /// No description provided for @labelCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Created'**
  String get labelCreatedAt;

  /// No description provided for @labelDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get labelDescription;

  /// No description provided for @labelPlatform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get labelPlatform;

  /// No description provided for @labelClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get labelClient;

  /// No description provided for @labelSelectClient.
  ///
  /// In en, this message translates to:
  /// **'Select Client'**
  String get labelSelectClient;

  /// No description provided for @labelNoClient.
  ///
  /// In en, this message translates to:
  /// **'No Client'**
  String get labelNoClient;

  /// No description provided for @labelOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get labelOptional;

  /// No description provided for @labelStage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get labelStage;

  /// No description provided for @labelFollowUpDate.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Date'**
  String get labelFollowUpDate;

  /// No description provided for @labelEstimatedBudget.
  ///
  /// In en, this message translates to:
  /// **'Estimated Budget'**
  String get labelEstimatedBudget;

  /// No description provided for @labelReminderDate.
  ///
  /// In en, this message translates to:
  /// **'Reminder Date'**
  String get labelReminderDate;

  /// No description provided for @labelRelatedTo.
  ///
  /// In en, this message translates to:
  /// **'Related To'**
  String get labelRelatedTo;

  /// No description provided for @labelAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get labelAll;

  /// No description provided for @clientStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get clientStatusActive;

  /// No description provided for @clientStatusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get clientStatusInactive;

  /// No description provided for @clientStatusArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get clientStatusArchived;

  /// No description provided for @debtStatusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get debtStatusPending;

  /// No description provided for @debtStatusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get debtStatusOverdue;

  /// No description provided for @debtStatusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get debtStatusPaid;

  /// No description provided for @debtStatusPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial'**
  String get debtStatusPartial;

  /// No description provided for @projectStatusPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get projectStatusPlanned;

  /// No description provided for @projectStatusStartingSoon.
  ///
  /// In en, this message translates to:
  /// **'Starting Soon'**
  String get projectStatusStartingSoon;

  /// No description provided for @projectStatusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get projectStatusActive;

  /// No description provided for @projectStatusPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get projectStatusPaused;

  /// No description provided for @projectStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get projectStatusCompleted;

  /// No description provided for @projectStatusCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get projectStatusCancelled;

  /// No description provided for @leadStageNew.
  ///
  /// In en, this message translates to:
  /// **'New Lead'**
  String get leadStageNew;

  /// No description provided for @leadStageContacted.
  ///
  /// In en, this message translates to:
  /// **'Contacted'**
  String get leadStageContacted;

  /// No description provided for @leadStageProposalSent.
  ///
  /// In en, this message translates to:
  /// **'Proposal Sent'**
  String get leadStageProposalSent;

  /// No description provided for @leadStageNegotiating.
  ///
  /// In en, this message translates to:
  /// **'Negotiating'**
  String get leadStageNegotiating;

  /// No description provided for @leadStageWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get leadStageWon;

  /// No description provided for @leadStageLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get leadStageLost;

  /// No description provided for @dashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboardTitle;

  /// No description provided for @dashboardPendingDebts.
  ///
  /// In en, this message translates to:
  /// **'Pending Debts'**
  String get dashboardPendingDebts;

  /// No description provided for @dashboardOverdueDebts.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get dashboardOverdueDebts;

  /// No description provided for @dashboardProjectsThisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get dashboardProjectsThisWeek;

  /// No description provided for @dashboardLeadsToFollow.
  ///
  /// In en, this message translates to:
  /// **'Leads to Follow'**
  String get dashboardLeadsToFollow;

  /// No description provided for @dashboardMonthlyIncome.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get dashboardMonthlyIncome;

  /// No description provided for @dashboardTodayReminders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Reminders'**
  String get dashboardTodayReminders;

  /// No description provided for @dashboardActiveClients.
  ///
  /// In en, this message translates to:
  /// **'Active Clients'**
  String get dashboardActiveClients;

  /// No description provided for @dashboardActiveProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get dashboardActiveProjects;

  /// No description provided for @dashboardNoRemindersToday.
  ///
  /// In en, this message translates to:
  /// **'No reminders for today'**
  String get dashboardNoRemindersToday;

  /// No description provided for @dashboardGoodMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning'**
  String get dashboardGoodMorning;

  /// No description provided for @dashboardOverview.
  ///
  /// In en, this message translates to:
  /// **'Here\'s your overview'**
  String get dashboardOverview;

  /// No description provided for @clientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientsTitle;

  /// No description provided for @clientsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No clients yet'**
  String get clientsEmpty;

  /// No description provided for @clientsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first client to get started'**
  String get clientsEmptyDesc;

  /// No description provided for @clientsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search clients...'**
  String get clientsSearchHint;

  /// No description provided for @clientAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get clientAddTitle;

  /// No description provided for @clientEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get clientEditTitle;

  /// No description provided for @clientDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Client Details'**
  String get clientDetailTitle;

  /// No description provided for @clientFullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get clientFullName;

  /// No description provided for @clientCompanyName.
  ///
  /// In en, this message translates to:
  /// **'Company Name'**
  String get clientCompanyName;

  /// No description provided for @clientDebts.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get clientDebts;

  /// No description provided for @clientProjects.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get clientProjects;

  /// No description provided for @clientTotalDebt.
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get clientTotalDebt;

  /// No description provided for @clientActiveProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get clientActiveProjects;

  /// No description provided for @debtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debtsTitle;

  /// No description provided for @debtsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No debts yet'**
  String get debtsEmpty;

  /// No description provided for @debtsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first debt record'**
  String get debtsEmptyDesc;

  /// No description provided for @debtsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search debts...'**
  String get debtsSearchHint;

  /// No description provided for @debtsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get debtsTotal;

  /// No description provided for @debtsOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get debtsOverdue;

  /// No description provided for @debtsPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get debtsPending;

  /// No description provided for @debtsPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get debtsPaid;

  /// No description provided for @debtsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Debt'**
  String get debtsAddTitle;

  /// No description provided for @debtsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Debt'**
  String get debtsEditTitle;

  /// No description provided for @debtDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Debt Details'**
  String get debtDetailTitle;

  /// No description provided for @debtsClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get debtsClient;

  /// No description provided for @debtsTotalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get debtsTotalAmount;

  /// No description provided for @debtsFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get debtsFilterAll;

  /// No description provided for @debtsFilterPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get debtsFilterPending;

  /// No description provided for @debtsFilterOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get debtsFilterOverdue;

  /// No description provided for @debtsFilterPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get debtsFilterPaid;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @projectsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get projectsEmpty;

  /// No description provided for @projectsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Add your first project'**
  String get projectsEmptyDesc;

  /// No description provided for @projectsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search projects...'**
  String get projectsSearchHint;

  /// No description provided for @projectsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Project'**
  String get projectsAddTitle;

  /// No description provided for @projectsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get projectsEditTitle;

  /// No description provided for @projectDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Project Details'**
  String get projectDetailTitle;

  /// No description provided for @projectClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get projectClient;

  /// No description provided for @projectBudget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get projectBudget;

  /// No description provided for @projectDuration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get projectDuration;

  /// No description provided for @leadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Leads'**
  String get leadsTitle;

  /// No description provided for @leadsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No leads yet'**
  String get leadsEmpty;

  /// No description provided for @leadsEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Start tracking potential clients'**
  String get leadsEmptyDesc;

  /// No description provided for @leadsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search leads...'**
  String get leadsSearchHint;

  /// No description provided for @leadsAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Lead'**
  String get leadsAddTitle;

  /// No description provided for @leadsEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Lead'**
  String get leadsEditTitle;

  /// No description provided for @leadDetailTitle.
  ///
  /// In en, this message translates to:
  /// **'Lead Details'**
  String get leadDetailTitle;

  /// No description provided for @leadsConversionRate.
  ///
  /// In en, this message translates to:
  /// **'Won Rate'**
  String get leadsConversionRate;

  /// No description provided for @leadsTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Leads'**
  String get leadsTotal;

  /// No description provided for @incomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeTitle;

  /// No description provided for @incomeEmpty.
  ///
  /// In en, this message translates to:
  /// **'No income records yet'**
  String get incomeEmpty;

  /// No description provided for @incomeEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Start recording your income'**
  String get incomeEmptyDesc;

  /// No description provided for @incomeSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search income...'**
  String get incomeSearchHint;

  /// No description provided for @incomeAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get incomeAddTitle;

  /// No description provided for @incomeEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get incomeEditTitle;

  /// No description provided for @incomeTotal.
  ///
  /// In en, this message translates to:
  /// **'Total Income'**
  String get incomeTotal;

  /// No description provided for @incomeThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get incomeThisMonth;

  /// No description provided for @incomeDate.
  ///
  /// In en, this message translates to:
  /// **'Income Date'**
  String get incomeDate;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @remindersEmpty.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get remindersEmpty;

  /// No description provided for @remindersEmptyDesc.
  ///
  /// In en, this message translates to:
  /// **'Set reminders for important tasks'**
  String get remindersEmptyDesc;

  /// No description provided for @remindersAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get remindersAddTitle;

  /// No description provided for @remindersEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Reminder'**
  String get remindersEditTitle;

  /// No description provided for @remindersToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get remindersToday;

  /// No description provided for @remindersUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get remindersUpcoming;

  /// No description provided for @remindersOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get remindersOverdue;

  /// No description provided for @remindersCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get remindersCompleted;

  /// No description provided for @remindersAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get remindersAll;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsTheme;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsData.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get settingsData;

  /// No description provided for @settingsExport.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get settingsExport;

  /// No description provided for @settingsImport.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get settingsImport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'App Version'**
  String get settingsVersion;

  /// No description provided for @settingsExportDesc.
  ///
  /// In en, this message translates to:
  /// **'Export all data as JSON file'**
  String get settingsExportDesc;

  /// No description provided for @settingsImportDesc.
  ///
  /// In en, this message translates to:
  /// **'Import data from a JSON file'**
  String get settingsImportDesc;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System Default'**
  String get themeSystem;

  /// No description provided for @exportTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportTitle;

  /// No description provided for @exportDesc.
  ///
  /// In en, this message translates to:
  /// **'Your data will be exported as a JSON file. You can use this file to backup or restore your data.'**
  String get exportDesc;

  /// No description provided for @exportSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data exported successfully'**
  String get exportSuccess;

  /// No description provided for @exportError.
  ///
  /// In en, this message translates to:
  /// **'Export failed. Please try again.'**
  String get exportError;

  /// No description provided for @exportButton.
  ///
  /// In en, this message translates to:
  /// **'Export JSON'**
  String get exportButton;

  /// No description provided for @importTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importTitle;

  /// No description provided for @importDesc.
  ///
  /// In en, this message translates to:
  /// **'Select a Mini CRM JSON file to import your data.'**
  String get importDesc;

  /// No description provided for @importSuccess.
  ///
  /// In en, this message translates to:
  /// **'Data imported successfully'**
  String get importSuccess;

  /// No description provided for @importError.
  ///
  /// In en, this message translates to:
  /// **'Import failed. Invalid or corrupted file.'**
  String get importError;

  /// No description provided for @importWarning.
  ///
  /// In en, this message translates to:
  /// **'Importing will replace ALL existing data. This action cannot be undone.'**
  String get importWarning;

  /// No description provided for @importButton.
  ///
  /// In en, this message translates to:
  /// **'Select File'**
  String get importButton;

  /// No description provided for @importReplace.
  ///
  /// In en, this message translates to:
  /// **'Replace all existing data'**
  String get importReplace;

  /// No description provided for @deleteConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirmTitle;

  /// No description provided for @deleteConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this? This action cannot be undone.'**
  String get deleteConfirmMessage;

  /// No description provided for @deleteConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteConfirmButton;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get validationEmail;

  /// No description provided for @validationAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get validationAmount;

  /// No description provided for @validationPositiveAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount must be greater than zero'**
  String get validationPositiveAmount;

  /// No description provided for @validationDateInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please select a valid date'**
  String get validationDateInvalid;

  /// No description provided for @errorGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorGeneric;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Database error. Please restart the app.'**
  String get errorDatabase;

  /// No description provided for @errorLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data'**
  String get errorLoadFailed;

  /// No description provided for @errorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to save'**
  String get errorSaveFailed;

  /// No description provided for @errorDeleteFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete'**
  String get errorDeleteFailed;

  /// No description provided for @currencyUSD.
  ///
  /// In en, this message translates to:
  /// **'USD — US Dollar'**
  String get currencyUSD;

  /// No description provided for @currencyEUR.
  ///
  /// In en, this message translates to:
  /// **'EUR — Euro'**
  String get currencyEUR;

  /// No description provided for @currencyTRY.
  ///
  /// In en, this message translates to:
  /// **'TRY — Turkish Lira'**
  String get currencyTRY;

  /// No description provided for @currencyGBP.
  ///
  /// In en, this message translates to:
  /// **'GBP — British Pound'**
  String get currencyGBP;

  /// No description provided for @currencyJPY.
  ///
  /// In en, this message translates to:
  /// **'JPY — Japanese Yen'**
  String get currencyJPY;

  /// No description provided for @currencyCNY.
  ///
  /// In en, this message translates to:
  /// **'CNY — Chinese Yuan'**
  String get currencyCNY;

  /// No description provided for @currencyINR.
  ///
  /// In en, this message translates to:
  /// **'INR — Indian Rupee'**
  String get currencyINR;

  /// No description provided for @currencyBRL.
  ///
  /// In en, this message translates to:
  /// **'BRL — Brazilian Real'**
  String get currencyBRL;

  /// No description provided for @currencyAUD.
  ///
  /// In en, this message translates to:
  /// **'AUD — Australian Dollar'**
  String get currencyAUD;

  /// No description provided for @currencyCAD.
  ///
  /// In en, this message translates to:
  /// **'CAD — Canadian Dollar'**
  String get currencyCAD;

  /// No description provided for @reminderRelatedClient.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get reminderRelatedClient;

  /// No description provided for @reminderRelatedDebt.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get reminderRelatedDebt;

  /// No description provided for @reminderRelatedProject.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get reminderRelatedProject;

  /// No description provided for @reminderRelatedLead.
  ///
  /// In en, this message translates to:
  /// **'Lead'**
  String get reminderRelatedLead;

  /// No description provided for @reminderRelatedIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get reminderRelatedIncome;

  /// No description provided for @reminderRelatedGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get reminderRelatedGeneral;

  /// No description provided for @daysOverdue.
  ///
  /// In en, this message translates to:
  /// **'{days} day(s) overdue'**
  String daysOverdue(int days);

  /// No description provided for @daysRemaining.
  ///
  /// In en, this message translates to:
  /// **'{days} day(s) remaining'**
  String daysRemaining(int days);

  /// No description provided for @dueToday.
  ///
  /// In en, this message translates to:
  /// **'Due today'**
  String get dueToday;

  /// No description provided for @dueTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Due tomorrow'**
  String get dueTomorrow;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'bn', 'de', 'en', 'es', 'fa', 'fr', 'hi', 'id', 'it', 'ja', 'ko', 'pl', 'pt', 'ru', 'th', 'tr', 'ur', 'vi', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'bn': return AppLocalizationsBn();
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fa': return AppLocalizationsFa();
    case 'fr': return AppLocalizationsFr();
    case 'hi': return AppLocalizationsHi();
    case 'id': return AppLocalizationsId();
    case 'it': return AppLocalizationsIt();
    case 'ja': return AppLocalizationsJa();
    case 'ko': return AppLocalizationsKo();
    case 'pl': return AppLocalizationsPl();
    case 'pt': return AppLocalizationsPt();
    case 'ru': return AppLocalizationsRu();
    case 'th': return AppLocalizationsTh();
    case 'tr': return AppLocalizationsTr();
    case 'ur': return AppLocalizationsUr();
    case 'vi': return AppLocalizationsVi();
    case 'zh': return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
