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
}

class Customer {
  final int id;
  final String name;
  final String phone;
  final String location;
  final String riskLevel; // 'High', 'Medium', 'Low'
  final String notes;

  const Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.location,
    this.riskLevel = 'Low',
    this.notes = '',
  });

  Customer copyWith({
    String? name,
    String? phone,
    String? location,
    String? riskLevel,
    String? notes,
  }) {
    return Customer(
      id: id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      location: location ?? this.location,
      riskLevel: riskLevel ?? this.riskLevel,
      notes: notes ?? this.notes,
    );
  }
}

class LedgerTransaction {
  final int id;
  final int customerId;
  final String type; // 'UDHAAR', 'PAYMENT', 'ADVANCE', 'REFUND'
  final double amount;
  final String note;
  final DateTime date;
  final String paymentMethod; // 'Cash', 'UPI', 'Bank Transfer'
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
}

class CustomerSummary {
  final Customer customer;
  final double totalUdhar;
  final double totalPaid;
  final double totalAdvance;
  final double currentOutstanding; // > 0 means customer owes money, < 0 means advance with shop

  const CustomerSummary({
    required this.customer,
    required this.totalUdhar,
    required this.totalPaid,
    required this.totalAdvance,
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
}
