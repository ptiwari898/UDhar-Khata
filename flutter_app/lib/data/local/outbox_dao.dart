import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

class PendingMutation {
  final int id;
  final String table;
  final String entityId;
  final String op; // INSERT, UPDATE, DELETE
  final Map<String, dynamic>? payload;

  PendingMutation({
    required this.id,
    required this.table,
    required this.entityId,
    required this.op,
    required this.payload,
  });

  factory PendingMutation.fromRow(Map<String, dynamic> row) => PendingMutation(
        id: row['id'] as int,
        table: row['entity_table'] as String,
        entityId: row['entity_id'] as String,
        op: row['op'] as String,
        payload: row['payload'] != null
            ? jsonDecode(row['payload'] as String) as Map<String, dynamic>
            : null,
      );
}

/// FIFO queue of local writes waiting to be pushed to Supabase. Ordering is
/// global (not per-entity) so a transient failure stops the whole flush and
/// retries in the same order next cycle, rather than reordering writes.
class OutboxDao {
  Future<void> enqueue(String table, String entityId, String op, Map<String, dynamic>? payload) async {
    final db = await AppDatabase.instance.db;
    await db.insert('pending_mutations', {
      'entity_table': table,
      'entity_id': entityId,
      'op': op,
      'payload': payload != null ? jsonEncode(payload) : null,
      'created_at': DateTime.now().toIso8601String(),
      'attempt_count': 0,
    });
  }

  Future<List<PendingMutation>> getAllOrdered() async {
    final db = await AppDatabase.instance.db;
    final rows = await db.query('pending_mutations', orderBy: 'created_at ASC, id ASC');
    return rows.map(PendingMutation.fromRow).toList();
  }

  Future<void> markFailed(int id, String error) async {
    final db = await AppDatabase.instance.db;
    await db.rawUpdate(
      'UPDATE pending_mutations SET attempt_count = attempt_count + 1, last_error = ? WHERE id = ?',
      [error, id],
    );
  }

  Future<void> delete(int id) async {
    final db = await AppDatabase.instance.db;
    await db.delete('pending_mutations', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> pendingCount() async {
    final db = await AppDatabase.instance.db;
    final result = await db.rawQuery('SELECT COUNT(*) AS c FROM pending_mutations');
    return result.first['c'] as int;
  }
}

/// Per-table "last pulled at" cursors, used by [SyncService.pullRemoteChanges].
class SyncMetaDao {
  Future<DateTime?> getCursor(String table) async {
    final db = await AppDatabase.instance.db;
    final rows = await db.query('sync_meta', where: 'key = ?', whereArgs: ['last_pulled_at:$table']);
    if (rows.isEmpty) return null;
    return DateTime.tryParse(rows.first['value'] as String);
  }

  Future<void> setCursor(String table, DateTime value) async {
    final db = await AppDatabase.instance.db;
    await db.insert(
      'sync_meta',
      {'key': 'last_pulled_at:$table', 'value': value.toIso8601String()},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}
