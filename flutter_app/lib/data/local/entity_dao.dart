import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

/// Shared CRUD against one shop-scoped cache table. All five entity tables
/// (customers, transactions, orders, chat_messages, reminders) share the
/// same shape — uuid `id`, `shop_id`, `updated_at`, `deleted_at` — so one
/// dao parameterized by table name replaces five near-identical classes.
class EntityDao {
  EntityDao(this.table);

  final String table;

  Future<void> upsertLocal(Map<String, dynamic> row) async {
    final db = await AppDatabase.instance.db;
    await db.insert(table, _sqliteSafe(row), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// sqlite has no boolean type — sqflite rejects Dart `bool` values
  /// outright, while Supabase (Postgres) expects real booleans. Rows come
  /// from `Model.toJson()`, shared by both targets, so this converts a copy
  /// rather than mutating the map the caller also sends to Supabase.
  Map<String, dynamic> _sqliteSafe(Map<String, dynamic> row) {
    return row.map((key, value) => MapEntry(key, value is bool ? (value ? 1 : 0) : value));
  }

  Future<List<Map<String, dynamic>>> getAll(String shopId) async {
    final db = await AppDatabase.instance.db;
    return db.query(
      table,
      where: 'shop_id = ? AND deleted_at IS NULL',
      whereArgs: [shopId],
    );
  }

  Future<void> hardDeleteLocal(String id) async {
    final db = await AppDatabase.instance.db;
    await db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  /// Marks a row deleted locally (optimistic) without waiting for sync.
  Future<void> softDeleteLocal(String id, DateTime at) async {
    final db = await AppDatabase.instance.db;
    await db.update(
      table,
      {'deleted_at': at.toIso8601String(), 'updated_at': at.toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
