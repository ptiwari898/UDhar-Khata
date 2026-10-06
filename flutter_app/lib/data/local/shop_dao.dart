import 'package:sqflite/sqflite.dart';
import 'app_database.dart';

/// `shops` is keyed by owner_id rather than shop_id, so it gets its own
/// small dao instead of sharing [EntityDao].
class ShopDao {
  Future<void> upsertLocal(Map<String, dynamic> row) async {
    final db = await AppDatabase.instance.db;
    await db.insert('shops', row, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getForOwner(String ownerId) async {
    final db = await AppDatabase.instance.db;
    final rows = await db.query(
      'shops',
      where: 'owner_id = ? AND deleted_at IS NULL',
      whereArgs: [ownerId],
      limit: 1,
    );
    return rows.isEmpty ? null : rows.first;
  }
}
