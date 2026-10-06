import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:udhar_khata_flutter/data/local/app_database.dart';
import 'package:udhar_khata_flutter/data/repository/ledger_repository.dart';
import 'package:udhar_khata_flutter/models/models.dart';
import 'package:udhar_khata_flutter/state/ledger_state.dart';

import 'fakes.dart';

void main() {
  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
    // Drop any cache file left by a previous run of this suite, so schema
    // changes don't fail against a stale on-disk file.
    await AppDatabase.instance.deleteForTests();
  });

  group('Udhar Khata - LedgerState Comprehensive Unit Tests', () {
    late FakeAuthService fakeAuth;
    late LedgerRepository repository;
    late LedgerState state;

    setUp(() {
      fakeAuth = FakeAuthService()..testUserId = 'test-user';
      repository = LedgerRepository(authService: fakeAuth);
      repository.seedShopIdForTests('test-shop');
      state = LedgerState(authService: fakeAuth, repository: repository);
    });

    tearDown(() async {
      await AppDatabase.instance.clearAll();
    });

    test('1. A freshly signed-in shop starts with an empty ledger', () {
      expect(state.customers, isEmpty);
      expect(state.transactions, isEmpty);
      expect(state.orders, isEmpty);
      expect(state.currentUser, isNull); // FakeAuthService reports signed out
    });

    test('2. Financial Summary on an empty ledger is all zeroes', () {
      final summary = state.getSummary();
      expect(summary.currentOutstandingUdhar, 0);
      expect(summary.totalLoanedTillDate, 0);
      expect(summary.totalRepaid, 0);
      expect(summary.customerBreakdown, isEmpty);
    });

    test('3. Add Customer increases customer count', () async {
      final newCustomer = await state.addCustomer(
        name: 'Amit Sharma',
        phone: '98765 43210',
        location: 'Sector 62, Noida',
        riskLevel: 'Low',
        notes: 'Regular retail customer',
      );

      expect(state.customers.length, 1);
      expect(newCustomer.name, 'Amit Sharma');
      expect(newCustomer.id, isNotEmpty);
      expect(state.customers.any((c) => c.name == 'Amit Sharma'), true);
    });

    test('4. Add UDHAAR Transaction increases customer outstanding balance', () async {
      final customer = await state.addCustomer(name: 'Ramesh General Store', phone: '98765 00001', location: 'Bhopal');
      final initialSummary = state.getCustomerSummary(customer);

      await state.addTransaction(
        customerId: customer.id,
        type: 'UDHAAR',
        amount: 1500.0,
        note: 'Cooking Oil & Spices',
        paymentMethod: 'Credit',
      );

      final updatedSummary = state.getCustomerSummary(customer);
      expect(updatedSummary.totalUdhar, initialSummary.totalUdhar + 1500.0);
      expect(updatedSummary.currentOutstanding, initialSummary.currentOutstanding + 1500.0);
    });

    test('5. Add PAYMENT Transaction decreases customer outstanding balance', () async {
      final customer = await state.addCustomer(name: 'Sanjay Dairy', phone: '98765 00002', location: 'Bhopal');
      await state.addTransaction(customerId: customer.id, type: 'UDHAAR', amount: 2000.0);
      final initialSummary = state.getCustomerSummary(customer);

      await state.addTransaction(
        customerId: customer.id,
        type: 'PAYMENT',
        amount: 1000.0,
        note: 'UPI Payment received',
        paymentMethod: 'UPI',
      );

      final updatedSummary = state.getCustomerSummary(customer);
      expect(updatedSummary.totalPaid, initialSummary.totalPaid + 1000.0);
      expect(updatedSummary.currentOutstanding, initialSummary.currentOutstanding - 1000.0);
    });

    test('6. Add Order and Advance Transaction', () async {
      final customer = await state.addCustomer(name: 'Maa Traders', phone: '98765 00003', location: 'Bhopal');

      await state.addOrder(
        customerId: customer.id,
        itemsSummary: '50kg Wheat Flour & 10kg Basmati Rice',
        totalAmount: 3500.0,
        advancePaid: 1000.0,
      );

      expect(state.orders.length, 1);
      // Advance payment should have created an ADVANCE transaction.
      expect(state.transactions.length, 1);
      expect(state.transactions.first.type, 'ADVANCE');
      expect(state.transactions.first.amount, 1000.0);
    });

    test('7. Update Order Status', () async {
      final customer = await state.addCustomer(name: 'Verma Medical', phone: '98765 00004', location: 'Bhopal');
      final order = await state.addOrder(
        customerId: customer.id,
        itemsSummary: 'Mineral water cartons',
        totalAmount: 1260.0,
        advancePaid: 0.0,
      );

      await state.updateOrderStatus(order.id, 'DELIVERED');

      final updatedOrder = state.orders.firstWhere((o) => o.id == order.id);
      expect(updatedOrder.status, 'DELIVERED');
    });

    test('8. Chat Message Logging', () async {
      final customer = await state.addCustomer(name: 'Krishna Mart', phone: '98765 00005', location: 'Bhopal');
      await state.sendChatMessage(customer.id, 'Payment reminder sent for ₹ 4200');

      expect(state.chatMessages.length, 1);
      expect(state.chatMessages.last.message, 'Payment reminder sent for ₹ 4200');
    });

    test('9. AI Voice Parser parses spoken text accurately', () async {
      await state.addCustomer(name: 'Ramesh General Store', phone: '98765 00001', location: 'Bhopal');
      await state.addCustomer(name: 'Sanjay Dairy', phone: '98765 00002', location: 'Bhopal');

      final result1 = state.parseVoiceText('Ramesh ko 500 ka tel udhar diya');
      expect(result1['customerName'], contains('Ramesh'));
      expect(result1['amount'], 500.0);
      expect(result1['type'], 'UDHAAR');

      final result2 = state.parseVoiceText('Sanjay se 1000 payment mila UPI');
      expect(result2['customerName'], contains('Sanjay'));
      expect(result2['amount'], 1000.0);
      expect(result2['type'], 'PAYMENT');
    });

    test('10. Profile updates persist on the shop profile', () async {
      final updatedProfile = state.shopProfile.copyWith(
        shopName: 'Tiwari Super Mart',
        ownerName: 'Pawan Tiwari',
        upiId: 'pawantiwari@okhdfcbank',
      );
      await state.updateProfile(updatedProfile);

      expect(state.shopProfile.shopName, 'Tiwari Super Mart');
      expect(state.shopProfile.ownerName, 'Pawan Tiwari');
      expect(state.shopProfile.upiId, 'pawantiwari@okhdfcbank');
    });

    test('11. Payment Reminders and 3 Alert Options', () async {
      final customer = await state.addCustomer(name: 'Ramesh General Store', phone: '98765 00001', location: 'Bhopal');

      // A customer udhar-recovery reminder with Alert Option 2 (1 Day Before).
      final added = await state.addReminder(
        customerId: customer.id,
        title: 'Ramesh General Store',
        amount: 2500.0,
        dueDate: DateTime.now().add(const Duration(days: 2)),
        reminderType: 'RECOVER_UDHAR',
        alertOption: AlertOption.oneDayBefore,
        note: 'Weekly balance settlement',
      );

      expect(state.reminders.length, 1);
      expect(added.title, 'Ramesh General Store');
      expect(added.amount, 2500.0);
      expect(added.reminderType, 'RECOVER_UDHAR');
      expect(added.alertOption, AlertOption.oneDayBefore);
      expect(state.getAlertOptionLabel(added.alertOption), contains('1 Day Before'));

      // A supplier-bill reminder (no linked customer) with Alert Option 3 (3 Days Before).
      final addedBill = await state.addReminder(
        customerId: '',
        title: 'Fortune Oil Distributor',
        amount: 12000.0,
        dueDate: DateTime.now().add(const Duration(days: 5)),
        reminderType: 'PAY_SUPPLIER',
        alertOption: AlertOption.threeDaysBefore,
        note: 'Oil tins bulk invoice',
      );

      expect(addedBill.title, 'Fortune Oil Distributor');
      expect(addedBill.reminderType, 'PAY_SUPPLIER');
      expect(addedBill.alertOption, AlertOption.threeDaysBefore);
      expect(state.getAlertOptionLabel(addedBill.alertOption), contains('3 Days Before'));

      // Toggle settled.
      expect(added.isSettled, false);
      await state.toggleReminderSettled(added.id);
      expect(state.reminders.firstWhere((r) => r.id == added.id).isSettled, true);

      // Delete reminder.
      await state.deleteReminder(added.id);
      expect(state.reminders.any((r) => r.id == added.id), false);
    });

    test('12. Mathematical Ledger Engine: Refund & Adjustment Handling', () async {
      final cust = await state.addCustomer(name: 'Krishna Mart', phone: '98765 00005', location: 'Bhopal');
      final baseSummary = state.getCustomerSummary(cust);

      await state.addTransaction(
        customerId: cust.id,
        type: 'REFUND',
        amount: 300.0,
        note: 'Damaged item refunded to customer',
      );

      final summaryAfterRefund = state.getCustomerSummary(cust);
      expect(summaryAfterRefund.totalRefund, 300.0);
      expect(summaryAfterRefund.currentOutstanding, baseSummary.currentOutstanding + 300.0);

      await state.addTransaction(
        customerId: cust.id,
        type: 'ADJUSTMENT',
        amount: -100.0,
        note: 'Discount adjustment',
      );

      final summaryAfterAdj = state.getCustomerSummary(cust);
      expect(summaryAfterAdj.totalAdjustment, -100.0);
      expect(summaryAfterAdj.currentOutstanding, summaryAfterRefund.currentOutstanding - 100.0);
    });

    test('13. Backup Export, Import & Model Serialization', () async {
      await state.addCustomer(name: 'Pawan Tiwari', phone: '98765 00009', location: 'Bhopal');
      await state.updateProfile(state.shopProfile.copyWith(ownerName: 'Pawan Tiwari'));

      final backupJson = state.exportBackupData();
      expect(backupJson, contains('Udhar Khata'));
      expect(backupJson, contains('Pawan Tiwari'));
      expect(backupJson, contains('customers'));
      expect(backupJson, contains('transactions'));

      final importResult = state.importBackupData(backupJson);
      expect(importResult, true);
    });
  });
}
