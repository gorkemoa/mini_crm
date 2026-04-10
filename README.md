# Freelancer Mini CRM — Flutter README

Swift hissiyatlı, sade, hızlı, temiz ve ileride backend entegrasyonuna uygun minimal CRM uygulaması.

---


///// KESİN YAPILACAK ASLA UNUTMA

# 🌍 Desteklenen Diller (Localization Strategy)

Bu uygulama, global erişim ve maksimum kullanıcı trafiği hedefiyle çok dilli (multi-language) olarak tasarlanmıştır.  
Aşağıdaki diller; nüfus, internet kullanımı ve mobil uygulama potansiyeline göre seçilmiştir.

---

## 🌐 Desteklenen Diller

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
- Tayca (Thai)  

---

## 📌 Lokalizasyon Kuralları

- Tüm metinler **localization dosyalarında** tutulmalıdır (View içinde hardcoded text yasak).
- Dil değişimi **anlık (runtime)** olmalıdır, uygulama yeniden başlatılmamalıdır.
- Tarih, para birimi ve sayı formatları locale’e göre değişmelidir.
- Sağdan sola (RTL) destek zorunludur:
  - Arapça
  - Urduca
  - Farsça

---

## 🧩 Flutter Teknik Yapı

Kullanılacak paketler:
- `flutter_localizations`
- `intl`

Önerilen yapı:
```text
lib/
  l10n/
    app_en.arb
    app_es.arb
    app_tr.arb
    app_ar.arb
    ...



# 1) Proje Özeti

Bu uygulama, serbest çalışanların gerçekten ihtiyaç duyduğu birkaç temel şeyi takip etmek için tasarlanır:

- Kim bana borçlu?
- Hangi proje ne zaman başlıyor?
- Hangi müşteri aktif, hangisi kaybedildi?
- Hangi platformdan ne kadar gelir geliyor?
- Hangi iş için tekrar takip yapılmalı?

Bu proje klasik CRM mantığını reddeder. Amaç; ekipler için karmaşık paneller değil, tek kişinin her gün açıp kullanacağı hızlı bir iş takip uygulaması oluşturmaktır.

---

# 2) Ürün Felsefesi

## Temel yaklaşım
- Gereksiz özellik yok
- Şişkin dashboard yok
- Karmaşık raporlama yok
- Önce hız, sadelik ve netlik
- Uygulama açıldığı anda kritik bilgi görünmeli

## Hedef kullanıcı
- Freelancer
- Tek başına çalışan geliştirici
- Tasarımcı
- Video editör
- Sosyal medya yöneticisi
- Danışman
- Küçük ajans sahibi ama bireysel düzende çalışan kişi

---

# 3) Tasarım Yaklaşımı

Uygulama Flutter ile geliştirilecek ancak his olarak SwiftUI / iOS native premium uygulama gibi davranmalıdır.

## UI/UX hedefleri
- Beyaz alan bol kullanılmalı
- Kalabalık ekran olmayacak
- Büyük başlıklar
- İnce ayırıcılar
- Kart yapısı temiz olacak
- Gereksiz border ve ağır gölge kullanılmayacak
- Renk sadece anlam taşıdığında kullanılacak
- Her ekranda tek ana amaç olacak
- Kullanıcı 2 tıklamada hedefe ulaşmalı

## Görsel karakter
- Apple benzeri minimal yaklaşım
- Yumuşak radius
- Sistem font hissiyatı
- Sessiz renk paleti
- Düşük görsel gürültü
- “Profesyonel ama sade” görünüm

---

# 4) Teknik Hedef

Bu proje **gerçek MVVM** ile kurulmalıdır. Kod tabanı ileride backend’e geçebilecek şekilde hazırlanmalıdır.

İlk sürüm:
- Offline-first
- Local database ile çalışır
- Kullanıcı verileri cihazda tutulur

Gelecek sürüm:
- Backend eklenebilir
- Sync sistemi eklenebilir
- Kullanıcı verileri export/import yapılabilir
- Hesap sistemi bağlanabilir
- Remote API katmanı doğrudan entegre edilebilir

Bu yüzden mimari en baştan sadece “local app” gibi değil, “yarın backend gelir” mantığıyla kurulmalıdır.

---

# 5) Zorunlu Mimari Kurallar

## Genel kurallar
- MVVM dışına çıkılmayacak
- View içinde veri işleme yapılmayacak
- View içinde fake business logic olmayacak
- Veri erişimi sadece service / repository üzerinden olacak
- Model katmanı net tanımlı olacak
- Her feature kendi içinde ayrılacak
- Tema yönetimi merkezi olacak
- Local ve remote veri kaynakları soyutlanacak
- İleride backend gelirse ekranlar bozulmadan entegre edilebilecek yapı kurulacak

## Katman sınırları
- `View`: sadece render + kullanıcı etkileşimi
- `ViewModel`: state yönetimi + ekran akışı + business orchestration
- `Service`: veri işlemleri, local storage, remote adapter, export/import, sync hazırlığı
- `Model`: veri yapıları
- `Theme`: tüm renk, boşluk, tipografi, radius ve component stilleri

---

# 6) Teknoloji Kararları

## Kullanılacak yapı
- Flutter
- Dart
- MVVM
- Local database: `Isar` veya `Hive`
- State management: `ChangeNotifier` veya `ValueNotifier` tabanlı sade yapı
- Dependency injection: basit service locator veya constructor injection
- JSON serialize: `json_serializable` veya manuel mapleme
- Routing: sade ve okunabilir yapı
- Export/import: JSON tabanlı ilk sürüm
- Future backend preparation: repository abstraction

## Neden bu yaklaşım?
Çünkü amaç hızlı, bakım yapılabilir, büyüyebilir ve kırılmadan backend’e geçebilir bir temel kurmaktır.

---

# 7) Klasör Yapısı

```text
lib/
  main.dart

  themes/
    app_colors.dart
    app_text_styles.dart
    app_spacing.dart
    app_radii.dart
    app_theme.dart
    app_shadows.dart

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
      secure_storage_service.dart
      file_export_service.dart
      file_import_service.dart
    repositories/
      client_repository.dart
      debt_repository.dart
      project_repository.dart
      lead_repository.dart
      income_repository.dart
      reminder_repository.dart
    sync/
      sync_service.dart
      sync_queue_service.dart
      sync_mapper_service.dart
    remote/
      remote_api_service.dart
      remote_auth_service.dart
      remote_sync_service.dart

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

  viewmodels/
    dashboard_viewmodel.dart
    clients_viewmodel.dart
    client_detail_viewmodel.dart
    debts_viewmodel.dart
    debt_form_viewmodel.dart
    projects_viewmodel.dart
    project_form_viewmodel.dart
    leads_viewmodel.dart
    lead_form_viewmodel.dart
    income_viewmodel.dart
    reminders_viewmodel.dart
    settings_viewmodel.dart

    8) Katmanların Görevleri
models

Sadece veri yapıları.
Örnek:

ClientModel
DebtModel
ProjectModel
LeadModel
IncomeModel
ReminderModel

Burada UI kodu bulunmaz.

views

Sadece arayüz.
Kurallar:

İş kuralı yazılmaz
Veri çekme mantığı yazılmaz
Direkt storage erişimi yapılmaz
Büyük hesaplama yapılmaz

View sadece ViewModel dinler ve kullanıcı aksiyonunu iletir.

viewmodels

Ekranın beyni.
Görevleri:

Ekran state’i tutmak
Service / repository çağrıları yapmak
Loading / error / empty state yönetmek
Form submit işlemlerini yürütmek
Liste filtreleme, sıralama, segment state yönetimi
View için hazır veri sunmak
services

Veri omurgası.
Görevleri:

Local DB işlemleri
Repository erişimi
Export / import
Sync hazırlığı
Remote API adaptasyonu
İleride backend geldiğinde veri akışını yönetmek

Buradaki yapı ileride local + remote hibrit çalışmaya uygun tasarlanmalıdır.

themes

Uygulamanın görsel merkezi.
Görevleri:

Renkler
Yazı stilleri
Boşluk sistemleri
Radius
Shadow
Buton / input / card davranışı

View içinde rastgele stil yazımı minimumda tutulmalıdır.

9) Domain Modelleri
ClientModel

Freelancer’ın müşteri kartı.

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

Alacak takibi.

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

Status:

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

Status:

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

Stage:

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

İleride hesap sistemi veya export/import için temel kullanıcı modeli.

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
10) Repository Mantığı

Repository katmanı local ve remote veri farkını gizlemelidir.

Örnek:

ClientRepository
DebtRepository
ProjectRepository
LeadRepository
IncomeRepository
ReminderRepository

Bu repository’ler ilk aşamada local database kullanır.
Gelecekte:

önce local oku
sonra remote sync et
conflict çöz
tekrar local güncelle

gibi senaryolar için genişletilebilir olmalıdır.

11) Local-First ve Gelecekte Backend’e Geçiş

Bu proje ilk günden backend zorunluluğu olmadan çalışmalıdır. Ancak veri katmanı, ileride online sisteme geçiş için bozulmadan büyüyebilmelidir.

İlk sürüm
Tüm veri local database’de
Kullanıcı internet olmadan kullanabilir
Export JSON ile veri indirilebilir
Import JSON ile geri yüklenebilir
İkinci sürüm
Kullanıcı hesabı
Cloud backup
Remote sync
Multi-device support
API tabanlı data restore
Mimari hazırlık

Bu yüzden şu ayrımlar baştan kurulmalıdır:

Local database service
Remote api service
Sync service
Queue service
Export/import service
Repository abstraction

Yani ilk sürüm local çalışsa bile klasör yapısında remote/ ve sync/ klasörleri bulunmalıdır.

12) Örnek Veri Akışı
Senaryo 1: Borç ekleme
Kullanıcı borç ekleme formunu açar
View form verisini toplar
ViewModel validasyon yapar
ViewModel DebtRepository.createDebt() çağırır
Repository local database service üzerinden kaydı oluşturur
ViewModel listeyi yeniler
View güncel state’i gösterir
Senaryo 2: Gelecekte backend ile aynı akış
Kullanıcı borç ekler
Repository local DB’ye hemen kaydeder
Sync queue içine işlem atılır
İnternet varsa remote sync service API’ye yollar
Başarılıysa sync status güncellenir

Bu yaklaşım uygulamanın offline-first kalmasını sağlar.

13) Ekran Listesi
1. Dashboard

Ana ekran.

Gösterilecek alanlar:

Toplam bekleyen alacak
Yaklaşan proje
Cevap bekleyen lead sayısı
Son gelir kaydı
Bugünkü hatırlatıcılar

Amaç:
Kullanıcı uygulamayı açtığında 5 saniyede genel durumu görmeli.

2. Clients View

Müşteri listesi.

İçerik:

Aktif müşteriler
Pasif müşteriler
Arama
Filtre
Hızlı detay geçişi
3. Client Detail View

Müşterinin tüm özet bilgisi.

İçerik:

İletişim bilgileri
Bu müşteriye ait borçlar
Aktif projeler
Kazanılan / kaybedilen lead geçmişi
Notlar
4. Debts View

Borç / alacak listesi.

İçerik:

Bekleyen
Geciken
Ödenen
Toplam tutar
Yaklaşan ödeme tarihi
5. Debt Form View

Yeni alacak ekleme veya düzenleme ekranı.

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
Devam edenler
Tamamlananlar
Proje tarihi
Bütçe
İlgili müşteri
7. Project Detail View

Tek projenin detay ekranı.

İçerik:

Proje açıklaması
Başlangıç / bitiş
İlgili müşteri
Durum
Bütçe
Notlar
8. Leads View

Potansiyel müşteri takibi.

İçerik:

Yeni lead
Teklif gönderildi
Görüşmede
Kazanıldı
Kaybedildi
9. Lead Form View

Lead oluşturma / düzenleme ekranı.

Alanlar:

İsim
Kaynak
Durum
Tahmini bütçe
Sonraki takip tarihi
Not
10. Income View

Gelir takibi.

İçerik:

Platform bazlı gelir
Müşteri bazlı gelir
Son kayıtlar
Toplam gelir
11. Reminders View

Takip hatırlatmaları.

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
Gelecekte hesap / sync alanı için hazır bölüm
14) Dashboard Kuralları

Dashboard karmaşık olmayacak.
Gösterilecek kart sayısı sınırlı olmalı.

Önerilen yapı:

Bekleyen alacak toplamı
Bu hafta başlayacak proje
Takip bekleyen lead
Bu ayki toplam gelir
Bugünkü hatırlatıcı

Grafik zorunlu değil.
İlk sürümde sade özet kartlar yeterlidir.

15) Durum Yapıları
Loading state

Her liste ekranında yüklenme durumu açıkça tanımlanmalı.

Empty state

Boş sayfalar kuru görünmemeli.
Örnek:

Henüz müşteri eklenmedi
İlk borcunu ekle
Henüz proje yok
Error state

Local-first app olduğu için hata az olur ancak import/export ve gelecekte sync için hata state’i gereklidir.

16) Tema Sistemi

Tema merkezi olmalıdır.

app_colors.dart

Uygulamadaki tüm renkler tek merkezde tanımlanır.

app_text_styles.dart

Başlık, alt başlık, body, caption, button stilleri burada olur.

app_spacing.dart

Tüm boşluk sistemi:

xs
sm
md
lg
xl
app_radii.dart

Kart, input, buton radius değerleri.

app_theme.dart

Light theme temel tanımı.

app_shadows.dart

Gölge kullanımı çok düşük ve kontrollü olmalı.

17) Swift Hissiyatı İçin Kurallar
Büyük başlık kullan
Section yapısını temiz ayır
Kartları düz ve sade yap
Input alanları geniş ve rahat olsun
Toolbar sade olsun
FAB varsa dikkatli kullan
Her yerde renkli ikon kullanma
Çok fazla chip / badge kullanma
Görsel gürültüyü sürekli azalt
Her sayfada ana eylem net olsun
18) ViewModel Standartları

Her ViewModel için ortak yaklaşım:

İçermesi gerekenler
isLoading
errorMessage
items
load()
refresh()
Form ekranlarında
field state
validation
submit
update mode / create mode ayrımı
Yasaklar
ViewModel içinde UI widget üretmek yok
BuildContext bağımlılığı minimum
Repository bypass etmek yok
19) Service Standartları
Local database service
CRUD işlemleri
Koleksiyon bazlı erişim
Batch işlemler
İndeks hazırlığı
File export service
Tüm veriyi JSON’a çevirme
Sürüm bilgisi ekleme
Geriye dönük uyumluluk alanı bırakma
File import service
JSON doğrulama
Model parse etme
Merge veya replace stratejisi desteği
Sync service

İlk sürümde aktif kullanılmasa da iskeleti bulunmalı.
Görev:

local changes tespiti
queue mantığı
push/pull senaryosu hazırlığı
Remote api service

Şimdilik placeholder olabilir ama klasörde bulunmalı.
Amaç:
Backend geldiğinde yeni mimari kurmak zorunda kalmamak.

20) Export / Import Yapısı

Bu proje ileride backend’e geçmese bile kullanıcının verisini dışa aktarabilmelidir.

Export
JSON format
Tüm tablolar tek pakette
Sürüm numarası içermeli
Oluşturulma tarihi içermeli
Import
Dosya seç
İçeriği parse et
Versiyon kontrolü yap
Uyumluysa içeri aktar
Hata varsa kullanıcıya net göster

Bu özellik hem güven verir hem de gelecekteki cloud sync için güçlü temel olur.

21) Backend’e Hazırlık Notları

İleride backend eklenirse aşağıdaki alanlar hazır olmalı:

local id + remote id ayrımı
createdAt / updatedAt tüm modellerde bulunmalı
deletedAt veya soft delete düşünülmeli
sync status alanı eklenebilir
conflict resolution stratejisi hazırlanmalı
export bundle schema version kullanılmalı

Örnek gelecek alanlar:

remoteId
syncStatus
lastSyncedAt
isDeleted

İlk sürümde bu alanlar zorunlu değil ama model tasarımı bunları kaldırabilmelidir.

22) Kod Kalitesi Kuralları
Kısa ve anlamlı dosyalar
Widget parçalama yapılmalı
500 satırlık ekran dosyaları olmamalı
Tek dosyada her şey toplanmamalı
Enum’lar net olmalı
Magic string kullanılmamalı
Tekrarlayan UI componentleri ortak widget yapılmalı
Format ve lint kuralları uygulanmalı
23) Yasaklar
View içinde database erişimi
View içinde repository çağrısı
Hardcoded demo veri ile ekran bağlamak
Service katmanını atlayıp direkt storage kullanmak
Theme dışında rastgele renk sistemi
Her feature için farklı tasarım dili
Future backend için hiçbir hazırlık yapmadan tamamen local’e gömülmek
24) MVP Kapsamı

İlk sürümde mutlaka olacaklar:

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

İlk sürümde olmayabilecekler:

Auth
Cloud sync
Push notification
Takvim entegrasyonu
Email entegrasyonu
Gelişmiş raporlama
Çoklu kullanıcı

26) Beklenen Sonuç

Ortaya çıkacak uygulama şu hissi vermelidir:

Karmaşık değil
Hafif
Hızlı
Premium
Güvenilir
Verim odaklı
Freelancer için yapılmış

Bu ürün bir “büyük şirket CRM’i” gibi görünmemeli.
Bir profesyonelin her gün açıp kullanacağı kişisel iş paneli gibi görünmelidir.

27) Son Teknik Talimat

Bu projeyi geliştirirken kod üretimi aşağıdaki prensiple ilerlemelidir:

Önce temel mimari
Sonra veri modeli
Sonra repository
Sonra viewmodel
Sonra view
Son olarak ince UI polish

Sıra bozulmamalıdır.

Amaç sadece çalışan ekranlar üretmek değildir.
Amaç; sürdürülebilir, sade, temiz, premium ve gelecekte backend’e geçebilecek doğru tabanı kurmaktır.




