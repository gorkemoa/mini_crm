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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
    Locale('ar'),
    Locale('zh'),
    Locale('es'),
    Locale('hi'),
    Locale('pt'),
    Locale('fr'),
    Locale('id'),
    Locale('ja'),
    Locale('de'),
    Locale('ru'),
    Locale('ko'),
    Locale('bn'),
    Locale('ur'),
    Locale('vi'),
    Locale('it'),
    Locale('fa'),
    Locale('pl'),
    Locale('th'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Mini CRM'**
  String get appTitle;

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

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get selectDate;

  /// No description provided for @status.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @additionalNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Additional notes...'**
  String get additionalNotesHint;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get customer;

  /// No description provided for @selectCustomerOptional.
  ///
  /// In en, this message translates to:
  /// **'Select client (optional)'**
  String get selectCustomerOptional;

  /// No description provided for @noCustomer.
  ///
  /// In en, this message translates to:
  /// **'— No Client —'**
  String get noCustomer;

  /// No description provided for @budget.
  ///
  /// In en, this message translates to:
  /// **'Budget'**
  String get budget;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get endDate;

  /// No description provided for @endDatePrefix.
  ///
  /// In en, this message translates to:
  /// **'End: '**
  String get endDatePrefix;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (optional)'**
  String get notesOptional;

  /// No description provided for @notesHint.
  ///
  /// In en, this message translates to:
  /// **'Notes about client...'**
  String get notesHint;

  /// No description provided for @errorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get errorOccurred;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get tryAgain;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get seeAll;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @upcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get upcoming;

  /// No description provided for @past.
  ///
  /// In en, this message translates to:
  /// **'Past'**
  String get past;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @notSpecified.
  ///
  /// In en, this message translates to:
  /// **'— Not Specified —'**
  String get notSpecified;

  /// No description provided for @dashboardSummarySection.
  ///
  /// In en, this message translates to:
  /// **'SUMMARY'**
  String get dashboardSummarySection;

  /// No description provided for @pendingDebts.
  ///
  /// In en, this message translates to:
  /// **'Pending Debts'**
  String get pendingDebts;

  /// No description provided for @activeLead.
  ///
  /// In en, this message translates to:
  /// **'Active Leads'**
  String get activeLead;

  /// No description provided for @thisMonthIncome.
  ///
  /// In en, this message translates to:
  /// **'This Month Income'**
  String get thisMonthIncome;

  /// No description provided for @todayReminders.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Reminders'**
  String get todayReminders;

  /// No description provided for @overdueDebts.
  ///
  /// In en, this message translates to:
  /// **'Overdue Debts'**
  String get overdueDebts;

  /// No description provided for @activeProjects.
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get activeProjects;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning 👋'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon 👋'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good evening 👋'**
  String get greetingEvening;

  /// No description provided for @clientsTitle.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get clientsTitle;

  /// No description provided for @noClientsYet.
  ///
  /// In en, this message translates to:
  /// **'No clients yet'**
  String get noClientsYet;

  /// No description provided for @noClientsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first client.'**
  String get noClientsSubtitle;

  /// No description provided for @addClient.
  ///
  /// In en, this message translates to:
  /// **'Add Client'**
  String get addClient;

  /// No description provided for @deleteClient.
  ///
  /// In en, this message translates to:
  /// **'Delete Client'**
  String get deleteClient;

  /// No description provided for @editClient.
  ///
  /// In en, this message translates to:
  /// **'Edit Client'**
  String get editClient;

  /// No description provided for @newClient.
  ///
  /// In en, this message translates to:
  /// **'New Client'**
  String get newClient;

  /// No description provided for @debtsSection.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debtsSection;

  /// No description provided for @projectsSection.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsSection;

  /// No description provided for @noDebtsInline.
  ///
  /// In en, this message translates to:
  /// **'No debts yet.'**
  String get noDebtsInline;

  /// No description provided for @noProjectsInline.
  ///
  /// In en, this message translates to:
  /// **'No projects yet.'**
  String get noProjectsInline;

  /// No description provided for @companyOptional.
  ///
  /// In en, this message translates to:
  /// **'Company (optional)'**
  String get companyOptional;

  /// No description provided for @companyHint.
  ///
  /// In en, this message translates to:
  /// **'Company Name LLC.'**
  String get companyHint;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (optional)'**
  String get emailOptional;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'example@email.com'**
  String get emailHint;

  /// No description provided for @phoneOptional.
  ///
  /// In en, this message translates to:
  /// **'Phone (optional)'**
  String get phoneOptional;

  /// No description provided for @phoneHint.
  ///
  /// In en, this message translates to:
  /// **'+1 555 555 55 55'**
  String get phoneHint;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'John Smith'**
  String get fullNameHint;

  /// No description provided for @debtsTitle.
  ///
  /// In en, this message translates to:
  /// **'Debts'**
  String get debtsTitle;

  /// No description provided for @debtWaiting.
  ///
  /// In en, this message translates to:
  /// **'waiting'**
  String get debtWaiting;

  /// No description provided for @noDebtsYet.
  ///
  /// In en, this message translates to:
  /// **'No debts yet'**
  String get noDebtsYet;

  /// No description provided for @noDebtsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first debt.'**
  String get noDebtsSubtitle;

  /// No description provided for @addDebt.
  ///
  /// In en, this message translates to:
  /// **'Add Debt'**
  String get addDebt;

  /// No description provided for @newDebt.
  ///
  /// In en, this message translates to:
  /// **'New Debt'**
  String get newDebt;

  /// No description provided for @editDebt.
  ///
  /// In en, this message translates to:
  /// **'Edit Debt'**
  String get editDebt;

  /// No description provided for @debtTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get debtTitleLabel;

  /// No description provided for @debtTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Project delivery'**
  String get debtTitleHint;

  /// No description provided for @dueDate.
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// No description provided for @projectsTitle.
  ///
  /// In en, this message translates to:
  /// **'Projects'**
  String get projectsTitle;

  /// No description provided for @noProjectsYet.
  ///
  /// In en, this message translates to:
  /// **'No projects yet'**
  String get noProjectsYet;

  /// No description provided for @noProjectsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start by adding your first project.'**
  String get noProjectsSubtitle;

  /// No description provided for @addProject.
  ///
  /// In en, this message translates to:
  /// **'Add Project'**
  String get addProject;

  /// No description provided for @newProject.
  ///
  /// In en, this message translates to:
  /// **'New Project'**
  String get newProject;

  /// No description provided for @editProject.
  ///
  /// In en, this message translates to:
  /// **'Edit Project'**
  String get editProject;

  /// No description provided for @projectName.
  ///
  /// In en, this message translates to:
  /// **'Project Name'**
  String get projectName;

  /// No description provided for @projectNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Website design'**
  String get projectNameHint;

  /// No description provided for @projectDetails.
  ///
  /// In en, this message translates to:
  /// **'Project details...'**
  String get projectDetails;

  /// No description provided for @leadsTitle.
  ///
  /// In en, this message translates to:
  /// **'Leads'**
  String get leadsTitle;

  /// No description provided for @leadsActiveCount.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get leadsActiveCount;

  /// No description provided for @noLeadsYet.
  ///
  /// In en, this message translates to:
  /// **'No leads yet'**
  String get noLeadsYet;

  /// No description provided for @noLeadsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add potential clients here.'**
  String get noLeadsSubtitle;

  /// No description provided for @addLead.
  ///
  /// In en, this message translates to:
  /// **'Add Lead'**
  String get addLead;

  /// No description provided for @newLead.
  ///
  /// In en, this message translates to:
  /// **'New Lead'**
  String get newLead;

  /// No description provided for @editLead.
  ///
  /// In en, this message translates to:
  /// **'Edit Lead'**
  String get editLead;

  /// No description provided for @stage.
  ///
  /// In en, this message translates to:
  /// **'Stage'**
  String get stage;

  /// No description provided for @source.
  ///
  /// In en, this message translates to:
  /// **'Source'**
  String get source;

  /// No description provided for @selectSource.
  ///
  /// In en, this message translates to:
  /// **'Select source'**
  String get selectSource;

  /// No description provided for @estimatedBudget.
  ///
  /// In en, this message translates to:
  /// **'Estimated Budget'**
  String get estimatedBudget;

  /// No description provided for @followUpDate.
  ///
  /// In en, this message translates to:
  /// **'Follow-up Date'**
  String get followUpDate;

  /// No description provided for @meetingNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Meeting notes...'**
  String get meetingNotesHint;

  /// No description provided for @incomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeTitle;

  /// No description provided for @thisMonthPrefix.
  ///
  /// In en, this message translates to:
  /// **'This month: '**
  String get thisMonthPrefix;

  /// No description provided for @noIncomeYet.
  ///
  /// In en, this message translates to:
  /// **'No income yet'**
  String get noIncomeYet;

  /// No description provided for @noIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add your payments here.'**
  String get noIncomeSubtitle;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add Income'**
  String get addIncome;

  /// No description provided for @newIncome.
  ///
  /// In en, this message translates to:
  /// **'New Income'**
  String get newIncome;

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit Income'**
  String get editIncome;

  /// No description provided for @platform.
  ///
  /// In en, this message translates to:
  /// **'Platform'**
  String get platform;

  /// No description provided for @selectPlatform.
  ///
  /// In en, this message translates to:
  /// **'Select platform'**
  String get selectPlatform;

  /// No description provided for @receiptDate.
  ///
  /// In en, this message translates to:
  /// **'Receipt Date'**
  String get receiptDate;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @remindersTitle.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get remindersTitle;

  /// No description provided for @noRemindersYet.
  ///
  /// In en, this message translates to:
  /// **'No reminders'**
  String get noRemindersYet;

  /// No description provided for @noRemindersSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add important dates and tasks here.'**
  String get noRemindersSubtitle;

  /// No description provided for @addReminderTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Reminder'**
  String get addReminderTitle;

  /// No description provided for @reminderTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Reminder title...'**
  String get reminderTitleHint;

  /// No description provided for @titleCannotBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'Title cannot be empty.'**
  String get titleCannotBeEmpty;

  /// No description provided for @markCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get markCompleted;

  /// No description provided for @markIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Mark as incomplete'**
  String get markIncomplete;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get sectionData;

  /// No description provided for @sectionApp.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION'**
  String get sectionApp;

  /// No description provided for @sectionLanguage.
  ///
  /// In en, this message translates to:
  /// **'LANGUAGE'**
  String get sectionLanguage;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportData;

  /// No description provided for @exportDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Share all data as JSON'**
  String get exportDataSubtitle;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importData;

  /// No description provided for @importDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Load from JSON file'**
  String get importDataSubtitle;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @exportDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get exportDialogTitle;

  /// No description provided for @exportDialogContent.
  ///
  /// In en, this message translates to:
  /// **'All client, debt, project and income data will be exported as JSON and the share menu will open.'**
  String get exportDialogContent;

  /// No description provided for @importDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Import Data'**
  String get importDialogTitle;

  /// No description provided for @importDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This action will not overwrite existing data; records from the selected file will be added. Do you want to continue?'**
  String get importDialogContent;

  /// No description provided for @exportButton.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportButton;

  /// No description provided for @importButton.
  ///
  /// In en, this message translates to:
  /// **'Import'**
  String get importButton;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @moreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get moreTitle;

  /// No description provided for @sectionBusiness.
  ///
  /// In en, this message translates to:
  /// **'BUSINESS TRACKING'**
  String get sectionBusiness;

  /// No description provided for @sectionRemindersNav.
  ///
  /// In en, this message translates to:
  /// **'REMINDERS'**
  String get sectionRemindersNav;

  /// No description provided for @sectionAppNav.
  ///
  /// In en, this message translates to:
  /// **'APPLICATION'**
  String get sectionAppNav;

  /// No description provided for @leadsMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Track potential clients'**
  String get leadsMenuSubtitle;

  /// No description provided for @incomeMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Payment and income records'**
  String get incomeMenuSubtitle;

  /// No description provided for @remindersMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Task and calendar reminders'**
  String get remindersMenuSubtitle;

  /// No description provided for @settingsMenuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Data management and app info'**
  String get settingsMenuSubtitle;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get searchHint;

  /// No description provided for @statusActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get statusActive;

  /// No description provided for @statusInactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get statusInactive;

  /// No description provided for @statusLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get statusLost;

  /// No description provided for @debtPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get debtPending;

  /// No description provided for @debtOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get debtOverdue;

  /// No description provided for @debtPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get debtPaid;

  /// No description provided for @debtPartial.
  ///
  /// In en, this message translates to:
  /// **'Partial Payment'**
  String get debtPartial;

  /// No description provided for @projectPlanned.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get projectPlanned;

  /// No description provided for @projectStartingSoon.
  ///
  /// In en, this message translates to:
  /// **'Starting Soon'**
  String get projectStartingSoon;

  /// No description provided for @projectActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get projectActive;

  /// No description provided for @projectPaused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get projectPaused;

  /// No description provided for @projectCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get projectCompleted;

  /// No description provided for @projectCancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get projectCancelled;

  /// No description provided for @leadNew.
  ///
  /// In en, this message translates to:
  /// **'New Lead'**
  String get leadNew;

  /// No description provided for @leadContacted.
  ///
  /// In en, this message translates to:
  /// **'Contacted'**
  String get leadContacted;

  /// No description provided for @leadProposalSent.
  ///
  /// In en, this message translates to:
  /// **'Proposal Sent'**
  String get leadProposalSent;

  /// No description provided for @leadNegotiating.
  ///
  /// In en, this message translates to:
  /// **'Negotiating'**
  String get leadNegotiating;

  /// No description provided for @leadWon.
  ///
  /// In en, this message translates to:
  /// **'Won'**
  String get leadWon;

  /// No description provided for @leadLost.
  ///
  /// In en, this message translates to:
  /// **'Lost'**
  String get leadLost;

  /// No description provided for @errorDataLoad.
  ///
  /// In en, this message translates to:
  /// **'Data could not be loaded.'**
  String get errorDataLoad;

  /// No description provided for @errorClientsLoad.
  ///
  /// In en, this message translates to:
  /// **'Clients could not be loaded.'**
  String get errorClientsLoad;

  /// No description provided for @errorClientDelete.
  ///
  /// In en, this message translates to:
  /// **'Client could not be deleted.'**
  String get errorClientDelete;

  /// No description provided for @errorClientDetailLoad.
  ///
  /// In en, this message translates to:
  /// **'Client details could not be loaded.'**
  String get errorClientDetailLoad;

  /// No description provided for @errorClientSave.
  ///
  /// In en, this message translates to:
  /// **'Client could not be saved.'**
  String get errorClientSave;

  /// No description provided for @errorDebtsLoad.
  ///
  /// In en, this message translates to:
  /// **'Debts could not be loaded.'**
  String get errorDebtsLoad;

  /// No description provided for @errorDebtDelete.
  ///
  /// In en, this message translates to:
  /// **'Debt could not be deleted.'**
  String get errorDebtDelete;

  /// No description provided for @errorDebtSave.
  ///
  /// In en, this message translates to:
  /// **'Debt could not be saved.'**
  String get errorDebtSave;

  /// No description provided for @errorFormDataLoad.
  ///
  /// In en, this message translates to:
  /// **'Form data could not be loaded.'**
  String get errorFormDataLoad;

  /// No description provided for @errorProjectsLoad.
  ///
  /// In en, this message translates to:
  /// **'Projects could not be loaded.'**
  String get errorProjectsLoad;

  /// No description provided for @errorProjectDelete.
  ///
  /// In en, this message translates to:
  /// **'Project could not be deleted.'**
  String get errorProjectDelete;

  /// No description provided for @errorProjectSave.
  ///
  /// In en, this message translates to:
  /// **'Project could not be saved.'**
  String get errorProjectSave;

  /// No description provided for @errorLeadsLoad.
  ///
  /// In en, this message translates to:
  /// **'Leads could not be loaded.'**
  String get errorLeadsLoad;

  /// No description provided for @errorLeadDelete.
  ///
  /// In en, this message translates to:
  /// **'Lead could not be deleted.'**
  String get errorLeadDelete;

  /// No description provided for @errorLeadSave.
  ///
  /// In en, this message translates to:
  /// **'Lead could not be saved.'**
  String get errorLeadSave;

  /// No description provided for @errorIncomeLoad.
  ///
  /// In en, this message translates to:
  /// **'Income could not be loaded.'**
  String get errorIncomeLoad;

  /// No description provided for @errorIncomeDelete.
  ///
  /// In en, this message translates to:
  /// **'Income record could not be deleted.'**
  String get errorIncomeDelete;

  /// No description provided for @errorIncomeSave.
  ///
  /// In en, this message translates to:
  /// **'Income record could not be saved.'**
  String get errorIncomeSave;

  /// No description provided for @errorRemindersLoad.
  ///
  /// In en, this message translates to:
  /// **'Reminders could not be loaded.'**
  String get errorRemindersLoad;

  /// No description provided for @errorStatusUpdate.
  ///
  /// In en, this message translates to:
  /// **'Status could not be updated.'**
  String get errorStatusUpdate;

  /// No description provided for @errorReminderDelete.
  ///
  /// In en, this message translates to:
  /// **'Reminder could not be deleted.'**
  String get errorReminderDelete;

  /// No description provided for @errorReminderAdd.
  ///
  /// In en, this message translates to:
  /// **'Reminder could not be added.'**
  String get errorReminderAdd;

  /// No description provided for @errorExportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed.'**
  String get errorExportFailed;

  /// No description provided for @errorFileRead.
  ///
  /// In en, this message translates to:
  /// **'File could not be read.'**
  String get errorFileRead;

  /// No description provided for @errorImportFailed.
  ///
  /// In en, this message translates to:
  /// **'Import failed.'**
  String get errorImportFailed;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'de',
    'en',
    'es',
    'fa',
    'fr',
    'hi',
    'id',
    'it',
    'ja',
    'ko',
    'pl',
    'pt',
    'ru',
    'th',
    'tr',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fa':
      return AppLocalizationsFa();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
