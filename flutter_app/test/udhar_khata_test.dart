import 'package:flutter_test/flutter_test.dart';
import 'package:udhar_khata_flutter/models/models.dart';
import 'package:udhar_khata_flutter/state/ledger_state.dart';

void main() {
  group('Udhar Khata - LedgerState Comprehensive Unit Tests', () {
    late LedgerState state;

    setUp(() {
      state = LedgerState();
    });

    test('1. Initial State carries sample customers, transactions and shop profile', () {
      expect(state.customers.length, greaterThanOrEqualTo(5));
      expect(state.transactions.length, greaterThanOrEqualTo(5));
      expect(state.orders.length, greaterThanOrEqualTo(3));
      expect(state.shopProfile.shopName, 'Shivam Kirana Store');
      expect(state.currentUser, isNotNull);
      expect(state.currentUser?.name, 'Shivam Kirana Store');
    });

    test('2. Financial Summary aggregates correctly', () {
      final summary = state.getSummary();
      expect(summary.currentOutstandingUdhar, greaterThan(0));
      expect(summary.totalLoanedTillDate, greaterThan(0));
      expect(summary.totalRepaid, greaterThan(0));
      expect(summary.customerBreakdown.isNotEmpty, true);
    });

    test('3. Add Customer increases customer count', () {
      final initialCount = state.customers.length;
      final newCustomer = state.addCustomer(
        name: 'Amit Sharma',
        phone: '98765 43210',
        location: 'Sector 62, Noida',
        riskLevel: 'Low',
        notes: 'Regular retail customer',
      );

      expect(state.customers.length, initialCount + 1);
      expect(newCustomer.name, 'Amit Sharma');
      expect(state.customers.any((c) => c.name == 'Amit Sharma'), true);
    });

    test('4. Add UDHAAR Transaction increases customer outstanding balance', () {
      final customer = state.customers.first;
      final initialSummary = state.getCustomerSummary(customer);

      state.addTransaction(
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

    test('5. Add PAYMENT Transaction decreases customer outstanding balance', () {
      final customer = state.customers.first;
      final initialSummary = state.getCustomerSummary(customer);

      state.addTransaction(
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

    test('6. Add Order and Advance Transaction', () {
      final initialOrdersCount = state.orders.length;
      final initialTxnCount = state.transactions.length;

      state.addOrder(
        customerId: 1,
        itemsSummary: '50kg Wheat Flour & 10kg Basmati Rice',
        totalAmount: 3500.0,
        advancePaid: 1000.0,
      );

      expect(state.orders.length, initialOrdersCount + 1);
      // Advance payment should have created an ADVANCE transaction
      expect(state.transactions.length, initialTxnCount + 1);
      expect(state.transactions.first.type, 'ADVANCE');
      expect(state.transactions.first.amount, 1000.0);
    });

    test('7. Update Order Status', () {
      final firstOrder = state.orders.first;
      state.updateOrderStatus(firstOrder.id, 'DELIVERED');

      final updatedOrder = state.orders.firstWhere((o) => o.id == firstOrder.id);
      expect(updatedOrder.status, 'DELIVERED');
    });

    test('8. Chat Message Logging', () {
      final initialChatCount = state.chatMessages.length;
      state.sendChatMessage(1, 'Payment reminder sent for ₹ 4200');

      expect(state.chatMessages.length, initialChatCount + 1);
      expect(state.chatMessages.last.message, 'Payment reminder sent for ₹ 4200');
    });

    test('9. AI Voice Parser parses spoken text accurately', () {
      final result1 = state.parseVoiceText('Ramesh ko 500 ka tel udhar diya');
      expect(result1['customerName'], contains('Ramesh'));
      expect(result1['amount'], 500.0);
      expect(result1['type'], 'UDHAAR');

      final result2 = state.parseVoiceText('Sanjay se 1000 payment mila UPI');
      expect(result2['customerName'], contains('Sanjay'));
      expect(result2['amount'], 1000.0);
      expect(result2['type'], 'PAYMENT');
    });

    test('10. Authentication and Profile Management', () {
      state.logout();
      expect(state.currentUser, isNull);

      state.loginDemoUser('Pawan Tiwari', 'ptiwari898@gmail.com', true);
      expect(state.currentUser?.name, 'Pawan Tiwari');
      expect(state.currentUser?.email, 'ptiwari898@gmail.com');

      final updatedProfile = state.shopProfile.copyWith(
        shopName: 'Tiwari Super Mart',
        ownerName: 'Pawan Tiwari',
        upiId: 'pawantiwari@okhdfcbank',
      );
      state.updateProfile(updatedProfile);

      expect(state.shopProfile.shopName, 'Tiwari Super Mart');
      expect(state.shopProfile.ownerName, 'Pawan Tiwari');
      expect(state.shopProfile.upiId, 'pawantiwari@okhdfcbank');
    });
  });
}
