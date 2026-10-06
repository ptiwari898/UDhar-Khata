import 'dart:convert';
import '../models/models.dart';

/// Builds the human-downloadable JSON backup shown in Profile > Backup.
/// Day-to-day persistence now goes through LedgerRepository (sqflite cache
/// + Supabase), not this service.
class LocalStorageService {
  String exportBackupJson({
    required ShopProfile shopProfile,
    required List<Customer> customers,
    required List<LedgerTransaction> transactions,
    required List<CustomerOrder> orders,
    required List<PaymentReminder> reminders,
  }) {
    final data = {
      'app': 'Udhar Khata',
      'author': 'Pawan Tiwari',
      'version': '1.0.0',
      'exportedAt': DateTime.now().toIso8601String(),
      'shopProfile': shopProfile.toJson(),
      'customers': customers.map((c) => c.toJson()).toList(),
      'transactions': transactions.map((t) => t.toJson()).toList(),
      'orders': orders.map((o) => o.toJson()).toList(),
      'reminders': reminders.map((r) => r.toJson()).toList(),
    };
    return const JsonEncoder.withIndent('  ').convert(data);
  }
}
