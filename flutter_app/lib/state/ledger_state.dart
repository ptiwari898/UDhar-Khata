import 'package:flutter/foundation.dart';
import '../models/models.dart';

class LedgerState extends ChangeNotifier {
  UserAuthProfile? _currentUser = const UserAuthProfile(
    uid: 'demo_user_1',
    name: 'Shivam Kirana Store',
    email: 'merchant@udharkhata.com',
    isGoogleUser: true,
  );

  ShopProfile _shopProfile = const ShopProfile(
    shopName: 'Shivam Kirana Store',
    ownerName: 'Shivam Kumar',
    phone: '98765 12345',
    location: 'Bhopal, MP',
    address: 'Shop No. 12, Main Market, Bhopal, MP',
    upiId: 'shivamkirana@upi',
    gstin: '23AAAAA0000A1Z5',
    email: 'merchant@udharkhata.com',
  );

  final List<Customer> _customers = [
    const Customer(
      id: 1,
      name: 'Ramesh General Store',
      phone: '98765 43210',
      location: 'Main Bazaar, Bhopal',
      riskLevel: 'High',
      notes: 'Daily grocery supplies on weekly credit',
    ),
    const Customer(
      id: 2,
      name: 'Sanjay Dairy',
      phone: '98110 23456',
      location: 'Kolar Road, Bhopal',
      riskLevel: 'Medium',
      notes: 'Milk and dairy vendor',
    ),
    const Customer(
      id: 3,
      name: 'Maa Traders',
      phone: '99887 65432',
      location: 'MP Nagar, Bhopal',
      riskLevel: 'Medium',
      notes: 'Provisions and oil supplier',
    ),
    const Customer(
      id: 4,
      name: 'Verma Medical',
      phone: '98670 11223',
      location: 'Arera Colony, Bhopal',
      riskLevel: 'Low',
      notes: 'Regular customer',
    ),
    const Customer(
      id: 5,
      name: 'Krishna Mart',
      phone: '97021 88012',
      location: 'Shahpura, Bhopal',
      riskLevel: 'Low',
      notes: 'Prompt payer',
    ),
  ];

  final List<LedgerTransaction> _transactions = [
    LedgerTransaction(
      id: 101,
      customerId: 1,
      type: 'UDHAAR',
      amount: 4200.0,
      note: 'Rice 25kg, Sugar 10kg, Oil 5L',
      date: DateTime.now().subtract(const Duration(days: 4)),
      paymentMethod: 'Credit',
    ),
    LedgerTransaction(
      id: 102,
      customerId: 1,
      type: 'UDHAAR',
      amount: 2040.0,
      note: 'Tea packs and spices',
      date: DateTime.now().subtract(const Duration(days: 2)),
      paymentMethod: 'Credit',
    ),
    LedgerTransaction(
      id: 103,
      customerId: 2,
      type: 'UDHAAR',
      amount: 5180.0,
      note: 'Dairy items and milk tins',
      date: DateTime.now().subtract(const Duration(days: 5)),
      paymentMethod: 'Credit',
    ),
    LedgerTransaction(
      id: 104,
      customerId: 2,
      type: 'PAYMENT',
      amount: 1000.0,
      note: 'UPI Payment received',
      date: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'UPI',
      reference: 'UPI/98712365',
    ),
    LedgerTransaction(
      id: 105,
      customerId: 3,
      type: 'UDHAAR',
      amount: 3920.0,
      note: 'Atta 20kg & Pulses',
      date: DateTime.now().subtract(const Duration(days: 3)),
      paymentMethod: 'Credit',
    ),
    LedgerTransaction(
      id: 106,
      customerId: 4,
      type: 'UDHAAR',
      amount: 3600.0,
      note: 'Water crates & provisions',
      date: DateTime.now().subtract(const Duration(days: 6)),
      paymentMethod: 'Credit',
    ),
    LedgerTransaction(
      id: 107,
      customerId: 4,
      type: 'PAYMENT',
      amount: 1000.0,
      note: 'Cash received',
      date: DateTime.now().subtract(const Duration(days: 2)),
      paymentMethod: 'Cash',
    ),
    LedgerTransaction(
      id: 108,
      customerId: 5,
      type: 'ADVANCE',
      amount: 2500.0,
      note: 'Monthly advance deposit',
      date: DateTime.now().subtract(const Duration(days: 1)),
      paymentMethod: 'UPI',
      reference: 'UPI/77665544',
    ),
    LedgerTransaction(
      id: 109,
      customerId: 5,
      type: 'UDHAAR',
      amount: 680.0,
      note: 'Snacks and beverages',
      date: DateTime.now(),
      paymentMethod: 'Credit',
    ),
  ];

  final List<CustomerOrder> _orders = [
    CustomerOrder(
      id: 201,
      customerId: 1,
      itemsSummary: '12 kg sugar, 6 cartons tea, 10kg Atta',
      totalAmount: 4250.0,
      advancePaid: 1000.0,
      status: 'CONFIRMED',
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    CustomerOrder(
      id: 202,
      customerId: 2,
      itemsSummary: 'Milk packets, butter 2kg, cream 1L',
      totalAmount: 2880.0,
      advancePaid: 1200.0,
      status: 'READY',
      date: DateTime.now(),
    ),
    CustomerOrder(
      id: 203,
      customerId: 3,
      itemsSummary: 'Rice bags 2x25kg, cooking oil 15L',
      totalAmount: 6450.0,
      advancePaid: 2000.0,
      status: 'DELIVERED',
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
    CustomerOrder(
      id: 204,
      customerId: 4,
      itemsSummary: 'Mineral water cartons 5x',
      totalAmount: 1260.0,
      advancePaid: 0.0,
      status: 'CONFIRMED',
      date: DateTime.now(),
    ),
  ];

  final List<ChatMessage> _chatMessages = [
    ChatMessage(
      id: 301,
      customerId: 1,
      sender: 'SHOP',
      message: 'Hello Ramesh ji, bill for today Rs. 2,040 has been added to your ledger.',
      messageType: 'BILL',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    ChatMessage(
      id: 302,
      customerId: 1,
      sender: 'CUSTOMER',
      message: 'Sure Shivam ji, will clear it on Saturday.',
      messageType: 'TEXT',
      timestamp: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
    ),
  ];

  // Getters
  UserAuthProfile? get currentUser => _currentUser;
  ShopProfile get shopProfile => _shopProfile;
  List<Customer> get customers => List.unmodifiable(_customers);
  List<LedgerTransaction> get transactions => List.unmodifiable(_transactions);
  List<CustomerOrder> get orders => List.unmodifiable(_orders);
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);

  // Authentication
  void loginDemoUser(String name, String email, bool isGoogle) {
    _currentUser = UserAuthProfile(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      isGoogleUser: isGoogle,
    );
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }

  // Profile update
  void updateProfile(ShopProfile updated) {
    _shopProfile = updated;
    notifyListeners();
  }

  // Customer Management
  Customer addCustomer({
    required String name,
    required String phone,
    required String location,
    String riskLevel = 'Low',
    String notes = '',
  }) {
    final newCust = Customer(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      name: name,
      phone: phone,
      location: location,
      riskLevel: riskLevel,
      notes: notes,
    );
    _customers.add(newCust);
    notifyListeners();
    return newCust;
  }

  void deleteCustomer(int customerId) {
    _customers.removeWhere((c) => c.id == customerId);
    _transactions.removeWhere((t) => t.customerId == customerId);
    _orders.removeWhere((o) => o.customerId == customerId);
    _chatMessages.removeWhere((m) => m.customerId == customerId);
    notifyListeners();
  }

  // Transaction Management
  void addTransaction({
    required int customerId,
    required String type,
    required double amount,
    String note = '',
    String paymentMethod = 'Cash',
    String reference = '',
    DateTime? date,
  }) {
    final txn = LedgerTransaction(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      customerId: customerId,
      type: type,
      amount: amount,
      note: note.isEmpty ? (type == 'UDHAAR' ? 'Udhar Entry' : 'Payment Received') : note,
      paymentMethod: paymentMethod,
      reference: reference,
      date: date ?? DateTime.now(),
    );
    _transactions.insert(0, txn);

    // Auto add chat entry
    _chatMessages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        customerId: customerId,
        sender: 'SHOP',
        message: type == 'UDHAAR'
            ? 'Udhar added: ₹ ${amount.toInt()} ($note)'
            : 'Payment received: ₹ ${amount.toInt()} via $paymentMethod',
        messageType: type == 'UDHAAR' ? 'BILL' : 'PAYMENT',
        timestamp: DateTime.now(),
      ),
    );

    notifyListeners();
  }

  // Order Management
  void addOrder({
    required int customerId,
    required String itemsSummary,
    required double totalAmount,
    required double advancePaid,
  }) {
    final order = CustomerOrder(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      customerId: customerId,
      itemsSummary: itemsSummary,
      totalAmount: totalAmount,
      advancePaid: advancePaid,
      status: 'CONFIRMED',
      date: DateTime.now(),
    );
    _orders.insert(0, order);

    if (advancePaid > 0) {
      addTransaction(
        customerId: customerId,
        type: 'ADVANCE',
        amount: advancePaid,
        note: 'Advance for Order #${order.id}',
        paymentMethod: 'Cash',
      );
    }

    notifyListeners();
  }

  void updateOrderStatus(int orderId, String status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(status: status);
      notifyListeners();
    }
  }

  // Chat Messages
  void sendChatMessage(int customerId, String text) {
    _chatMessages.add(
      ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch % 100000,
        customerId: customerId,
        sender: 'SHOP',
        message: text,
        timestamp: DateTime.now(),
      ),
    );
    notifyListeners();
  }

  // Calculations
  CustomerSummary getCustomerSummary(Customer customer) {
    final custTxns = _transactions.where((t) => t.customerId == customer.id);
    double totalUdhar = 0;
    double totalPaid = 0;
    double totalAdvance = 0;

    for (final t in custTxns) {
      switch (t.type.toUpperCase()) {
        case 'UDHAAR':
          totalUdhar += t.amount;
          break;
        case 'PAYMENT':
          totalPaid += t.amount;
          break;
        case 'ADVANCE':
          totalAdvance += t.amount;
          break;
        case 'REFUND':
          totalPaid -= t.amount;
          break;
      }
    }

    final outstanding = (totalUdhar) - (totalPaid + totalAdvance);

    return CustomerSummary(
      customer: customer,
      totalUdhar: totalUdhar,
      totalPaid: totalPaid,
      totalAdvance: totalAdvance,
      currentOutstanding: outstanding,
    );
  }

  OverallShopSummary getSummary() {
    final breakdowns = _customers.map(getCustomerSummary).toList();
    double totalUdhar = 0;
    double totalPaid = 0;
    double totalAdvance = 0;
    double currentOutstanding = 0;

    for (final b in breakdowns) {
      totalUdhar += b.totalUdhar;
      totalPaid += b.totalPaid;
      totalAdvance += b.totalAdvance;
      if (b.currentOutstanding > 0) {
        currentOutstanding += b.currentOutstanding;
      }
    }

    return OverallShopSummary(
      currentOutstandingUdhar: currentOutstanding,
      totalLoanedTillDate: totalUdhar,
      totalRepaid: totalPaid,
      advanceBalance: totalAdvance,
      customerBreakdown: breakdowns,
    );
  }

  // Natural language voice parser simulation
  Map<String, dynamic> parseVoiceText(String spokenText) {
    final lower = spokenText.toLowerCase();
    Customer? matchedCust;

    for (final c in _customers) {
      final tokens = c.name.toLowerCase().split(' ');
      for (final tok in tokens) {
        if (tok.length > 2 && lower.contains(tok)) {
          matchedCust = c;
          break;
        }
      }
      if (matchedCust != null) break;
    }

    String type = 'UDHAAR';
    if (lower.contains('payment') ||
        lower.contains('mila') ||
        lower.contains('diye') ||
        lower.contains('cash') ||
        lower.contains('upi')) {
      type = 'PAYMENT';
    } else if (lower.contains('advance')) {
      type = 'ADVANCE';
    }

    double amount = 500.0;
    final match = RegExp(r'(\d+)').firstMatch(spokenText);
    if (match != null) {
      amount = double.tryParse(match.group(1) ?? '500') ?? 500;
      if (lower.contains('hazaar') || lower.contains('thousand') || RegExp(r'\b\d+k\b').hasMatch(lower)) {
        amount *= 1000;
      }
    }

    return {
      'customerName': matchedCust?.name ?? (spokenText.split(' ').firstOrNull ?? 'Customer'),
      'customerId': matchedCust?.id,
      'type': type,
      'amount': amount,
      'note': 'Voice: $spokenText',
    };
  }
}
