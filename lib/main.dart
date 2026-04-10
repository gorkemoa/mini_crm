import 'package:flutter/material.dart';
import 'services/database/local_database_initializer.dart';
import 'services/database/local_database_service.dart';
import 'views/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalDatabaseInitializer.initialize();
  runApp(App(dbService: LocalDatabaseService()));
}
