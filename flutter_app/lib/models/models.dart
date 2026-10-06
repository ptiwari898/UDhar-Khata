class ShopProfile {
  final String id;
  final String ownerId;
  final String shopName;
  final String ownerName;
  final String phone;
  final String location;
  final String address;
  final String upiId;
  final String gstin;
  final String email;
  final DateTime updatedAt;

  ShopProfile({
    this.id = '',
    this.ownerId = '',
    required this.shopName,
    required this.ownerName,
    required this.phone,
    this.location = 'Bhopal, MP',
    this.address = 'Shop No. 12, Main Market, Bhopal, MP',
    this.upiId = 'shivamkirana@upi',
    this.gstin = '23AAAAA0000A1Z5',
    this.email = 'merchant@udharkhata.com',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  ShopProfile copyWith({
    String? shopName,
    String? ownerName,
    String? phone,
    String? location,
    String? address,
    String? upiId,
    String? gstin,
    String? email,
    DateTime? updatedAt,
  }) {
    return ShopProfile(
      id: id,
      ownerId: ownerId,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      address: address ?? this.address,
      upiId: upiId ?? this.upiId,
      gstin: gstin ?? this.gstin,
      email: email ?? this.email,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'owner_id': ownerId,
    'shop_name': shopName,
    'owner_name': ownerName,
    'phone': phone,
    'location': location,
    'address': address,
    'upi_id': upiId,
    'gstin': gstin,
    'email': email,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory ShopProfile.fromJson(Map<String, dynamic> json) => ShopProfile(
    id: json['id'] as String? ?? '',
    ownerId: json['owner_id'] as String? ?? '',
    shopName: json['shop_name'] as String? ?? 'Shop',
    ownerName: json['owner_name'] as String? ?? 'Merchant',
    phone: json['phone'] as String? ?? '',
    location: json['location'] as String? ?? 'Bhopal, MP',
    address: json['address'] as String? ?? '',
    upiId: json['upi_id'] as String? ?? 'merchant@upi',
    gstin: json['gstin'] as String? ?? '',
    email: json['email'] as String? ?? '',
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : DateTime.now(),
  );
}

class Customer {
  final String id;
  final String shopId;
  final String name;
  final String phone;
  final String location;
  final String riskLevel; // 'High', 'Medium', 'Low'
  final double creditLimit;
  final String notes;
  final DateTime updatedAt;

  Customer({
    required this.id,
    this.shopId = '',
    required this.name,
    required this.phone,
    required this.location,
    this.riskLevel = 'Low',
    this.creditLimit = 15000.0,
    this.notes = '',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Customer copyWith({
    String? name,
    String? phone,
    String? location,
    String? riskLevel,
    double? creditLimit,
    String? notes,
    DateTime? updatedAt,
  }) {
    return Customer(
      id: id,
      shopId: shopId,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      riskLevel: riskLevel ?? this.riskLevel,
      creditLimit: creditLimit ?? this.creditLimit,
      notes: notes ?? this.notes,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'name': name,
    'phone': phone,
    'location': location,
    'risk_level': riskLevel,
    'credit_limit': creditLimit,
    'notes': notes,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'] as String,
    shopId: json['shop_id'] as String? ?? '',
    name: json['name'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    location: json['location'] as String? ?? '',
    riskLevel: json['risk_level'] as String? ?? 'Low',
    creditLimit: (json['credit_limit'] as num?)?.toDouble() ?? 15000.0,
    notes: json['notes'] as String? ?? '',
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : DateTime.now(),
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Customer && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class LedgerTransaction {
  final String id;
  final String shopId;
  final String customerId;
  final String type; // 'UDHAAR', 'PAYMENT', 'ADVANCE', 'REFUND', 'ADJUSTMENT'
  final double amount;
  final String note;
  final DateTime date;
  final String paymentMethod; // 'Cash', 'UPI', 'Bank Transfer', 'Other'
  final String reference;
  final DateTime updatedAt;

  LedgerTransaction({
    required this.id,
    this.shopId = '',
    required this.customerId,
    required this.type,
    required this.amount,
    this.note = '',
    required this.date,
    this.paymentMethod = 'Cash',
    this.reference = '',
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  LedgerTransaction copyWith({
    String? type,
    double? amount,
    String? note,
    DateTime? date,
    String? paymentMethod,
    String? reference,
    DateTime? updatedAt,
  }) {
    return LedgerTransaction(
      id: id,
      shopId: shopId,
      customerId: customerId,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      note: note ?? this.note,
      date: date ?? this.date,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      reference: reference ?? this.reference,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'customer_id': customerId,
    'type': type,
    'amount': amount,
    'note': note,
    'txn_date': date.toIso8601String(),
    'payment_method': paymentMethod,
    'reference': reference,
    'updated_at': updatedAt.toIso8601String(),
  };

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) => LedgerTransaction(
    id: json['id'] as String,
    shopId: json['shop_id'] as String? ?? '',
    customerId: json['customer_id'] as String,
    type: json['type'] as String? ?? 'UDHAAR',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    note: json['note'] as String? ?? '',
    date: json['txn_date'] != null
        ? DateTime.parse(json['txn_date'] as String)
        : DateTime.now(),
    paymentMethod: json['payment_method'] as String? ?? 'Cash',
    reference: json['reference'] as String? ?? '',
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : DateTime.now(),
  );

  DateTime get timestamp => date;
}

class CustomerOrder {
  final String id;
  final String shopId;
  final String customerId;
  final String itemsSummary;
  final double totalAmount;
  final double advancePaid;
  final String status; // 'CONFIRMED', 'READY', 'DELIVERED', 'COMPLETED'
  final DateTime date;
  final DateTime updatedAt;

  CustomerOrder({
    required this.id,
    this.shopId = '',
    required this.customerId,
    required this.itemsSummary,
    required this.totalAmount,
    this.advancePaid = 0.0,
    this.status = 'CONFIRMED',
    required this.date,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  CustomerOrder copyWith({
    String? status,
    double? advancePaid,
    DateTime? updatedAt,
  }) {
    return CustomerOrder(
      id: id,
      shopId: shopId,
      customerId: customerId,
      itemsSummary: itemsSummary,
      totalAmount: totalAmount,
      advancePaid: advancePaid ?? this.advancePaid,
      status: status ?? this.status,
      date: date,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'customer_id': customerId,
    'items_summary': itemsSummary,
    'total_amount': totalAmount,
    'advance_paid': advancePaid,
    'status': status,
    'order_date': date.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory CustomerOrder.fromJson(Map<String, dynamic> json) => CustomerOrder(
    id: json['id'] as String,
    shopId: json['shop_id'] as String? ?? '',
    customerId: json['customer_id'] as String,
    itemsSummary: json['items_summary'] as String? ?? '',
    totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
    advancePaid: (json['advance_paid'] as num?)?.toDouble() ?? 0.0,
    status: json['status'] as String? ?? 'CONFIRMED',
    date: json['order_date'] != null
        ? DateTime.parse(json['order_date'] as String)
        : DateTime.now(),
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : DateTime.now(),
  );
}

class ChatMessage {
  final String id;
  final String shopId;
  final String customerId;
  final String sender; // 'SHOP', 'CUSTOMER'
  final String message;
  final String messageType; // 'TEXT', 'BILL', 'PAYMENT'
  final DateTime timestamp;
  final DateTime updatedAt;

  ChatMessage({
    required this.id,
    this.shopId = '',
    required this.customerId,
    required this.sender,
    required this.message,
    this.messageType = 'TEXT',
    required this.timestamp,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'customer_id': customerId,
    'sender': sender,
    'message': message,
    'message_type': messageType,
    'sent_at': timestamp.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as String,
    shopId: json['shop_id'] as String? ?? '',
    customerId: json['customer_id'] as String,
    sender: json['sender'] as String? ?? 'SHOP',
    message: json['message'] as String? ?? '',
    messageType: json['message_type'] as String? ?? 'TEXT',
    timestamp: json['sent_at'] != null
        ? DateTime.parse(json['sent_at'] as String)
        : DateTime.now(),
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : DateTime.now(),
  );
}

class CustomerSummary {
  final Customer customer;
  final double totalUdhar;
  final double totalPaid;
  final double totalAdvance;
  final double totalRefund;
  final double totalAdjustment;
  final double currentOutstanding; // > 0 means customer owes money, < 0 means advance with shop

  const CustomerSummary({
    required this.customer,
    required this.totalUdhar,
    required this.totalPaid,
    required this.totalAdvance,
    this.totalRefund = 0.0,
    this.totalAdjustment = 0.0,
    required this.currentOutstanding,
  });
}

class OverallShopSummary {
  final double currentOutstandingUdhar;
  final double totalLoanedTillDate;
  final double totalRepaid;
  final double advanceBalance;
  final List<CustomerSummary> customerBreakdown;

  const OverallShopSummary({
    required this.currentOutstandingUdhar,
    required this.totalLoanedTillDate,
    required this.totalRepaid,
    required this.advanceBalance,
    required this.customerBreakdown,
  });
}

class UserAuthProfile {
  final String uid;
  final String name;
  final String email;
  final bool isGoogleUser;

  const UserAuthProfile({
    required this.uid,
    required this.name,
    required this.email,
    this.isGoogleUser = false,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'email': email,
    'isGoogleUser': isGoogleUser,
  };

  factory UserAuthProfile.fromJson(Map<String, dynamic> json) => UserAuthProfile(
    uid: json['uid'] as String,
    name: json['name'] as String? ?? '',
    email: json['email'] as String? ?? '',
    isGoogleUser: json['isGoogleUser'] as bool? ?? false,
  );
}

enum AlertOption {
  sameDay,        // Option 1: On Due Date (आज के दिन)
  oneDayBefore,   // Option 2: 1 Day Prior (1 दिन पहले)
  threeDaysBefore,// Option 3: 3 Days Prior (3 दिन पहले)
}

class PaymentReminder {
  final String id;
  final String shopId;
  /// Empty string means "not tied to a customer" (e.g. a PAY_SUPPLIER bill).
  final String customerId;
  final String title;
  final double amount;
  final DateTime dueDate;
  final String reminderType; // 'RECOVER_UDHAR' (Customer debt) or 'PAY_SUPPLIER' (Vendor bill)
  final AlertOption alertOption;
  final bool isSettled;
  final String note;
  final DateTime createdAt;
  final DateTime updatedAt;

  PaymentReminder({
    required this.id,
    this.shopId = '',
    this.customerId = '',
    required this.title,
    required this.amount,
    required this.dueDate,
    this.reminderType = 'RECOVER_UDHAR',
    this.alertOption = AlertOption.sameDay,
    this.isSettled = false,
    this.note = '',
    required this.createdAt,
    DateTime? updatedAt,
  }) : updatedAt = updatedAt ?? DateTime.now();

  PaymentReminder copyWith({
    String? customerId,
    String? title,
    double? amount,
    DateTime? dueDate,
    String? reminderType,
    AlertOption? alertOption,
    bool? isSettled,
    String? note,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PaymentReminder(
      id: id,
      shopId: shopId,
      customerId: customerId ?? this.customerId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      reminderType: reminderType ?? this.reminderType,
      alertOption: alertOption ?? this.alertOption,
      isSettled: isSettled ?? this.isSettled,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shop_id': shopId,
    'customer_id': customerId.isEmpty ? null : customerId,
    'title': title,
    'amount': amount,
    'due_date': dueDate.toIso8601String(),
    'reminder_type': reminderType,
    'alert_option': alertOption.name,
    'is_settled': isSettled,
    'note': note,
    'created_at': createdAt.toIso8601String(),
    'updated_at': updatedAt.toIso8601String(),
  };

  factory PaymentReminder.fromJson(Map<String, dynamic> json) => PaymentReminder(
    id: json['id'] as String,
    shopId: json['shop_id'] as String? ?? '',
    customerId: json['customer_id'] as String? ?? '',
    title: json['title'] as String? ?? 'Payment Reminder',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    dueDate: json['due_date'] != null
        ? DateTime.parse(json['due_date'] as String)
        : DateTime.now(),
    reminderType: json['reminder_type'] as String? ?? 'RECOVER_UDHAR',
    alertOption: AlertOption.values.firstWhere(
      (a) => a.name == json['alert_option'],
      orElse: () => AlertOption.sameDay,
    ),
    // Supabase returns a real bool; the local sqlite cache stores 0/1
    // (sqflite has no boolean column type), so accept either.
    isSettled: switch (json['is_settled']) {
      bool b => b,
      int i => i != 0,
      _ => false,
    },
    note: json['note'] as String? ?? '',
    createdAt: json['created_at'] != null
        ? DateTime.parse(json['created_at'] as String)
        : DateTime.now(),
    updatedAt: json['updated_at'] != null
        ? DateTime.parse(json['updated_at'] as String)
        : DateTime.now(),
  );
}
