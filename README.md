# Mini CRM — Flutter

Freelancerlar, bireysel çalışanlar ve küçük ekipler için tasarlanmış; sade, hızlı ve modern bir mini CRM uygulaması.

Amaç; karmaşık kurumsal CRM panelleri yapmak değil, kullanıcının her gün açıp işlerini net biçimde takip edebileceği düzenli bir mobil araç oluşturmaktır.

---

# 1. Ürün Özeti

Mini CRM, günlük iş akışında gerçekten gerekli olan temel takibi tek yerde toplar:

- Müşteri yönetimi
- Alacak / ödeme takibi
- Proje takibi
- Potansiyel müşteri takibi
- Gelir kayıtları
- Hatırlatıcılar
- Veri dışa aktarma / içe aktarma

Bu uygulama şunları hedefler:

- Hızlı kullanım
- Düşük karmaşa
- Temiz arayüz
- Offline-first çalışma
- İleride backend entegrasyonuna hazır mimari

---

# 2. Ürün Felsefesi

## Temel yaklaşım

Bu proje klasik ağır CRM mantığıyla tasarlanmaz.

Odak noktası:

- Gereksiz özelliklerden kaçınmak
- Kalabalık dashboard yapmamak
- Kullanıcıyı veriyle boğmamak
- En kritik bilgiyi ilk bakışta göstermek
- Günlük kullanımı hızlandırmak

## Hedef kullanıcı

- Freelancer
- Tek başına çalışan geliştirici
- Tasarımcı
- Video editör
- Danışman
- Sosyal medya yöneticisi
- Küçük ölçekli hizmet veren profesyoneller

---

# 3. Tasarım Yönü

Uygulama Flutter ile geliştirilecek, ancak görsel yaklaşımı modern, temiz ve profesyonel bir mini CRM gibi olmalıdır.

## UI/UX hedefleri

- Düzenli ve sakin ekranlar
- Bol beyaz alan
- Net hiyerarşi
- Gereksiz görsel gürültü yok
- Kart yapıları sade ve işlevsel
- Tek ekranda tek ana amaç
- Az ama anlamlı renk kullanımı
- Hızlı okunabilir tipografi
- Mobilde tek elle rahat kullanım

## Arayüz karakteri

- Modern
- Minimal
- Kurumsal ama soğuk olmayan
- Derli toplu
- Hızlı algılanan
- Veri odaklı ama sade

---

# 4. Desteklenen Diller

Bu uygulama global trafik ve geniş kullanıcı kitlesi hedefiyle çok dilli tasarlanacaktır.

## Desteklenecek diller

- İngilizce
- Basitleştirilmiş Çince
- İspanyolca
- Arapça
- Hintçe
- Portekizce
- Fransızca
- Endonezce
- Japonca
- Almanca
- Rusça
- Türkçe
- Korece
- Bengalce
- Urduca
- Vietnamca
- İtalyanca
- Farsça
- Lehçe
- Tayca

## Lokalizasyon kuralları

- Tüm metinler localization dosyalarında tutulmalı
- View içinde hardcoded text kullanılmamalı
- Dil değişimi runtime desteklemeli
- Tarih, sayı ve para formatları locale’e göre değişmeli
- RTL destek zorunlu:
  - Arapça
  - Urduca
  - Farsça

## Flutter localization yapısı

Kullanılacak paketler:

- `flutter_localizations`
- `intl`

Önerilen yapı:

```text
lib/
  l10n/
    app_en.arb
    app_tr.arb
    app_es.arb
    app_ar.arb
    app_fr.arb
    ...
    5. Teknik Hedef

Bu proje gerçek anlamda MVVM mimarisiyle kurulmalıdır.

İlk sürüm:

Offline-first çalışır
Veriler cihazda tutulur
Local database kullanır
İnternetsiz temel kullanım mümkündür

İleride eklenebilecek yapı:

Backend entegrasyonu
Kullanıcı hesabı
Senkronizasyon
Çoklu cihaz desteği
Cloud backup
Remote API bağlantısı

Mimari, ilk sürüm local çalışsa bile gelecekte online sisteme geçişi bozmayacak şekilde kurulmalıdır.

6. Zorunlu Mimari Kurallar
Genel kurallar
MVVM dışına çıkılmayacak
View içinde iş kuralı yazılmayacak
View içinde veri işleme yapılmayacak
Veri erişimi yalnızca service / repository üzerinden olacak
Tema yönetimi merkezi olacak
Local ve remote veri kaynakları ayrıştırılacak
Gelecekte backend geldiğinde ekranlar yeniden yazılmayacak
Katman sorumlulukları
View
Sadece arayüz
Kullanıcı etkileşimi
ViewModel dinleme
ViewModel
State yönetimi
İş akışı
Form kontrolü
Listeleme, filtreleme, sıralama
Hata / loading / empty state yönetimi
Service
Veri işlemleri
Local database erişimi
Export / import
Sync hazırlığı
Remote servis adaptasyonu
Model
Veri yapıları
Entity tanımları
Enum ve tipler
Theme
Renkler
Yazı stilleri
Boşluk sistemi
Radius
Component stilleri
7. Teknoloji Kararları
Kullanılacak yapı
Flutter
Dart
MVVM
Local database: Isar veya Hive
State management: ChangeNotifier veya ValueNotifier
Dependency injection: constructor injection veya sade service locator
JSON dönüşümleri: json_serializable veya kontrollü manuel mapleme
Export / import: JSON tabanlı yapı
Repository abstraction ile future backend hazırlığı
Ana prensip

Amaç sadece çalışan bir uygulama yapmak değildir.

Amaç:

Bakımı kolay
Büyüyebilir
Modüler
Temiz
Geleceğe hazır

bir temel kurmaktır.

8. Klasör Yapısı
lib/
  main.dart

  themes/
    app_colors.dart
    app_text_styles.dart
    app_spacing.dart
    app_radii.dart
    app_theme.dart

  core/
    constants/
      app_constants.dart
      storage_keys.dart
      route_names.dart
    utils/
      date_utils.dart
      currency_utils.dart
      id_utils.dart
      validators.dart
    errors/
      app_exceptions.dart
      app_failures.dart
    base/
      base_viewmodel.dart
      result.dart

  models/
    client_model.dart
    debt_model.dart
    project_model.dart
    lead_model.dart
    income_model.dart
    reminder_model.dart
    app_user_model.dart
    export_bundle_model.dart

  services/
    database/
      local_database_service.dart
      local_database_initializer.dart
    storage/
      file_export_service.dart
      file_import_service.dart
      secure_storage_service.dart
    repositories/
      client_repository.dart
      debt_repository.dart
      project_repository.dart
      lead_repository.dart
      income_repository.dart
      reminder_repository.dart
    remote/
      remote_api_service.dart
      remote_auth_service.dart
      remote_sync_service.dart
    sync/
      sync_service.dart
      sync_queue_service.dart
      sync_mapper_service.dart

  viewmodels/
    dashboard_viewmodel.dart
    clients_viewmodel.dart
    client_detail_viewmodel.dart
    client_form_viewmodel.dart
    debts_viewmodel.dart
    debt_form_viewmodel.dart
    projects_viewmodel.dart
    project_form_viewmodel.dart
    leads_viewmodel.dart
    lead_form_viewmodel.dart
    income_viewmodel.dart
    income_form_viewmodel.dart
    reminders_viewmodel.dart
    settings_viewmodel.dart

  views/
    app/
      app.dart
      app_router.dart
    dashboard/
      dashboard_view.dart
    clients/
      clients_view.dart
      client_detail_view.dart
      client_form_view.dart
    debts/
      debts_view.dart
      debt_detail_view.dart
      debt_form_view.dart
    projects/
      projects_view.dart
      project_detail_view.dart
      project_form_view.dart
    leads/
      leads_view.dart
      lead_detail_view.dart
      lead_form_view.dart
    income/
      income_view.dart
      income_form_view.dart
    reminders/
      reminders_view.dart
    settings/
      settings_view.dart
      export_data_view.dart
      import_data_view.dart
    widgets/
      app_scaffold.dart
      app_card.dart
      section_header.dart
      empty_state.dart
      status_badge.dart
      primary_button.dart
      search_field.dart
      info_row.dart
9. Domain Modelleri
ClientModel

Müşteri kartı.

Alanlar:

id
fullName
companyName
email
phone
notes
status
createdAt
updatedAt
DebtModel

Alacak / ödeme takibi.

Alanlar:

id
clientId
title
amount
currency
dueDate
status
note
createdAt
updatedAt

Durumlar:

pending
overdue
paid
partial
ProjectModel

Proje takibi.

Alanlar:

id
clientId
title
description
startDate
endDate
budget
currency
status
note
createdAt
updatedAt

Durumlar:

planned
startingSoon
active
paused
completed
cancelled
LeadModel

Potansiyel müşteri takibi.

Alanlar:

id
name
source
stage
estimatedBudget
nextFollowUpDate
note
createdAt
updatedAt

Aşamalar:

newLead
contacted
proposalSent
negotiating
won
lost
IncomeModel

Gelir kayıtları.

Alanlar:

id
sourcePlatform
clientId
amount
currency
date
note
createdAt
updatedAt
ReminderModel

Hatırlatıcılar.

Alanlar:

id
title
relatedType
relatedId
reminderDate
isCompleted
note
createdAt
updatedAt
AppUserModel

İleride hesap, backup veya sync için temel kullanıcı modeli.

Alanlar:

id
displayName
email
createdAt
updatedAt
ExportBundleModel

Tüm uygulama verilerini tek paket halinde dışa aktarmak için.

Alanlar:

appVersion
exportDate
clients
debts
projects
leads
incomes
reminders
user
10. Repository Yapısı

Repository katmanı local ve remote veri farkını gizlemelidir.

Örnek repository’ler:

ClientRepository
DebtRepository
ProjectRepository
LeadRepository
IncomeRepository
ReminderRepository

İlk aşamada local database üzerinden çalışırlar.

İleride şu senaryolar desteklenebilir:

Önce local oku
Sonra remote senkronize et
Çakışma çöz
Local veriyi güncelle

Bu yüzden repository yapısı baştan genişleyebilir tasarlanmalıdır.

11. Local-First Yaklaşım
İlk sürüm
Tüm veri local database’de tutulur
İnternetsiz kullanım desteklenir
Export ile JSON alınabilir
Import ile veri geri yüklenebilir
Gelecek sürüm
Login / hesap sistemi
Cloud backup
Çoklu cihaz kullanımı
Remote sync
API tabanlı veri geri yükleme
Mimari hazırlık

Bu nedenle aşağıdaki katmanlar baştan düşünülmelidir:

Local database service
Remote API service
Sync service
Queue service
Export / import service
Repository abstraction
12. Örnek Veri Akışı
Senaryo 1: Alacak ekleme
Kullanıcı alacak formunu açar
View input verilerini toplar
ViewModel validasyon yapar
ViewModel DebtRepository.createDebt() çağırır
Repository local database’e kaydeder
ViewModel state’i günceller
View yeni listeyi gösterir
Senaryo 2: Gelecekte backend ile
Kullanıcı kayıt ekler
Repository veriyi önce local’e yazar
Sync queue içine işlem eklenir
İnternet varsa remote servise gönderilir
Başarılıysa sync durumu güncellenir
13. Ekran Listesi
1. Dashboard

Ana özet ekranı.

Gösterilecek temel alanlar:

Bekleyen alacak toplamı
Bu hafta başlayacak proje
Takip bekleyen lead sayısı
Son gelir bilgisi
Bugünkü hatırlatıcılar

Amaç:
Kullanıcı uygulamayı açınca birkaç saniyede durumunu görmelidir.

2. Clients View

Müşteri listesi.

İçerik:

Aktif müşteriler
Pasif müşteriler
Arama
Filtreleme
Hızlı detay geçişi
3. Client Detail View

Tek müşteri özeti.

İçerik:

İletişim bilgileri
Bu müşteriye ait borçlar
Aktif projeler
Geçmiş notlar
İlişkili kayıtlar
4. Debts View

Alacak listesi.

İçerik:

Bekleyenler
Gecikenler
Ödenenler
Toplam tutar
Yaklaşan ödeme tarihleri
5. Debt Form View

Yeni alacak ekleme / düzenleme ekranı.

Alanlar:

Müşteri
Başlık
Tutar
Para birimi
Son ödeme tarihi
Not
Durum
6. Projects View

Proje listesi.

İçerik:

Başlayacak projeler
Aktif projeler
Tamamlananlar
Bütçe
Tarihler
Müşteri bilgisi
7. Project Detail View

Proje detay ekranı.

İçerik:

Açıklama
Başlangıç / bitiş
Bütçe
Durum
Notlar
İlişkili müşteri
8. Leads View

Potansiyel müşteri takibi.

İçerik:

Yeni lead
İletişime geçildi
Teklif gönderildi
Görüşme aşaması
Kazanıldı
Kaybedildi
9. Lead Form View

Lead oluşturma / düzenleme.

Alanlar:

İsim
Kaynak
Durum
Tahmini bütçe
Sonraki takip tarihi
Not
10. Income View

Gelir ekranı.

İçerik:

Platform bazlı gelir
Müşteri bazlı gelir
Son eklenen kayıtlar
Toplam gelir
11. Reminders View

Hatırlatıcı ekranı.

İçerik:

Bugün
Yaklaşan
Geciken
Tamamlanan
12. Settings View

Ayarlar ve veri yönetimi.

İçerik:

Tema tercihleri
Veri dışa aktar
Veri içe aktar
Uygulama sürümü
Gelecekte sync alanı için hazır bölüm
14. Dashboard Kuralları

Dashboard sade kalmalıdır.

İlk sürümde amaç grafik doldurmak değil, net özet sunmaktır.

Önerilen kartlar:

Bekleyen alacak toplamı
Bu hafta başlayacak proje
Takip bekleyen lead
Bu ay toplam gelir
Bugünkü hatırlatıcı

Not:
İlk sürümde karmaşık grafik zorunlu değildir.

15. State Yönetimi

Her liste ve form ekranında aşağıdaki durumlar açıkça tanımlanmalıdır:

Loading state
Veri yükleniyor
Form submit ediliyor
Import / export işleniyor
Empty state

Boş ekranlar açıklayıcı olmalı.

Örnek:

Henüz müşteri eklenmedi
İlk alacağını ekle
Henüz proje bulunmuyor
Takip bekleyen kayıt yok
Error state

Özellikle import / export ve gelecekte sync süreçleri için hata yönetimi net olmalıdır.

16. Tema Sistemi

Tema tek merkezden yönetilmelidir.

app_colors.dart

Uygulamadaki tüm renkler burada tanımlanır.

app_text_styles.dart

Başlık, gövde, açıklama ve buton yazı stilleri burada bulunur.

app_spacing.dart

Boşluk sistemi:

xs
sm
md
lg
xl
app_radii.dart

Kart, input ve buton radius değerleri.

app_theme.dart

Light theme ve temel component davranışları.

Tasarım kuralları
Sert kontrastlardan kaçın
Renk sadece anlam taşıyorsa kullan
Gölge çok kontrollü olmalı
Kartlar sade olmalı
Border kullanımı abartılmamalı
Görsel düzen tutarlı kalmalı
17. ViewModel Standartları

Her ViewModel aşağıdaki ortak yapıya yakın ilerlemelidir:

İçermesi gerekenler
isLoading
errorMessage
items / state
load()
refresh()
Form ekranlarında
field state
validation
submit()
create / update ayrımı
Yasaklar
Widget üretmek
View logic taşımak
Repository katmanını atlamak
Gereksiz BuildContext bağımlılığı
18. Service Standartları
Local database service
CRUD işlemleri
Koleksiyon bazlı erişim
Batch işlemler
Performans odaklı sorgular
File export service
Tüm veriyi JSON’a dönüştürme
Sürüm bilgisi ekleme
Geriye dönük uyumluluk alanı bırakma
File import service
JSON doğrulama
Model parse etme
Merge veya replace desteği
Sync service

İlk sürümde aktif olmayabilir ama iskeleti bulunmalıdır.

Hazırlanacak konular:

Local değişiklik tespiti
Queue mantığı
Push / pull akışı
Çakışma çözüm altyapısı
Remote API service

Şimdilik placeholder olabilir.
Ama klasörde ve mimaride yeri baştan ayrılmalıdır.

19. Export / Import Yapısı

Bu uygulama veriyi kullanıcıya ait hissettirmelidir.

Bu yüzden export / import temel özellik olarak düşünülmelidir.

Export
JSON formatı
Tüm veriler tek pakette
Sürüm bilgisi içermeli
Oluşturulma tarihi içermeli
Import
Dosya seçimi
İçeriği parse etme
Versiyon kontrolü
Uyumluysa içe aktarma
Hata varsa kullanıcıya net açıklama
20. Backend’e Hazırlık Notları

İleride backend eklenirse aşağıdaki yapılar desteklenebilir olmalı:

localId + remoteId ayrımı
createdAt / updatedAt alanları
syncStatus
lastSyncedAt
isDeleted veya soft delete desteği
conflict resolution mantığı
export schema version

Bu alanlar ilk sürümde şart olmasa da model yapısı buna engel olmamalıdır.

21. Kod Kalitesi Kuralları
Kısa ve anlamlı dosyalar
Büyük ekranları widget’lara bölmek
500+ satırlık tek ekran dosyalarından kaçınmak
Tekrarlayan UI parçalarını ortak widget yapmak
Magic string kullanmamak
Enum ve model yapısını net tutmak
Format ve lint kurallarını uygulamak
22. Yasaklar
View içinde database erişimi
View içinde repository çağrısı
Service katmanını bypass etmek
Hardcoded demo veri ile ekran bağlamak
Theme dışında rastgele renk kullanmak
Feature bazında kopuk tasarım dili oluşturmak
Future backend hazırlığını tamamen yok saymak
23. MVP Kapsamı
İlk sürümde mutlaka olacaklar
Client yönetimi
Debt yönetimi
Project yönetimi
Lead yönetimi
Income kayıtları
Reminder sistemi
Dashboard
Settings
Export / import temel yapısı
Local storage
İlk sürümde olmayabilecekler
Auth
Cloud sync
Push notification
Takvim entegrasyonu
Email entegrasyonu
Gelişmiş raporlama
Çoklu kullanıcı yapısı
24. Beklenen Sonuç

Ortaya çıkacak uygulama şu hissi vermelidir:

Hafif
Hızlı
Düzenli
Modern
Güvenilir
Verim odaklı
Günlük kullanıma uygun

Bu ürün büyük şirket CRM’i gibi değil, profesyonelin cebindeki kişisel iş paneli gibi görünmelidir.

25. Geliştirme Sırası

Kod üretimi şu sırayla ilerlemelidir:

Temel mimari
Tema sistemi
Veri modelleri
Repository katmanı
Service katmanı
ViewModel yapısı
View ekranları
Form akışları
Export / import
Son UI polish

Bu sıra bozulmamalıdır.

26. Son Talimat

Amaç sadece birkaç ekran üretmek değildir.

Amaç:

temiz
sürdürülebilir
modern
derli toplu
premium hissiyatlı
gelecekte backend’e geçebilecek

bir mini CRM temeli kurmaktır.