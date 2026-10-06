import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../../models/models.dart';
import '../auth/auth_service.dart';
import '../local/entity_dao.dart';
import '../local/outbox_dao.dart';
import '../local/shop_dao.dart';
import '../remote/supabase_client.dart';
import '../sync/sync_service.dart';

/// Single facade over the local sqflite cache + Supabase, mirroring the
/// shape LedgerState used to hold directly as in-memory lists. Every
/// mutator writes to the local cache and enqueues an outbox entry first
/// (so the UI updates instantly and offline), then kicks a background
/// sync; nothing here ever blocks the UI on a network call.
class LedgerRepository {
  LedgerRepository({required AuthService authService})
      : _authService = authService,
        _remote = SupabaseClientWrapper(),
        _outbox = OutboxDao(),
        _syncMeta = SyncMetaDao(),
        _shopDao = ShopDao(),
        _customerDao = EntityDao('customers'),
        _transactionDao = EntityDao('transactions'),
        _orderDao = EntityDao('orders'),
        _chatDao = EntityDao('chat_messages'),
        _reminderDao = EntityDao('reminders') {
    _sync = SyncService(
      remote: _remote,
      outbox: _outbox,
      syncMeta: _syncMeta,
      daos: {
        'customers': _customerDao,
        'transactions': _transactionDao,
        'orders': _orderDao,
        'chat_messages': _chatDao,
        'reminders': _reminderDao,
      },
    );
  }

  final AuthService _authService;
  final SupabaseClientWrapper _remote;
  final OutboxDao _outbox;
  final SyncMetaDao _syncMeta;
  final ShopDao _shopDao;
  final EntityDao _customerDao;
  final EntityDao _transactionDao;
  final EntityDao _orderDao;
  final EntityDao _chatDao;
  final EntityDao _reminderDao;
  late final SyncService _sync;
  static const _uuid = Uuid();

  String? _shopId;
  String? get shopId => _shopId;

  /// Lets tests exercise mutators without a real Supabase sign-in/sync
  /// round trip — production code always reaches [_shopId] via [bootstrap].
  @visibleForTesting
  void seedShopIdForTests(String id) => _shopId = id;

  ShopProfile shopProfile = ShopProfile(shopName: 'My Shop', ownerName: '', phone: '');
  final List<Customer> customers = [];
  final List<LedgerTransaction> transactions = [];
  final List<CustomerOrder> orders = [];
  final List<ChatMessage> chatMessages = [];
  final List<PaymentReminder> reminders = [];

  final _changes = StreamController<void>.broadcast();
  Stream<void> get onChanged => _changes.stream;

  Timer? _pollTimer;
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  /// Loads (or, on first login on this device, fetches) the signed-in
  /// user's shop, hydrates all in-memory lists from the local cache, then
  /// kicks a background sync. Safe to call multiple times (e.g. on every
  /// sign-in) — it just re-resolves the shop and re-hydrates.
  Future<void> bootstrap() async {
    final userId = _authService.currentUserId;
    if (userId == null) return;
    _shopId = await _resolveShopId(userId);
    await _hydrateFromLocal();
    _startBackgroundSync();
    unawaited(syncNow());
  }

  Future<String?> _resolveShopId(String userId) async {
    final local = await _shopDao.getForOwner(userId);
    if (local != null) return local['id'] as String;
    try {
      final rows = await _remote.table('shops').select().eq('owner_id', userId).limit(1);
      if (rows.isNotEmpty) {
        final row = rows.first;
        await _shopDao.upsertLocal(row);
        return row['id'] as String;
      }
    } catch (_) {
      // Offline on the very first login on this device, before any shop
      // row has ever been cached locally — nothing to hydrate yet.
    }
    return null;
  }

  Future<void> _hydrateFromLocal() async {
    final currentShopId = _shopId;
    final userId = _authService.currentUserId;
    if (currentShopId == null || userId == null) return;

    final shopRow = await _shopDao.getForOwner(userId);
    if (shopRow != null) shopProfile = ShopProfile.fromJson(shopRow);

    final customerRows = await _customerDao.getAll(currentShopId);
    customers
      ..clear()
      ..addAll(customerRows.map(Customer.fromJson));

    final transactionRows = await _transactionDao.getAll(currentShopId);
    transactions
      ..clear()
      ..addAll(transactionRows.map(LedgerTransaction.fromJson))
      ..sort((a, b) => b.date.compareTo(a.date));

    final orderRows = await _orderDao.getAll(currentShopId);
    orders
      ..clear()
      ..addAll(orderRows.map(CustomerOrder.fromJson))
      ..sort((a, b) => b.date.compareTo(a.date));

    final chatRows = await _chatDao.getAll(currentShopId);
    chatMessages
      ..clear()
      ..addAll(chatRows.map(ChatMessage.fromJson))
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final reminderRows = await _reminderDao.getAll(currentShopId);
    reminders
      ..clear()
      ..addAll(reminderRows.map(PaymentReminder.fromJson));

    _changes.add(null);
  }

  void _startBackgroundSync() {
    _pollTimer?.cancel();
    _pollTimer = Timer.periodic(const Duration(seconds: 30), (_) => syncNow());

    _connectivitySub?.cancel();
    _connectivitySub = Connectivity().onConnectivityChanged.listen((results) {
      final online = results.any((r) => r != ConnectivityResult.none);
      if (online) unawaited(syncNow());
    });
  }

  Future<void> syncNow() async {
    final currentShopId = _shopId;
    if (currentShopId == null) return;
    await _sync.syncNow(currentShopId);
    await _pullShopProfile(currentShopId);
    await _hydrateFromLocal();
  }

  /// `shops` is keyed by owner_id rather than shop_id, so it's pulled
  /// separately from the generic per-shop_id tables SyncService handles.
  Future<void> _pullShopProfile(String currentShopId) async {
    try {
      final rows = await _remote.table('shops').select().eq('id', currentShopId).limit(1);
      if (rows.isNotEmpty) {
        await _shopDao.upsertLocal(rows.first);
      }
    } catch (_) {
      // Offline — the cached profile from the last successful pull stands.
    }
  }

  /// Clears in-memory + local cache state. Called on sign-out so the next
  /// signed-in user never sees a previous owner's cached data.
  Future<void> reset() async {
    _pollTimer?.cancel();
    await _connectivitySub?.cancel();
    _shopId = null;
    customers.clear();
    transactions.clear();
    orders.clear();
    chatMessages.clear();
    reminders.clear();
    _changes.add(null);
  }

  Future<void> _writeThrough(EntityDao dao, String table, String id, Map<String, dynamic> json) async {
    await dao.upsertLocal(json);
    await _outbox.enqueue(table, id, 'INSERT', json);
    unawaited(syncNow());
  }

  // ---- Customers ----

  Future<Customer> addCustomer({
    required String name,
    required String phone,
    required String location,
    String riskLevel = 'Low',
    double creditLimit = 15000.0,
    String notes = '',
  }) async {
    final customer = Customer(
      id: _uuid.v4(),
      shopId: _shopId!,
      name: name,
      phone: phone,
      location: location,
      riskLevel: riskLevel,
      creditLimit: creditLimit,
      notes: notes,
    );
    customers.add(customer);
    await _writeThrough(_customerDao, 'customers', customer.id, customer.toJson());
    _changes.add(null);
    return customer;
  }

  Future<void> updateCustomer(Customer updated) async {
    final idx = customers.indexWhere((c) => c.id == updated.id);
    if (idx == -1) return;
    final withTimestamp = updated.copyWith(updatedAt: DateTime.now());
    customers[idx] = withTimestamp;
    await _writeThrough(_customerDao, 'customers', withTimestamp.id, withTimestamp.toJson());
    _changes.add(null);
  }

  Future<void> deleteCustomer(String customerId) async {
    customers.removeWhere((c) => c.id == customerId);
    transactions.removeWhere((t) => t.customerId == customerId);
    orders.removeWhere((o) => o.customerId == customerId);
    chatMessages.removeWhere((m) => m.customerId == customerId);
    reminders.removeWhere((r) => r.customerId == customerId);

    final now = DateTime.now();
    await _customerDao.softDeleteLocal(customerId, now);
    await _outbox.enqueue('customers', customerId, 'DELETE', null);
    unawaited(syncNow());
    _changes.add(null);
  }

  // ---- Transactions ----

  Future<LedgerTransaction> addTransaction({
    required String customerId,
    required String type,
    required double amount,
    String note = '',
    String paymentMethod = 'Cash',
    String reference = '',
    DateTime? date,
  }) async {
    final txn = LedgerTransaction(
      id: _uuid.v4(),
      shopId: _shopId!,
      customerId: customerId,
      type: type,
      amount: amount,
      note: note.isEmpty ? (type == 'UDHAAR' ? 'Udhar Entry' : 'Payment Received') : note,
      paymentMethod: paymentMethod,
      reference: reference,
      date: date ?? DateTime.now(),
    );
    transactions.insert(0, txn);
    await _writeThrough(_transactionDao, 'transactions', txn.id, txn.toJson());

    final chatMsg = ChatMessage(
      id: _uuid.v4(),
      shopId: _shopId!,
      customerId: customerId,
      sender: 'SHOP',
      message: type == 'UDHAAR'
          ? 'Udhar added: ₹ ${amount.toInt()} ($note)'
          : 'Payment received: ₹ ${amount.toInt()} via $paymentMethod',
      messageType: type == 'UDHAAR' ? 'BILL' : 'PAYMENT',
      timestamp: DateTime.now(),
    );
    chatMessages.add(chatMsg);
    await _writeThrough(_chatDao, 'chat_messages', chatMsg.id, chatMsg.toJson());

    _changes.add(null);
    return txn;
  }

  // ---- Orders ----

  Future<CustomerOrder> addOrder({
    required String customerId,
    required String itemsSummary,
    required double totalAmount,
    required double advancePaid,
  }) async {
    final order = CustomerOrder(
      id: _uuid.v4(),
      shopId: _shopId!,
      customerId: customerId,
      itemsSummary: itemsSummary,
      totalAmount: totalAmount,
      advancePaid: advancePaid,
      status: 'CONFIRMED',
      date: DateTime.now(),
    );
    orders.insert(0, order);
    await _writeThrough(_orderDao, 'orders', order.id, order.toJson());

    if (advancePaid > 0) {
      await addTransaction(
        customerId: customerId,
        type: 'ADVANCE',
        amount: advancePaid,
        note: 'Advance for Order #${order.id.substring(0, 8)}',
        paymentMethod: 'Cash',
      );
    }

    _changes.add(null);
    return order;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final idx = orders.indexWhere((o) => o.id == orderId);
    if (idx == -1) return;
    final updated = orders[idx].copyWith(status: status, updatedAt: DateTime.now());
    orders[idx] = updated;
    await _writeThrough(_orderDao, 'orders', updated.id, updated.toJson());
    _changes.add(null);
  }

  // ---- Chat ----

  Future<void> sendChatMessage(String customerId, String text) async {
    final msg = ChatMessage(
      id: _uuid.v4(),
      shopId: _shopId!,
      customerId: customerId,
      sender: 'SHOP',
      message: text,
      timestamp: DateTime.now(),
    );
    chatMessages.add(msg);
    await _writeThrough(_chatDao, 'chat_messages', msg.id, msg.toJson());
    _changes.add(null);
  }

  // ---- Reminders ----

  Future<PaymentReminder> addReminder({
    required String customerId,
    required String title,
    required double amount,
    required DateTime dueDate,
    String reminderType = 'RECOVER_UDHAR',
    AlertOption alertOption = AlertOption.sameDay,
    String note = '',
  }) async {
    final reminder = PaymentReminder(
      id: _uuid.v4(),
      shopId: _shopId!,
      customerId: customerId,
      title: title,
      amount: amount,
      dueDate: dueDate,
      reminderType: reminderType,
      alertOption: alertOption,
      note: note,
      createdAt: DateTime.now(),
    );
    reminders.add(reminder);
    await _writeThrough(_reminderDao, 'reminders', reminder.id, reminder.toJson());
    _changes.add(null);
    return reminder;
  }

  Future<void> toggleReminderSettled(String id) async {
    final idx = reminders.indexWhere((r) => r.id == id);
    if (idx == -1) return;
    final updated = reminders[idx].copyWith(isSettled: !reminders[idx].isSettled, updatedAt: DateTime.now());
    reminders[idx] = updated;
    await _writeThrough(_reminderDao, 'reminders', updated.id, updated.toJson());
    _changes.add(null);
  }

  Future<void> deleteReminder(String id) async {
    reminders.removeWhere((r) => r.id == id);
    final now = DateTime.now();
    await _reminderDao.softDeleteLocal(id, now);
    await _outbox.enqueue('reminders', id, 'DELETE', null);
    unawaited(syncNow());
    _changes.add(null);
  }

  // ---- Profile ----

  Future<void> updateProfile(ShopProfile updated) async {
    final withTimestamp = updated.copyWith(updatedAt: DateTime.now());
    shopProfile = withTimestamp;
    final json = withTimestamp.toJson();
    await _shopDao.upsertLocal(json);
    await _outbox.enqueue('shops', withTimestamp.id, 'UPDATE', json);
    unawaited(syncNow());
    _changes.add(null);
  }

  // ---- Backup restore ----

  /// Merges a previously-exported backup into the current shop: editable
  /// profile fields are overwritten, and customers/transactions/orders/
  /// reminders from the backup are upserted (by their original id)
  /// alongside whatever already exists. This is additive, not a wipe —
  /// there's no UI wired to this today (Profile's "Restore Data" button is
  /// a stub), so it favors not losing data over exactly mirroring the
  /// backup's snapshot.
  Future<void> restoreFromBackup(Map<String, dynamic> data) async {
    if (data['shopProfile'] != null) {
      final backup = ShopProfile.fromJson(data['shopProfile'] as Map<String, dynamic>);
      await updateProfile(shopProfile.copyWith(
        shopName: backup.shopName,
        ownerName: backup.ownerName,
        phone: backup.phone,
        location: backup.location,
        address: backup.address,
        upiId: backup.upiId,
        gstin: backup.gstin,
        email: backup.email,
      ));
    }
    if (data['customers'] is List) {
      for (final raw in data['customers'] as List) {
        final c = Customer.fromJson(raw as Map<String, dynamic>);
        customers.removeWhere((existing) => existing.id == c.id);
        customers.add(c);
        await _writeThrough(_customerDao, 'customers', c.id, c.toJson());
      }
    }
    if (data['transactions'] is List) {
      for (final raw in data['transactions'] as List) {
        final t = LedgerTransaction.fromJson(raw as Map<String, dynamic>);
        transactions.removeWhere((existing) => existing.id == t.id);
        transactions.add(t);
        await _writeThrough(_transactionDao, 'transactions', t.id, t.toJson());
      }
    }
    if (data['orders'] is List) {
      for (final raw in data['orders'] as List) {
        final o = CustomerOrder.fromJson(raw as Map<String, dynamic>);
        orders.removeWhere((existing) => existing.id == o.id);
        orders.add(o);
        await _writeThrough(_orderDao, 'orders', o.id, o.toJson());
      }
    }
    if (data['reminders'] is List) {
      for (final raw in data['reminders'] as List) {
        final r = PaymentReminder.fromJson(raw as Map<String, dynamic>);
        reminders.removeWhere((existing) => existing.id == r.id);
        reminders.add(r);
        await _writeThrough(_reminderDao, 'reminders', r.id, r.toJson());
      }
    }
    _changes.add(null);
  }
}
