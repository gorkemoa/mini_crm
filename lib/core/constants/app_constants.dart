abstract class AppConstants {
  static const String appName = 'Mini CRM';
  static const String appVersion = '1.0.0';
  static const String exportVersion = '1';

  // Database
  static const String dbName = 'mini_crm.db';
  static const int dbVersion = 1;

  // Pagination
  static const int defaultPageSize = 50;

  // Supported currencies
  static const List<String> currencies = ['TRY', 'USD', 'EUR', 'GBP'];
  static const String defaultCurrency = 'TRY';

  // Lead sources
  static const List<String> leadSources = [
    'Instagram',
    'LinkedIn',
    'Referans',
    'Upwork',
    'Fiverr',
    'Web Sitesi',
    'Soğuk Arama',
    'Diğer',
  ];
}
