import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Mini CRM';

  @override
  String appVersion(String version) {
    return 'Sürüm $version';
  }

  @override
  String get navDashboard => 'Özet';

  @override
  String get navClients => 'Müşteriler';

  @override
  String get navLeads => 'Potansiyeller';

  @override
  String get navDebts => 'Alacaklar';

  @override
  String get navProjects => 'Projeler';

  @override
  String get navIncome => 'Gelirler';

  @override
  String get navReminders => 'Hatırlatıcılar';

  @override
  String get navSettings => 'Ayarlar';

  @override
  String get navMore => 'Daha Fazla';

  @override
  String get navFinance => 'Finans';

  @override
  String get actionAdd => 'Ekle';

  @override
  String get actionEdit => 'Düzenle';

  @override
  String get actionDelete => 'Sil';

  @override
  String get actionSave => 'Kaydet';

  @override
  String get actionCancel => 'İptal';

  @override
  String get actionBack => 'Geri';

  @override
  String get actionSearch => 'Ara';

  @override
  String get actionFilter => 'Filtrele';

  @override
  String get actionExport => 'Dışa Aktar';

  @override
  String get actionImport => 'İçe Aktar';

  @override
  String get actionClose => 'Kapat';

  @override
  String get actionConfirm => 'Onayla';

  @override
  String get actionDone => 'Tamam';

  @override
  String get actionMarkComplete => 'Tamamlandı Olarak İşaretle';

  @override
  String get actionMarkIncomplete => 'Tamamlanmadı Olarak İşaretle';

  @override
  String get actionViewAll => 'Tümünü Gör';

  @override
  String get actionRefresh => 'Yenile';

  @override
  String get labelName => 'Ad';

  @override
  String get labelTitle => 'Başlık';

  @override
  String get labelStatus => 'Durum';

  @override
  String get labelDate => 'Tarih';

  @override
  String get labelAmount => 'Tutar';

  @override
  String get labelCurrency => 'Para Birimi';

  @override
  String get labelNote => 'Not';

  @override
  String get labelNotes => 'Notlar';

  @override
  String get labelEmail => 'E-posta';

  @override
  String get labelPhone => 'Telefon';

  @override
  String get labelCompany => 'Şirket';

  @override
  String get labelSource => 'Kaynak';

  @override
  String get labelBudget => 'Bütçe';

  @override
  String get labelStartDate => 'Başlangıç Tarihi';

  @override
  String get labelEndDate => 'Bitiş Tarihi';

  @override
  String get labelDueDate => 'Son Ödeme Tarihi';

  @override
  String get labelCreatedAt => 'Oluşturulma';

  @override
  String get labelDescription => 'Açıklama';

  @override
  String get labelPlatform => 'Platform';

  @override
  String get labelClient => 'Müşteri';

  @override
  String get labelSelectClient => 'Müşteri Seç';

  @override
  String get labelNoClient => 'Müşteri Yok';

  @override
  String get labelOptional => 'İsteğe Bağlı';

  @override
  String get labelStage => 'Aşama';

  @override
  String get labelFollowUpDate => 'Takip Tarihi';

  @override
  String get labelEstimatedBudget => 'Tahmini Bütçe';

  @override
  String get labelReminderDate => 'Hatırlatıcı Tarihi';

  @override
  String get labelRelatedTo => 'İlgili';

  @override
  String get labelAll => 'Tümü';

  @override
  String get clientStatusActive => 'Aktif';

  @override
  String get clientStatusInactive => 'Pasif';

  @override
  String get clientStatusArchived => 'Arşivlendi';

  @override
  String get debtStatusPending => 'Bekliyor';

  @override
  String get debtStatusOverdue => 'Gecikmiş';

  @override
  String get debtStatusPaid => 'Ödendi';

  @override
  String get debtStatusPartial => 'Kısmi';

  @override
  String get projectStatusPlanned => 'Planlandı';

  @override
  String get projectStatusStartingSoon => 'Yakında Başlıyor';

  @override
  String get projectStatusActive => 'Aktif';

  @override
  String get projectStatusPaused => 'Duraklatıldı';

  @override
  String get projectStatusCompleted => 'Tamamlandı';

  @override
  String get projectStatusCancelled => 'İptal Edildi';

  @override
  String get leadStageNew => 'Yeni Lead';

  @override
  String get leadStageContacted => 'İletişime Geçildi';

  @override
  String get leadStageProposalSent => 'Teklif Gönderildi';

  @override
  String get leadStageNegotiating => 'Görüşme Aşamasında';

  @override
  String get leadStageWon => 'Kazanıldı';

  @override
  String get leadStageLost => 'Kaybedildi';

  @override
  String get dashboardTitle => 'Özet';

  @override
  String get dashboardPendingDebts => 'Bekleyen Alacaklar';

  @override
  String get dashboardOverdueDebts => 'Gecikmiş';

  @override
  String get dashboardProjectsThisWeek => 'Bu Hafta';

  @override
  String get dashboardLeadsToFollow => 'Takip Bekleyen';

  @override
  String get dashboardMonthlyIncome => 'Bu Ay';

  @override
  String get dashboardTodayReminders => 'Bugünün Hatırlatıcıları';

  @override
  String get dashboardActiveClients => 'Aktif Müşteriler';

  @override
  String get dashboardActiveProjects => 'Aktif Projeler';

  @override
  String get dashboardNoRemindersToday => 'Bugün hatırlatıcı yok';

  @override
  String get dashboardGoodMorning => 'Günaydın';

  @override
  String get dashboardOverview => 'İşte genel durumunuz';

  @override
  String get clientsTitle => 'Müşteriler';

  @override
  String get clientsEmpty => 'Henüz müşteri yok';

  @override
  String get clientsEmptyDesc => 'Başlamak için ilk müşterinizi ekleyin';

  @override
  String get clientsSearchHint => 'Müşteri ara...';

  @override
  String get clientAddTitle => 'Müşteri Ekle';

  @override
  String get clientEditTitle => 'Müşteri Düzenle';

  @override
  String get clientDetailTitle => 'Müşteri Detayı';

  @override
  String get clientFullName => 'Ad Soyad';

  @override
  String get clientCompanyName => 'Şirket Adı';

  @override
  String get clientDebts => 'Alacaklar';

  @override
  String get clientProjects => 'Projeler';

  @override
  String get clientTotalDebt => 'Toplam Alacak';

  @override
  String get clientActiveProjects => 'Aktif Projeler';

  @override
  String get debtsTitle => 'Alacaklar';

  @override
  String get debtsEmpty => 'Henüz alacak yok';

  @override
  String get debtsEmptyDesc => 'İlk alacak kaydınızı ekleyin';

  @override
  String get debtsSearchHint => 'Alacak ara...';

  @override
  String get debtsTotal => 'Toplam';

  @override
  String get debtsOverdue => 'Gecikmiş';

  @override
  String get debtsPending => 'Bekliyor';

  @override
  String get debtsPaid => 'Ödendi';

  @override
  String get debtsAddTitle => 'Alacak Ekle';

  @override
  String get debtsEditTitle => 'Alacak Düzenle';

  @override
  String get debtDetailTitle => 'Alacak Detayı';

  @override
  String get debtsClient => 'Müşteri';

  @override
  String get debtsTotalAmount => 'Toplam Tutar';

  @override
  String get debtsFilterAll => 'Tümü';

  @override
  String get debtsFilterPending => 'Bekleyenler';

  @override
  String get debtsFilterOverdue => 'Gecikenler';

  @override
  String get debtsFilterPaid => 'Ödenenler';

  @override
  String get projectsTitle => 'Projeler';

  @override
  String get projectsEmpty => 'Henüz proje yok';

  @override
  String get projectsEmptyDesc => 'İlk projenizi ekleyin';

  @override
  String get projectsSearchHint => 'Proje ara...';

  @override
  String get projectsAddTitle => 'Proje Ekle';

  @override
  String get projectsEditTitle => 'Proje Düzenle';

  @override
  String get projectDetailTitle => 'Proje Detayı';

  @override
  String get projectClient => 'Müşteri';

  @override
  String get projectBudget => 'Bütçe';

  @override
  String get projectDuration => 'Süre';

  @override
  String get leadsTitle => 'Potansiyel Müşteriler';

  @override
  String get leadsEmpty => 'Henüz lead yok';

  @override
  String get leadsEmptyDesc => 'Potansiyel müşteri takibine başlayın';

  @override
  String get leadsSearchHint => 'Lead ara...';

  @override
  String get leadsAddTitle => 'Lead Ekle';

  @override
  String get leadsEditTitle => 'Lead Düzenle';

  @override
  String get leadDetailTitle => 'Lead Detayı';

  @override
  String get leadsConversionRate => 'Kazanma Oranı';

  @override
  String get leadsTotal => 'Toplam Lead';

  @override
  String get incomeTitle => 'Gelirler';

  @override
  String get incomeEmpty => 'Henüz gelir kaydı yok';

  @override
  String get incomeEmptyDesc => 'Gelirinizi kaydetmeye başlayın';

  @override
  String get incomeSearchHint => 'Gelir ara...';

  @override
  String get incomeAddTitle => 'Gelir Ekle';

  @override
  String get incomeEditTitle => 'Gelir Düzenle';

  @override
  String get incomeTotal => 'Toplam Gelir';

  @override
  String get incomeThisMonth => 'Bu Ay';

  @override
  String get incomeDate => 'Gelir Tarihi';

  @override
  String get remindersTitle => 'Hatırlatıcılar';

  @override
  String get remindersEmpty => 'Hatırlatıcı yok';

  @override
  String get remindersEmptyDesc => 'Önemli görevler için hatırlatıcı ekleyin';

  @override
  String get remindersAddTitle => 'Hatırlatıcı Ekle';

  @override
  String get remindersEditTitle => 'Hatırlatıcı Düzenle';

  @override
  String get remindersToday => 'Bugün';

  @override
  String get remindersUpcoming => 'Yaklaşan';

  @override
  String get remindersOverdue => 'Gecikmiş';

  @override
  String get remindersCompleted => 'Tamamlanan';

  @override
  String get remindersAll => 'Tümü';

  @override
  String get settingsTitle => 'Ayarlar';

  @override
  String get settingsAppearance => 'Görünüm';

  @override
  String get settingsTheme => 'Tema';

  @override
  String get settingsLanguage => 'Dil';

  @override
  String get settingsData => 'Veri Yönetimi';

  @override
  String get settingsExport => 'Veriyi Dışa Aktar';

  @override
  String get settingsImport => 'Veri İçe Aktar';

  @override
  String get settingsAbout => 'Hakkında';

  @override
  String get settingsVersion => 'Uygulama Sürümü';

  @override
  String get settingsExportDesc => 'Tüm verileri JSON dosyası olarak dışa aktar';

  @override
  String get settingsImportDesc => 'JSON dosyasından veri içe aktar';

  @override
  String get themeLight => 'Açık';

  @override
  String get themeDark => 'Koyu';

  @override
  String get themeSystem => 'Sistem Varsayılanı';

  @override
  String get exportTitle => 'Veriyi Dışa Aktar';

  @override
  String get exportDesc => 'Verileriniz JSON dosyası olarak dışa aktarılacak. Bu dosyayı yedekleme veya geri yükleme için kullanabilirsiniz.';

  @override
  String get exportSuccess => 'Veriler başarıyla dışa aktarıldı';

  @override
  String get exportError => 'Dışa aktarma başarısız. Lütfen tekrar deneyin.';

  @override
  String get exportButton => 'JSON Olarak Aktar';

  @override
  String get importTitle => 'Veri İçe Aktar';

  @override
  String get importDesc => 'Mini CRM JSON dosyası seçin.';

  @override
  String get importSuccess => 'Veriler başarıyla içe aktarıldı';

  @override
  String get importError => 'İçe aktarma başarısız. Geçersiz veya bozuk dosya.';

  @override
  String get importWarning => 'İçe aktarma TÜM mevcut verilerin üzerine yazacak. Bu işlem geri alınamaz.';

  @override
  String get importButton => 'Dosya Seç';

  @override
  String get importReplace => 'Mevcut tüm verilerin üzerine yaz';

  @override
  String get deleteConfirmTitle => 'Sil';

  @override
  String get deleteConfirmMessage => 'Bu kaydı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.';

  @override
  String get deleteConfirmButton => 'Sil';

  @override
  String get validationRequired => 'Bu alan zorunludur';

  @override
  String get validationEmail => 'Geçerli bir e-posta adresi girin';

  @override
  String get validationAmount => 'Geçerli bir tutar girin';

  @override
  String get validationPositiveAmount => 'Tutar sıfırdan büyük olmalıdır';

  @override
  String get validationDateInvalid => 'Geçerli bir tarih seçin';

  @override
  String get errorGeneric => 'Bir şeyler yanlış gitti. Lütfen tekrar deneyin.';

  @override
  String get errorDatabase => 'Veritabanı hatası. Lütfen uygulamayı yeniden başlatın.';

  @override
  String get errorLoadFailed => 'Veriler yüklenemedi';

  @override
  String get errorSaveFailed => 'Kaydetme başarısız';

  @override
  String get errorDeleteFailed => 'Silme başarısız';

  @override
  String get currencyUSD => 'USD — Amerikan Doları';

  @override
  String get currencyEUR => 'EUR — Euro';

  @override
  String get currencyTRY => 'TRY — Türk Lirası';

  @override
  String get currencyGBP => 'GBP — İngiliz Sterlini';

  @override
  String get currencyJPY => 'JPY — Japon Yeni';

  @override
  String get currencyCNY => 'CNY — Çin Yuanı';

  @override
  String get currencyINR => 'INR — Hint Rupisi';

  @override
  String get currencyBRL => 'BRL — Brezilya Reali';

  @override
  String get currencyAUD => 'AUD — Avustralya Doları';

  @override
  String get currencyCAD => 'CAD — Kanada Doları';

  @override
  String get reminderRelatedClient => 'Müşteri';

  @override
  String get reminderRelatedDebt => 'Alacak';

  @override
  String get reminderRelatedProject => 'Proje';

  @override
  String get reminderRelatedLead => 'Lead';

  @override
  String get reminderRelatedIncome => 'Gelir';

  @override
  String get reminderRelatedGeneral => 'Genel';

  @override
  String daysOverdue(int days) {
    return '$days gün gecikmiş';
  }

  @override
  String daysRemaining(int days) {
    return '$days gün kaldı';
  }

  @override
  String get dueToday => 'Bugün son gün';

  @override
  String get dueTomorrow => 'Yarın son gün';
}
