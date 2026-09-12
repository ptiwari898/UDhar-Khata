import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../data/storage_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class LedgerState extends ChangeNotifier {
  final LocalStorageService _storageService = LocalStorageService();
  AppThemeMode _themeMode = AppThemeMode.defaultGoldenHour;

  AppThemeMode get themeMode => _themeMode;
  ThemePalette get activePalette => AppPalettes.getPalette(_themeMode);

  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
  }

  void cycleThemeMode() {
    switch (_themeMode) {
      case AppThemeMode.defaultGoldenHour:
        _themeMode = AppThemeMode.darkMode;
        break;
      case AppThemeMode.darkMode:
        _themeMode = AppThemeMode.lightMode;
        break;
      case AppThemeMode.lightMode:
        _themeMode = AppThemeMode.defaultGoldenHour;
        break;
    }
    notifyListeners();
  }

  LedgerState() {
    _loadFromDisk();
  }

  Future<void> _loadFromDisk() async {
    try {
      final saved = await _storageService.loadState();
      if (saved != null) {
        if (saved['shopProfile'] != null) {
          _shopProfile = ShopProfile.fromJson(saved['shopProfile'] as Map<String, dynamic>);
        }
        if (saved['currentUser'] != null) {
          _currentUser = UserAuthProfile.fromJson(saved['currentUser'] as Map<String, dynamic>);
        }
        if (saved['customers'] is List) {
          _customers.clear();
          for (final item in saved['customers'] as List) {
            _customers.add(Customer.fromJson(item as Map<String, dynamic>));
          }
        }
        if (saved['transactions'] is List) {
          _transactions.clear();
          for (final item in saved['transactions'] as List) {
            _transactions.add(LedgerTransaction.fromJson(item as Map<String, dynamic>));
          }
        }
        if (saved['orders'] is List) {
          _orders.clear();
          for (final item in saved['orders'] as List) {
            _orders.add(CustomerOrder.fromJson(item as Map<String, dynamic>));
          }
        }
        if (saved['reminders'] is List) {
          _reminders.clear();
          for (final item in saved['reminders'] as List) {
            _reminders.add(PaymentReminder.fromJson(item as Map<String, dynamic>));
          }
        }
        notifyListeners();
      }
    } catch (_) {}
  }

  void _persist() {
    _storageService.saveState(
      shopProfile: _shopProfile,
      currentUser: _currentUser,
      customers: _customers,
      transactions: _transactions,
      orders: _orders,
      chatMessages: _chatMessages,
      reminders: _reminders,
    );
  }

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

  final List<PaymentReminder> _reminders = [
    PaymentReminder(
      id: 401,
      customerId: 1,
      title: 'Ramesh General Store',
      amount: 4200.0,
      dueDate: DateTime.now().add(const Duration(days: 1)),
      reminderType: 'RECOVER_UDHAR',
      alertOption: AlertOption.oneDayBefore,
      note: 'Weekly grocery credit settlement',
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    PaymentReminder(
      id: 402,
      customerId: 2,
      title: 'Sanjay Dairy',
      amount: 4180.0,
      dueDate: DateTime.now().add(const Duration(days: 3)),
      reminderType: 'RECOVER_UDHAR',
      alertOption: AlertOption.threeDaysBefore,
      note: 'Milk and dairy supplies payment',
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PaymentReminder(
      id: 403,
      customerId: 3,
      title: 'Maa Traders',
      amount: 3920.0,
      dueDate: DateTime.now(),
      reminderType: 'RECOVER_UDHAR',
      alertOption: AlertOption.sameDay,
      note: 'Atta & Pulses payment due today',
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
    ),
    PaymentReminder(
      id: 404,
      customerId: 0,
      title: 'Amul Milk Wholesale Distributor',
      amount: 8500.0,
      dueDate: DateTime.now().add(const Duration(days: 4)),
      reminderType: 'PAY_SUPPLIER',
      alertOption: AlertOption.threeDaysBefore,
      note: 'Supplier invoice #INV-9921 for milk crates',
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  // Getters
  UserAuthProfile? get currentUser => _currentUser;
  ShopProfile get shopProfile => _shopProfile;
  List<Customer> get customers => List.unmodifiable(_customers);
  List<LedgerTransaction> get transactions => List.unmodifiable(_transactions);
  List<CustomerOrder> get orders => List.unmodifiable(_orders);
  List<ChatMessage> get chatMessages => List.unmodifiable(_chatMessages);
  List<PaymentReminder> get reminders => List.unmodifiable(_reminders);

  List<PaymentReminder> get upcomingReminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _reminders.where((r) => !r.isSettled && !r.dueDate.isBefore(today)).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<PaymentReminder> get overdueReminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return _reminders.where((r) => !r.isSettled && r.dueDate.isBefore(today)).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  // Reminders Management (3 Alert Options)
  void addReminder({
    required int customerId,
    required String title,
    required double amount,
    required DateTime dueDate,
    String reminderType = 'RECOVER_UDHAR', // 'RECOVER_UDHAR' or 'PAY_SUPPLIER'
    AlertOption alertOption = AlertOption.sameDay,
    String note = '',
  }) {
    final newReminder = PaymentReminder(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      customerId: customerId,
      title: title,
      amount: amount,
      dueDate: dueDate,
      reminderType: reminderType,
      alertOption: alertOption,
      note: note,
      createdAt: DateTime.now(),
    );
    _reminders.add(newReminder);
    notifyListeners();
    _persist();
  }

  void toggleReminderSettled(int id) {
    final index = _reminders.indexWhere((r) => r.id == id);
    if (index != -1) {
      final current = _reminders[index];
      _reminders[index] = current.copyWith(isSettled: !current.isSettled);
      notifyListeners();
      _persist();
    }
  }

  void deleteReminder(int id) {
    _reminders.removeWhere((r) => r.id == id);
    notifyListeners();
    _persist();
  }

  List<PaymentReminder> getRemindersForDate(DateTime date) {
    return _reminders.where((r) =>
        r.dueDate.year == date.year &&
        r.dueDate.month == date.month &&
        r.dueDate.day == date.day).toList();
  }

  String getAlertOptionLabel(AlertOption option) {
    switch (option) {
      case AlertOption.sameDay:
        return '⚡ On Due Date (आज)';
      case AlertOption.oneDayBefore:
        return '🔔 1 Day Before (1 दिन पहले)';
      case AlertOption.threeDaysBefore:
        return '📅 3 Days Before (3 दिन पहले)';
    }
  }

  // Authentication
  void loginDemoUser(String name, String email, bool isGoogle) {
    _currentUser = UserAuthProfile(
      uid: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      isGoogleUser: isGoogle,
    );
    notifyListeners();
    _persist();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
    _persist();
  }

  // Profile update
  void updateProfile(ShopProfile updated) {
    _shopProfile = updated;
    notifyListeners();
    _persist();
  }

  // Customer Management
  bool isPhoneDuplicate(String phone, {int? excludeCustomerId}) {
    final clean = phone.replaceAll(RegExp(r'\s+'), '');
    return _customers.any((c) =>
        c.id != excludeCustomerId &&
        c.phone.replaceAll(RegExp(r'\s+'), '') == clean &&
        clean.isNotEmpty);
  }

  bool isOverCreditLimit(Customer customer) {
    final summary = getCustomerSummary(customer);
    return summary.currentOutstanding > customer.creditLimit && customer.creditLimit > 0;
  }

  Customer addCustomer({
    required String name,
    required String phone,
    required String location,
    String riskLevel = 'Low',
    double creditLimit = 15000.0,
    String notes = '',
  }) {
    final newCust = Customer(
      id: DateTime.now().millisecondsSinceEpoch % 100000,
      name: name,
      phone: phone,
      location: location,
      riskLevel: riskLevel,
      creditLimit: creditLimit,
      notes: notes,
    );
    _customers.add(newCust);
    notifyListeners();
    _persist();
    return newCust;
  }

  void updateCustomer(Customer updated) {
    final idx = _customers.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _customers[idx] = updated;
      notifyListeners();
      _persist();
    }
  }

  void deleteCustomer(int customerId) {
    _customers.removeWhere((c) => c.id == customerId);
    _transactions.removeWhere((t) => t.customerId == customerId);
    _orders.removeWhere((o) => o.customerId == customerId);
    _chatMessages.removeWhere((m) => m.customerId == customerId);
    _reminders.removeWhere((r) => r.customerId == customerId);
    notifyListeners();
    _persist();
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
    _persist();
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
    _persist();
  }

  void updateOrderStatus(int orderId, String status) {
    final idx = _orders.indexWhere((o) => o.id == orderId);
    if (idx != -1) {
      _orders[idx] = _orders[idx].copyWith(status: status);
      notifyListeners();
      _persist();
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
    _persist();
  }

  // Backup and Restore (Phase 17)
  String exportBackupData() {
    return _storageService.exportBackupJson(
      shopProfile: _shopProfile,
      customers: _customers,
      transactions: _transactions,
      orders: _orders,
      reminders: _reminders,
    );
  }

  bool importBackupData(String jsonString) {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      if (data['shopProfile'] != null) {
        _shopProfile = ShopProfile.fromJson(data['shopProfile'] as Map<String, dynamic>);
      }
      if (data['customers'] is List) {
        _customers.clear();
        for (final item in data['customers'] as List) {
          _customers.add(Customer.fromJson(item as Map<String, dynamic>));
        }
      }
      if (data['transactions'] is List) {
        _transactions.clear();
        for (final item in data['transactions'] as List) {
          _transactions.add(LedgerTransaction.fromJson(item as Map<String, dynamic>));
        }
      }
      if (data['orders'] is List) {
        _orders.clear();
        for (final item in data['orders'] as List) {
          _orders.add(CustomerOrder.fromJson(item as Map<String, dynamic>));
        }
      }
      if (data['reminders'] is List) {
        _reminders.clear();
        for (final item in data['reminders'] as List) {
          _reminders.add(PaymentReminder.fromJson(item as Map<String, dynamic>));
        }
      }
      notifyListeners();
      _persist();
      return true;
    } catch (_) {
      return false;
    }
  }

  // Complete Mathematical Ledger Engine (Phase 4: Balance = Udhar - Payments - Advances + Refunds +/- Adjustments)
  CustomerSummary getCustomerSummary(Customer customer) {
    final custTxns = _transactions.where((t) => t.customerId == customer.id);
    double totalUdhar = 0;
    double totalPaid = 0;
    double totalAdvance = 0;
    double totalRefund = 0;
    double totalAdjustment = 0;

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
          totalRefund += t.amount;
          break;
        case 'ADJUSTMENT':
          totalAdjustment += t.amount;
          break;
      }
    }

    final outstanding = (totalUdhar + totalRefund + totalAdjustment) - (totalPaid + totalAdvance);

    return CustomerSummary(
      customer: customer,
      totalUdhar: totalUdhar,
      totalPaid: totalPaid,
      totalAdvance: totalAdvance,
      totalRefund: totalRefund,
      totalAdjustment: totalAdjustment,
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

  // Natural language voice parser with comprehensive NLP
  Map<String, dynamic> parseVoiceText(String spokenText) {
    final clean = spokenText.trim();
    final lower = clean.toLowerCase();
    Customer? matchedCust;

    // 1. Try finding matching customer in current shop list
    for (final c in _customers) {
      final tokens = c.name.toLowerCase().split(RegExp(r'\s+'));
      for (final tok in tokens) {
        if (tok.length > 2 && lower.contains(tok)) {
          matchedCust = c;
          break;
        }
      }
      if (matchedCust != null) break;
    }

    // 2. Transaction Type detection
    String type = 'UDHAAR';
    if (lower.contains('advance') || lower.contains('deposit') || lower.contains('peshgi')) {
      type = 'ADVANCE';
    } else if (lower.contains('payment') ||
        lower.contains('mila') ||
        lower.contains('diye') ||
        lower.contains('jama') ||
        lower.contains('received') ||
        lower.contains('cash') ||
        lower.contains('pay') ||
        lower.contains('chuka')) {
      type = 'PAYMENT';
    } else {
      type = 'UDHAAR';
    }

    // 3. Amount extraction
    double amount = 500.0;
    // Look for numbers like 1500, 1,500, 500, 2.5k, etc.
    final numMatch = RegExp(r'(\d+(?:[.,]\d+)?)').firstMatch(lower.replaceAll(',', ''));
    if (numMatch != null) {
      amount = double.tryParse(numMatch.group(1) ?? '500') ?? 500.0;
      if (lower.contains('hazaar') || lower.contains('thousand') || RegExp(r'\b\d+k\b').hasMatch(lower)) {
        if (amount < 100) amount *= 1000;
      } else if (lower.contains('lakh') || lower.contains('lac')) {
        if (amount < 100) amount *= 100000;
      }
    }

    // 4. Fallback customer name if not matched
    String customerName = matchedCust?.name ?? '';
    if (customerName.isEmpty) {
      final words = clean.split(RegExp(r'\s+'));
      if (words.isNotEmpty && !words.first.toLowerCase().contains(RegExp(r'\d'))) {
        customerName = words.first;
      } else {
        customerName = 'Customer';
      }
    }

    return {
      'customerName': customerName,
      'customerId': matchedCust?.id,
      'type': type,
      'amount': amount,
      'note': clean.isNotEmpty ? clean : 'Voice entry',
    };
  }
}
