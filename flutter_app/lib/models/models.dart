class ShopProfile {
  final int id;
  final String shopName;
  final String ownerName;
  final String phone;
  final String location;
  final String address;
  final String upiId;
  final String gstin;
  final String email;

  const ShopProfile({
    this.id = 1,
    required this.shopName,
    required this.ownerName,
    required this.phone,
    this.location = 'Bhopal, MP',
    this.address = 'Shop No. 12, Main Market, Bhopal, MP',
    this.upiId = 'shivamkirana@upi',
    this.gstin = '23AAAAA0000A1Z5',
    this.email = 'merchant@udharkhata.com',
  });

  ShopProfile copyWith({
    String? shopName,
    String? ownerName,
    String? phone,
    String? location,
    String? address,
    String? upiId,
    String? gstin,
    String? email,
  }) {
    return ShopProfile(
      id: id,
      shopName: shopName ?? this.shopName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      address: address ?? this.address,
      upiId: upiId ?? this.upiId,
      gstin: gstin ?? this.gstin,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'shopName': shopName,
    'ownerName': ownerName,
    'phone': phone,
    'location': location,
    'address': address,
    'upiId': upiId,
    'gstin': gstin,
    'email': email,
  };

  factory ShopProfile.fromJson(Map<String, dynamic> json) => ShopProfile(
    id: json['id'] as int? ?? 1,
    shopName: json['shopName'] as String? ?? 'Shop',
    ownerName: json['ownerName'] as String? ?? 'Merchant',
    phone: json['phone'] as String? ?? '',
    location: json['location'] as String? ?? 'Bhopal, MP',
    address: json['address'] as String? ?? '',
    upiId: json['upiId'] as String? ?? 'merchant@upi',
    gstin: json['gstin'] as String? ?? '',
    email: json['email'] as String? ?? '',
  );
}

class Customer {
  final int id;
  final String name;
  final String phone;
  final String location;
  final String riskLevel; // 'High', 'Medium', 'Low'
  final double creditLimit;
  final String notes;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    this.riskLevel = 'Low',
    this.creditLimit = 15000.0,
    this.notes = '',
  });

  Customer copyWith({
    String? name,
    String? phone,
    String? location,
    String? riskLevel,
    double? creditLimit,
    String? notes,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      riskLevel: riskLevel ?? this.riskLevel,
      creditLimit: creditLimit ?? this.creditLimit,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'location': location,
    'riskLevel': riskLevel,
    'creditLimit': creditLimit,
    'notes': notes,
  };

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'] as int,
    name: json['name'] as String? ?? '',
    phone: json['phone'] as String? ?? '',
    location: json['location'] as String? ?? '',
    riskLevel: json['riskLevel'] as String? ?? 'Low',
    creditLimit: (json['creditLimit'] as num?)?.toDouble() ?? 15000.0,
    notes: json['notes'] as String? ?? '',
  );
}

class LedgerTransaction {
  final int id;
  final int customerId;
  final String type; // 'UDHAAR', 'PAYMENT', 'ADVANCE', 'REFUND', 'ADJUSTMENT'
  final double amount;
  final String note;
  final DateTime date;
  final String paymentMethod; // 'Cash', 'UPI', 'Bank Transfer', 'Other'
  final String reference;

  const LedgerTransaction({
    required this.id,
    required this.customerId,
    required this.type,
    required this.amount,
    this.note = '',
    required this.date,
    this.paymentMethod = 'Cash',
    this.reference = '',
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'type': type,
    'amount': amount,
    'note': note,
    'date': date.toIso8601String(),
    'paymentMethod': paymentMethod,
    'reference': reference,
  };

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) => LedgerTransaction(
    id: json['id'] as int,
    customerId: json['customerId'] as int,
    type: json['type'] as String? ?? 'UDHAAR',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    note: json['note'] as String? ?? '',
    date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
    paymentMethod: json['paymentMethod'] as String? ?? 'Cash',
    reference: json['reference'] as String? ?? '',
  );
}

class CustomerOrder {
  final int id;
  final int customerId;
  final String itemsSummary;
  final double totalAmount;
  final double advancePaid;
  final String status; // 'CONFIRMED', 'READY', 'DELIVERED', 'COMPLETED'
  final DateTime date;

  const CustomerOrder({
    required this.id,
    required this.customerId,
    required this.itemsSummary,
    required this.totalAmount,
    this.advancePaid = 0.0,
    this.status = 'CONFIRMED',
    required this.date,
  });

  CustomerOrder copyWith({
    String? status,
    double? advancePaid,
  }) {
    return CustomerOrder(
      id: id,
      customerId: customerId,
      itemsSummary: itemsSummary,
      totalAmount: totalAmount,
      advancePaid: advancePaid ?? this.advancePaid,
      status: status ?? this.status,
      date: date,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'itemsSummary': itemsSummary,
    'totalAmount': totalAmount,
    'advancePaid': advancePaid,
    'status': status,
    'date': date.toIso8601String(),
  };

  factory CustomerOrder.fromJson(Map<String, dynamic> json) => CustomerOrder(
    id: json['id'] as int,
    customerId: json['customerId'] as int,
    itemsSummary: json['itemsSummary'] as String? ?? '',
    totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
    advancePaid: (json['advancePaid'] as num?)?.toDouble() ?? 0.0,
    status: json['status'] as String? ?? 'CONFIRMED',
    date: json['date'] != null ? DateTime.parse(json['date'] as String) : DateTime.now(),
  );
}

class ChatMessage {
  final int id;
  final int customerId;
  final String sender; // 'SHOP', 'CUSTOMER'
  final String message;
  final String messageType; // 'TEXT', 'BILL', 'PAYMENT'
  final DateTime timestamp;

  const ChatMessage({
    required this.id,
    required this.customerId,
    required this.sender,
    required this.message,
    this.messageType = 'TEXT',
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'sender': sender,
    'message': message,
    'messageType': messageType,
    'timestamp': timestamp.toIso8601String(),
  };

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
    id: json['id'] as int,
    customerId: json['customerId'] as int,
    sender: json['sender'] as String? ?? 'SHOP',
    message: json['message'] as String? ?? '',
    messageType: json['messageType'] as String? ?? 'TEXT',
    timestamp: json['timestamp'] != null ? DateTime.parse(json['timestamp'] as String) : DateTime.now(),
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
  final int id;
  final int customerId;
  final String title;
  final double amount;
  final DateTime dueDate;
  final String reminderType; // 'RECOVER_UDHAR' (Customer debt) or 'PAY_SUPPLIER' (Vendor bill)
  final AlertOption alertOption;
  final bool isSettled;
  final String note;
  final DateTime createdAt;

  const PaymentReminder({
    required this.id,
    required this.customerId,
    required this.title,
    required this.amount,
    required this.dueDate,
    this.reminderType = 'RECOVER_UDHAR',
    this.alertOption = AlertOption.sameDay,
    this.isSettled = false,
    this.note = '',
    required this.createdAt,
  });

  PaymentReminder copyWith({
    int? id,
    int? customerId,
    String? title,
    double? amount,
    DateTime? dueDate,
    String? reminderType,
    AlertOption? alertOption,
    bool? isSettled,
    String? note,
    DateTime? createdAt,
  }) {
    return PaymentReminder(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      title: title ?? this.title,
      amount: amount ?? this.amount,
      dueDate: dueDate ?? this.dueDate,
      reminderType: reminderType ?? this.reminderType,
      alertOption: alertOption ?? this.alertOption,
      isSettled: isSettled ?? this.isSettled,
      note: note ?? this.note,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'title': title,
    'amount': amount,
    'dueDate': dueDate.toIso8601String(),
    'reminderType': reminderType,
    'alertOption': alertOption.name,
    'isSettled': isSettled,
    'note': note,
    'createdAt': createdAt.toIso8601String(),
  };

  factory PaymentReminder.fromJson(Map<String, dynamic> json) => PaymentReminder(
    id: json['id'] as int,
    customerId: json['customerId'] as int? ?? 0,
    title: json['title'] as String? ?? 'Payment Reminder',
    amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
    dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate'] as String) : DateTime.now(),
    reminderType: json['reminderType'] as String? ?? 'RECOVER_UDHAR',
    alertOption: AlertOption.values.firstWhere(
      (a) => a.name == json['alertOption'],
      orElse: () => AlertOption.sameDay,
    ),
    isSettled: json['isSettled'] as bool? ?? false,
    note: json['note'] as String? ?? '',
    createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt'] as String) : DateTime.now(),
  );
}
