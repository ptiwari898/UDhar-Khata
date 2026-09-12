import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class CustomerStatementScreen extends StatelessWidget {
  final Customer customer;
  final LedgerState state;

  const CustomerStatementScreen({
    super.key,
    required this.customer,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final summary = state.getCustomerSummary(customer);
    final profile = state.shopProfile;
    final txns = state.transactions.where((t) => t.customerId == customer.id).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundSlate,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Customer Statement', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: AppColors.primaryBlue),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Sharing statement for ${customer.name}...')),
              );
            },
          ),
        ],
      ),
      body: AtmosphericBackdrop(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            GlassCard(
              radius: 20,
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Merchant Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.shopName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryBlue)),
                          Text(profile.ownerName, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          Text(profile.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlueBg,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('STATEMENT', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 11)),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white12),

                  // Customer Details
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Billed To:', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text(customer.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Date:', style: TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          Text('${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}', style: const TextStyle(color: AppColors.textPrimary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white12),

                  // Transactions Summary Table
                  const Text('Ledger Breakdown', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const SizedBox(height: 10),
                  ...txns.map((t) {
                    final isU = t.type.toUpperCase() == 'UDHAAR';
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(t.note.isNotEmpty ? t.note : t.type, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                              Text('${t.date.day}/${t.date.month} • ${t.paymentMethod}', style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
                            ],
                          ),
                          Text(
                            '${isU ? '-' : '+'} ₹ ${t.amount.toInt()}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: isU ? AppColors.redUdhar : AppColors.greenAdvance, fontSize: 13),
                          ),
                        ],
                      ),
                    );
                  }),

                  const Divider(height: 24, color: Colors.white12),

                  // Total Balance Due
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Net Outstanding:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                      Text(
                        '₹ ${summary.currentOutstanding.abs().toInt()}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: summary.currentOutstanding > 0 ? AppColors.redUdhar : AppColors.greenAdvance,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // UPI Payment Info & QR Box
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.white12),
                      ),
                      child: Column(
                        children: [
                          const Text('📱 Scan / Pay via UPI', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                          const SizedBox(height: 10),
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.qr_code_2, size: 120, color: Colors.black),
                          ),
                          const SizedBox(height: 8),
                          Text('UPI ID: ${profile.upiId}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
