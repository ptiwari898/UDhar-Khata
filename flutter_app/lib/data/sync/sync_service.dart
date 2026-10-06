import 'package:postgrest/postgrest.dart';

import '../local/entity_dao.dart';
import '../local/outbox_dao.dart';
import '../remote/supabase_client.dart';

/// Pushes queued offline writes to Supabase, then pulls anything that
/// changed remotely since the last pull. Conflict resolution is
/// last-write-wins: a pull always overwrites the local row with whatever
/// the server has, and `updated_at` is stamped server-side so clock skew
/// between devices can't flip who "wins".
class SyncService {
  SyncService({
    required SupabaseClientWrapper remote,
    required OutboxDao outbox,
    required SyncMetaDao syncMeta,
    required Map<String, EntityDao> daos,
  })  : _remote = remote,
        _outbox = outbox,
        _syncMeta = syncMeta,
        _daos = daos;

  final SupabaseClientWrapper _remote;
  final OutboxDao _outbox;
  final SyncMetaDao _syncMeta;
  final Map<String, EntityDao> _daos;

  bool _flushing = false;
  bool _syncing = false;

  Future<void> flushOutbox() async {
    if (_flushing) return;
    _flushing = true;
    try {
      final pending = await _outbox.getAllOrdered();
      for (final mutation in pending) {
        try {
          switch (mutation.op) {
            case 'INSERT':
            case 'UPDATE':
              await _remote.table(mutation.table).upsert(mutation.payload!);
              break;
            case 'DELETE':
              await _remote.table(mutation.table).update({
                'deleted_at': DateTime.now().toIso8601String(),
              }).eq('id', mutation.entityId);
              break;
          }
          await _outbox.delete(mutation.id);
        } on PostgrestException catch (e) {
          if (_isPermanent(e)) {
            // Not retryable (e.g. RLS violation, bad constraint) — drop it
            // rather than blocking the rest of the queue forever, but keep
            // the error recorded for diagnostics.
            await _outbox.markFailed(mutation.id, 'DROPPED: ${e.message}');
            await _outbox.delete(mutation.id);
          } else {
            await _outbox.markFailed(mutation.id, e.message);
            return; // preserve ordering: stop and retry the whole queue later
          }
        } catch (_) {
          // Likely offline — stop and retry later.
          return;
        }
      }
    } finally {
      _flushing = false;
    }
  }

  Future<void> pullRemoteChanges(String shopId) async {
    for (final table in _daos.keys) {
      final dao = _daos[table]!;
      final cursor = await _syncMeta.getCursor(table) ?? DateTime.fromMillisecondsSinceEpoch(0);
      final rows = await _remote
          .table(table)
          .select()
          .eq('shop_id', shopId)
          .gt('updated_at', cursor.toIso8601String());

      DateTime? maxUpdated;
      for (final row in rows) {
        final updatedAt = DateTime.parse(row['updated_at'] as String);
        if (maxUpdated == null || updatedAt.isAfter(maxUpdated)) {
          maxUpdated = updatedAt;
        }
        if (row['deleted_at'] != null) {
          await dao.hardDeleteLocal(row['id'] as String);
        } else {
          await dao.upsertLocal(row);
        }
      }
      if (maxUpdated != null) {
        await _syncMeta.setCursor(table, maxUpdated);
      }
    }
  }

  Future<void> syncNow(String shopId) async {
    if (_syncing) return;
    _syncing = true;
    try {
      await flushOutbox();
      await pullRemoteChanges(shopId);
    } catch (_) {
      // Offline or transient failure — next trigger (timer/reconnect/resume)
      // will retry; nothing to surface here.
    } finally {
      _syncing = false;
    }
  }

  bool _isPermanent(PostgrestException e) {
    // Postgres error codes surfaced by PostgREST: 23xxx = integrity
    // constraint violations (FK/check/unique), 42501 = RLS/insufficient
    // privilege. Both mean "will never succeed by retrying", everything
    // else (network, 5xx, PGRST-prefixed transient codes) is retried.
    final code = e.code;
    if (code == null) return false;
    return code.startsWith('23') || code == '42501';
  }
}
