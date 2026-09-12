import 'dart:convert';
import 'dart:io';
import '../models/models.dart';

class LocalStorageService {
  static const String _fileName = 'udhar_khata_database.json';

  Future<File?> _getLocalFile() async {
    try {
      final dir = Directory.systemTemp;
      return File('${dir.path}/$_fileName');
    } catch (_) {
      return null;
    }
  }

  Future<bool> saveState({
    required ShopProfile shopProfile,
    required UserAuthProfile? currentUser,
    required List<Customer> customers,
    required List<LedgerTransaction> transactions,
    required List<CustomerOrder> orders,
    required List<ChatMessage> chatMessages,
    required List<PaymentReminder> reminders,
  }) async {
    try {
      final file = await _getLocalFile();
      if (file == null) return false;

      final data = {
        'version': 1,
        'savedAt': DateTime.now().toIso8601String(),
        'shopProfile': shopProfile.toJson(),
        'currentUser': currentUser?.toJson(),
        'customers': customers.map((c) => c.toJson()).toList(),
        'transactions': transactions.map((t) => t.toJson()).toList(),
        'orders': orders.map((o) => o.toJson()).toList(),
        'chatMessages': chatMessages.map((m) => m.toJson()).toList(),
        'reminders': reminders.map((r) => r.toJson()).toList(),
      };

      await file.writeAsString(jsonEncode(data), flush: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadState() async {
    try {
      final file = await _getLocalFile();
      if (file == null || !await file.exists()) return null;

      final raw = await file.readAsString();
      if (raw.trim().isEmpty) return null;

      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

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
