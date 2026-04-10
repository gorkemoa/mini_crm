import 'local_database_service.dart';

class LocalDatabaseInitializer {
  static Future<void> initialize() async {
    await LocalDatabaseService().init();
  }
}
