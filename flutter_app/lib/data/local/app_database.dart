import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

/// Opens the offline cache database under the platform's app-data directory
/// (unlike the old LocalStorageService, which wrote to Directory.systemTemp
/// and could be wiped by the OS at any time).
class AppDatabase {
  AppDatabase._();
  static final AppDatabase instance = AppDatabase._();

  Database? _db;

  Future<Database> get db async {
    final existing = _db;
    if (existing != null) return existing;
    final dir = await getDatabasesPath();
    final dbPath = p.join(dir, 'udhar_khata_cache.db');
    final opened = await openDatabase(
      dbPath,
      version: 1,
      onCreate: _onCreate,
    );
    _db = opened;
    return opened;
  }

  static const entityTables = [
    'customers',
    'transactions',
    'orders',
    'chat_messages',
    'reminders',
  ];

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE shops (
        id TEXT PRIMARY KEY,
        owner_id TEXT NOT NULL,
        shop_name TEXT NOT NULL DEFAULT '',
        owner_name TEXT NOT NULL DEFAULT '',
        phone TEXT NOT NULL DEFAULT '',
        location TEXT NOT NULL DEFAULT '',
        address TEXT NOT NULL DEFAULT '',
        upi_id TEXT NOT NULL DEFAULT '',
        gstin TEXT NOT NULL DEFAULT '',
        email TEXT NOT NULL DEFAULT '',
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE customers (
        id TEXT PRIMARY KEY,
        shop_id TEXT NOT NULL,
        name TEXT NOT NULL,
        phone TEXT NOT NULL DEFAULT '',
        location TEXT NOT NULL DEFAULT '',
        risk_level TEXT NOT NULL DEFAULT 'Low',
        credit_limit REAL NOT NULL DEFAULT 15000,
        notes TEXT NOT NULL DEFAULT '',
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_customers_shop ON customers(shop_id)');

    await db.execute('''
      CREATE TABLE transactions (
        id TEXT PRIMARY KEY,
        shop_id TEXT NOT NULL,
        customer_id TEXT NOT NULL,
        type TEXT NOT NULL,
        amount REAL NOT NULL,
        note TEXT NOT NULL DEFAULT '',
        txn_date TEXT NOT NULL,
        payment_method TEXT NOT NULL DEFAULT 'Cash',
        reference TEXT NOT NULL DEFAULT '',
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_transactions_shop ON transactions(shop_id)');

    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        shop_id TEXT NOT NULL,
        customer_id TEXT NOT NULL,
        items_summary TEXT NOT NULL DEFAULT '',
        total_amount REAL NOT NULL,
        advance_paid REAL NOT NULL DEFAULT 0,
        status TEXT NOT NULL DEFAULT 'CONFIRMED',
        order_date TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_orders_shop ON orders(shop_id)');

    await db.execute('''
      CREATE TABLE chat_messages (
        id TEXT PRIMARY KEY,
        shop_id TEXT NOT NULL,
        customer_id TEXT NOT NULL,
        sender TEXT NOT NULL,
        message TEXT NOT NULL,
        message_type TEXT NOT NULL DEFAULT 'TEXT',
        sent_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_chat_shop ON chat_messages(shop_id)');

    await db.execute('''
      CREATE TABLE reminders (
        id TEXT PRIMARY KEY,
        shop_id TEXT NOT NULL,
        customer_id TEXT,
        title TEXT NOT NULL,
        amount REAL NOT NULL DEFAULT 0,
        due_date TEXT NOT NULL,
        reminder_type TEXT NOT NULL DEFAULT 'RECOVER_UDHAR',
        alert_option TEXT NOT NULL DEFAULT 'sameDay',
        is_settled INTEGER NOT NULL DEFAULT 0,
        note TEXT NOT NULL DEFAULT '',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_reminders_shop ON reminders(shop_id)');

    await db.execute('''
      CREATE TABLE pending_mutations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_table TEXT NOT NULL,
        entity_id TEXT NOT NULL,
        op TEXT NOT NULL,
        payload TEXT,
        created_at TEXT NOT NULL,
        attempt_count INTEGER NOT NULL DEFAULT 0,
        last_error TEXT
      )
    ''');
    await db.execute('CREATE INDEX idx_outbox_created ON pending_mutations(created_at)');

    await db.execute('CREATE TABLE sync_meta (key TEXT PRIMARY KEY, value TEXT)');
  }

  /// Wipes all cached rows and the outbox. Used on sign-out so the next
  /// signed-in user never sees a previous owner's cached data.
  Future<void> clearAll() async {
    final database = await db;
    await database.transaction((txn) async {
      for (final table in [...entityTables, 'shops', 'pending_mutations', 'sync_meta']) {
        await txn.delete(table);
      }
    });
  }

  /// Drops the on-disk cache file entirely, so the next [db] access runs
  /// [_onCreate] against the current schema. Tests call this once up front
  /// so a schema change doesn't fail against a stale file left by an
  /// earlier run of the suite; production code never calls this.
  @visibleForTesting
  Future<void> deleteForTests() async {
    await _db?.close();
    _db = null;
    final dir = await getDatabasesPath();
    final dbPath = p.join(dir, 'udhar_khata_cache.db');
    await databaseFactory.deleteDatabase(dbPath);
  }
}
