import '../../l10n/app_localizations.dart';

/// Translates a localization key string (stored in viewmodels) to the
/// user-facing localized string. Returns [l10n.errorOccurred] for unknown keys.
String localizeKey(AppLocalizations l10n, String? key) {
  if (key == null) return '';
  return switch (key) {
    // ── Validation ──────────────────────────────────────────────────────────
    'validationRequired' => l10n.validationRequired,
    'validationEmail' => l10n.validationEmail,
    'validationPhone' => l10n.validationPhone,
    'validationAmountRequired' => l10n.validationAmountRequired,
    'validationAmountInvalid' => l10n.validationAmountInvalid,
    'validationAmountPositive' => l10n.validationAmountPositive,
    'validationSelectClient' => l10n.validationSelectClient,
    // ── Errors ──────────────────────────────────────────────────────────────
    'errorDataLoad' => l10n.errorDataLoad,
    'errorClientsLoad' => l10n.errorClientsLoad,
    'errorClientDelete' => l10n.errorClientDelete,
    'errorClientDetailLoad' => l10n.errorClientDetailLoad,
    'errorClientSave' => l10n.errorClientSave,
    'errorDebtsLoad' => l10n.errorDebtsLoad,
    'errorDebtDelete' => l10n.errorDebtDelete,
    'errorDebtSave' => l10n.errorDebtSave,
    'errorFormDataLoad' => l10n.errorFormDataLoad,
    'errorProjectsLoad' => l10n.errorProjectsLoad,
    'errorProjectDelete' => l10n.errorProjectDelete,
    'errorProjectSave' => l10n.errorProjectSave,
    'errorLeadsLoad' => l10n.errorLeadsLoad,
    'errorLeadDelete' => l10n.errorLeadDelete,
    'errorLeadSave' => l10n.errorLeadSave,
    'errorIncomeLoad' => l10n.errorIncomeLoad,
    'errorIncomeDelete' => l10n.errorIncomeDelete,
    'errorIncomeSave' => l10n.errorIncomeSave,
    'errorRemindersLoad' => l10n.errorRemindersLoad,
    'errorStatusUpdate' => l10n.errorStatusUpdate,
    'errorReminderDelete' => l10n.errorReminderDelete,
    'errorReminderAdd' => l10n.errorReminderAdd,
    'errorExportFailed' => l10n.errorExportFailed,
    'errorFileRead' => l10n.errorFileRead,
    'errorImportFailed' => l10n.errorImportFailed,
    _ => l10n.errorOccurred,
  };
}
