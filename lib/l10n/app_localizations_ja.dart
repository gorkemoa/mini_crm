// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Mini CRM';

  @override
  String get navDashboard => 'ダッシュボード';

  @override
  String get navClients => 'クライアント';

  @override
  String get navDebts => '請求';

  @override
  String get navProjects => 'プロジェクト';

  @override
  String get navMore => 'その他';

  @override
  String get all => 'すべて';

  @override
  String get edit => '編集';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get update => '更新';

  @override
  String get cancel => 'キャンセル';

  @override
  String get add => '追加';

  @override
  String get selectDate => '選択';

  @override
  String get status => 'ステータス';

  @override
  String get note => 'メモ';

  @override
  String get additionalNotesHint => '追加メモ...';

  @override
  String get amount => '金額';

  @override
  String get amountHint => '0.00';

  @override
  String get notes => 'メモ';

  @override
  String get email => 'メール';

  @override
  String get phone => '電話';

  @override
  String get customer => 'クライアント';

  @override
  String get selectCustomerOptional => 'クライアントを選択（任意）';

  @override
  String get noCustomer => '— クライアントなし —';

  @override
  String get budget => '予算';

  @override
  String get description => '説明';

  @override
  String get startDate => '開始';

  @override
  String get endDate => '終了';

  @override
  String get endDatePrefix => '終了: ';

  @override
  String get fullName => '氏名';

  @override
  String get notesOptional => 'メモ（任意）';

  @override
  String get notesHint => 'クライアントに関するメモ...';

  @override
  String get errorOccurred => 'エラーが発生しました';

  @override
  String get tryAgain => '再試行';

  @override
  String get seeAll => 'すべて';

  @override
  String get today => '今日';

  @override
  String get upcoming => '近日';

  @override
  String get past => '過去';

  @override
  String get completed => '完了';

  @override
  String get notSpecified => '— 未指定 —';

  @override
  String get dashboardSummarySection => 'サマリー';

  @override
  String get pendingDebts => '未払い請求';

  @override
  String get activeLead => 'アクティブリード';

  @override
  String get thisMonthIncome => '今月の収入';

  @override
  String get todayReminders => '今日のリマインダー';

  @override
  String get overdueDebts => '期限切れ請求';

  @override
  String get activeProjects => '進行中プロジェクト';

  @override
  String get greetingMorning => 'おはようございます 👋';

  @override
  String get greetingAfternoon => 'こんにちは 👋';

  @override
  String get greetingEvening => 'こんばんは 👋';

  @override
  String get clientsTitle => 'クライアント';

  @override
  String get noClientsYet => 'クライアントがまだいません';

  @override
  String get noClientsSubtitle => '最初のクライアントを追加して始めましょう。';

  @override
  String get addClient => 'クライアントを追加';

  @override
  String get deleteClient => 'クライアントを削除';

  @override
  String get editClient => 'クライアントを編集';

  @override
  String get newClient => '新しいクライアント';

  @override
  String get debtsSection => '請求';

  @override
  String get projectsSection => 'プロジェクト';

  @override
  String get noDebtsInline => '請求がまだありません。';

  @override
  String get noProjectsInline => 'プロジェクトがまだありません。';

  @override
  String get companyOptional => '会社（任意）';

  @override
  String get companyHint => '会社名株式会社';

  @override
  String get emailOptional => 'メール（任意）';

  @override
  String get emailHint => 'example@email.com';

  @override
  String get phoneOptional => '電話（任意）';

  @override
  String get phoneHint => '090-0000-0000';

  @override
  String get fullNameHint => '山田 太郎';

  @override
  String get debtsTitle => '請求';

  @override
  String get debtWaiting => '待機中';

  @override
  String get noDebtsYet => '請求がまだありません';

  @override
  String get noDebtsSubtitle => '最初の請求を追加して始めましょう。';

  @override
  String get addDebt => '請求を追加';

  @override
  String get newDebt => '新しい請求';

  @override
  String get editDebt => '請求を編集';

  @override
  String get debtTitleLabel => 'タイトル';

  @override
  String get debtTitleHint => '例: プロジェクト納品';

  @override
  String get dueDate => '支払期日';

  @override
  String get projectsTitle => 'プロジェクト';

  @override
  String get noProjectsYet => 'プロジェクトがまだありません';

  @override
  String get noProjectsSubtitle => '最初のプロジェクトを追加して始めましょう。';

  @override
  String get addProject => 'プロジェクトを追加';

  @override
  String get newProject => '新しいプロジェクト';

  @override
  String get editProject => 'プロジェクトを編集';

  @override
  String get projectName => 'プロジェクト名';

  @override
  String get projectNameHint => '例: ウェブサイトデザイン';

  @override
  String get projectDetails => 'プロジェクトの詳細...';

  @override
  String get leadsTitle => 'リード';

  @override
  String get leadsActiveCount => 'アクティブ';

  @override
  String get noLeadsYet => 'リードがまだありません';

  @override
  String get noLeadsSubtitle => '潜在的なクライアントをここに追加してください。';

  @override
  String get addLead => 'リードを追加';

  @override
  String get newLead => '新しいリード';

  @override
  String get editLead => 'リードを編集';

  @override
  String get stage => 'ステージ';

  @override
  String get source => 'ソース';

  @override
  String get selectSource => 'ソースを選択';

  @override
  String get estimatedBudget => '見積予算';

  @override
  String get followUpDate => 'フォローアップ日';

  @override
  String get meetingNotesHint => 'ミーティングメモ...';

  @override
  String get incomeTitle => '収入';

  @override
  String get thisMonthPrefix => '今月: ';

  @override
  String get noIncomeYet => '収入がまだありません';

  @override
  String get noIncomeSubtitle => '支払い記録をここに追加してください。';

  @override
  String get addIncome => '収入を追加';

  @override
  String get newIncome => '新しい収入';

  @override
  String get editIncome => '収入を編集';

  @override
  String get platform => 'プラットフォーム';

  @override
  String get selectPlatform => 'プラットフォームを選択';

  @override
  String get receiptDate => '受領日';

  @override
  String get income => '収入';

  @override
  String get remindersTitle => 'リマインダー';

  @override
  String get noRemindersYet => 'リマインダーがありません';

  @override
  String get noRemindersSubtitle => '重要な日程とタスクをここに追加してください。';

  @override
  String get addReminderTitle => 'リマインダーを追加';

  @override
  String get reminderTitleHint => 'リマインダーのタイトル...';

  @override
  String get titleCannotBeEmpty => 'タイトルを入力してください。';

  @override
  String get markCompleted => '完了';

  @override
  String get markIncomplete => '未完了にする';

  @override
  String get settingsTitle => '設定';

  @override
  String get sectionData => 'データ';

  @override
  String get sectionApp => 'アプリ';

  @override
  String get sectionLanguage => '言語';

  @override
  String get exportData => 'データをエクスポート';

  @override
  String get exportDataSubtitle => 'すべてのデータをJSONで共有';

  @override
  String get importData => 'データをインポート';

  @override
  String get importDataSubtitle => 'JSONファイルから読み込む';

  @override
  String get version => 'バージョン';

  @override
  String get exportDialogTitle => 'データをエクスポート';

  @override
  String get exportDialogContent =>
      'すべてのクライアント、請求、プロジェクト、収入データがJSON形式でエクスポートされ、共有メニューが開きます。';

  @override
  String get importDialogTitle => 'データをインポート';

  @override
  String get importDialogContent =>
      'このアクションは既存のデータを上書きしません。選択したファイルのレコードが追加されます。続行しますか？';

  @override
  String get exportButton => 'エクスポート';

  @override
  String get importButton => 'インポート';

  @override
  String get language => '言語';

  @override
  String get selectLanguage => '言語を選択';

  @override
  String get moreTitle => 'その他';

  @override
  String get sectionBusiness => 'ビジネス管理';

  @override
  String get sectionRemindersNav => 'リマインダー';

  @override
  String get sectionAppNav => 'アプリ';

  @override
  String get leadsMenuSubtitle => '潜在クライアントを追跡';

  @override
  String get incomeMenuSubtitle => '支払いと収入の記録';

  @override
  String get remindersMenuSubtitle => 'タスクとカレンダーのリマインダー';

  @override
  String get settingsMenuSubtitle => 'データ管理とアプリ情報';

  @override
  String get searchHint => '検索...';

  @override
  String get statusActive => 'アクティブ';

  @override
  String get statusInactive => '非アクティブ';

  @override
  String get statusLost => '失注';

  @override
  String get debtPending => '保留中';

  @override
  String get debtOverdue => '期限切れ';

  @override
  String get debtPaid => '支払済';

  @override
  String get debtPartial => '一部支払';

  @override
  String get projectPlanned => '計画中';

  @override
  String get projectStartingSoon => 'まもなく開始';

  @override
  String get projectActive => '進行中';

  @override
  String get projectPaused => '一時停止';

  @override
  String get projectCompleted => '完了';

  @override
  String get projectCancelled => 'キャンセル';

  @override
  String get leadNew => '新規リード';

  @override
  String get leadContacted => '連絡済';

  @override
  String get leadProposalSent => '提案送付済';

  @override
  String get leadNegotiating => '交渉中';

  @override
  String get leadWon => '受注';

  @override
  String get leadLost => '失注';

  @override
  String get errorDataLoad => 'データを読み込めませんでした。';

  @override
  String get errorClientsLoad => 'クライアントを読み込めませんでした。';

  @override
  String get errorClientDelete => 'クライアントを削除できませんでした。';

  @override
  String get errorClientDetailLoad => 'クライアントの詳細を読み込めませんでした。';

  @override
  String get errorClientSave => 'クライアントを保存できませんでした。';

  @override
  String get errorDebtsLoad => '請求を読み込めませんでした。';

  @override
  String get errorDebtDelete => '請求を削除できませんでした。';

  @override
  String get errorDebtSave => '請求を保存できませんでした。';

  @override
  String get errorFormDataLoad => 'フォームデータを読み込めませんでした。';

  @override
  String get errorProjectsLoad => 'プロジェクトを読み込めませんでした。';

  @override
  String get errorProjectDelete => 'プロジェクトを削除できませんでした。';

  @override
  String get errorProjectSave => 'プロジェクトを保存できませんでした。';

  @override
  String get errorLeadsLoad => 'リードを読み込めませんでした。';

  @override
  String get errorLeadDelete => 'リードを削除できませんでした。';

  @override
  String get errorLeadSave => 'リードを保存できませんでした。';

  @override
  String get errorIncomeLoad => '収入を読み込めませんでした。';

  @override
  String get errorIncomeDelete => '収入記録を削除できませんでした。';

  @override
  String get errorIncomeSave => '収入記録を保存できませんでした。';

  @override
  String get errorRemindersLoad => 'リマインダーを読み込めませんでした。';

  @override
  String get errorStatusUpdate => 'ステータスを更新できませんでした。';

  @override
  String get errorReminderDelete => 'リマインダーを削除できませんでした。';

  @override
  String get errorReminderAdd => 'リマインダーを追加できませんでした。';

  @override
  String get errorExportFailed => 'エクスポートに失敗しました。';

  @override
  String get errorFileRead => 'ファイルを読み込めませんでした。';

  @override
  String get errorImportFailed => 'インポートに失敗しました。';

  @override
  String get validationRequired => 'このフィールドは必須です。';

  @override
  String get validationEmail => '有効なメールアドレスを入力してください。';

  @override
  String get validationPhone => '有効な電話番号を入力してください。';

  @override
  String get validationAmountRequired => '金額は必須です。';

  @override
  String get validationAmountInvalid => '有効な金額を入力してください。';

  @override
  String get validationAmountPositive => '金額は0より大きくなければなりません。';

  @override
  String get validationSelectClient => 'クライアントを選択してください。';
}
