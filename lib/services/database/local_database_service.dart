import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';

class LocalDatabaseService {
  static final LocalDatabaseService _instance =
      LocalDatabaseService._internal();
  factory LocalDatabaseService() => _instance;
  LocalDatabaseService._internal();

  Database? _db;

  Database get db {
    assert(_db != null, 'Database not initialized. Call init() first.');
    return _db!;
  }

  Future<void> init() async {
    if (_db != null) return;
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, AppConstants.dbName);
    _db = await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE clients (
        id TEXT PRIMARY KEY,
        full_name TEXT NOT NULL,
        company_name TEXT,
        email TEXT,
        phone TEXT,
        notes TEXT,
        status TEXT NOT NULL DEFAULT 'active',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE debts (
        id TEXT PRIMARY KEY,
        client_id TEXT NOT NULL,
        title TEXT NOT NULL,
        amount REAL NOT NULL,
        currency TEXT NOT NULL DEFAULT 'TRY',
        due_date TEXT,
        status TEXT NOT NULL DEFAULT 'pending',
        note TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES clients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE projects (
        id TEXT PRIMARY KEY,
        client_id TEXT NOT NULL,
        title TEXT NOT NULL,
        description TEXT,
        start_date TEXT,
        end_date TEXT,
        budget REAL,
        currency TEXT NOT NULL DEFAULT 'TRY',
        status TEXT NOT NULL DEFAULT 'planned',
        note TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES clients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE leads (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        source TEXT,
        stage TEXT NOT NULL DEFAULT 'newLead',
        estimated_budget REAL,
        currency TEXT NOT NULL DEFAULT 'TRY',
        next_follow_up_date TEXT,
        note TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE incomes (
        id TEXT PRIMARY KEY,
        source_platform TEXT,
        client_id TEXT,
        amount REAL NOT NULL,
        currency TEXT NOT NULL DEFAULT 'TRY',
        date TEXT NOT NULL,
        note TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (client_id) REFERENCES clients(id)
      )
    ''');

    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        title TEXT NOT NULL,
        related_type TEXT NOT NULL DEFAULT 'general',
        related_id TEXT,
        reminder_date TEXT NOT NULL,
        is_completed INTEGER NOT NULL DEFAULT 0,
        note TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE app_user (
        id TEXT PRIMARY KEY,
        display_name TEXT,
        email TEXT,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Indexes for performance
    await db.execute('CREATE INDEX idx_debts_client ON debts(client_id)');
    await db.execute('CREATE INDEX idx_debts_status ON debts(status)');
    await db.execute('CREATE INDEX idx_projects_client ON projects(client_id)');
    await db.execute('CREATE INDEX idx_projects_status ON projects(status)');
    await db.execute('CREATE INDEX idx_leads_stage ON leads(stage)');
    await db.execute('CREATE INDEX idx_incomes_date ON incomes(date)');
    await db.execute('CREATE INDEX idx_reminders_date ON reminders(reminder_date)');
    await db.execute('CREATE INDEX idx_reminders_completed ON reminders(is_completed)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Future migration handling goes here
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
