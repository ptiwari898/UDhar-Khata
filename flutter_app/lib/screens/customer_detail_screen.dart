import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';
import '../widgets/modals.dart';
import 'customer_chat_screen.dart';
import 'customer_statement_screen.dart';

class CustomerDetailScreen extends StatefulWidget {
  final Customer customer;
  final LedgerState state;

  const CustomerDetailScreen({
    super.key,
    required this.customer,
    required this.state,
  });

  @override
  State<CustomerDetailScreen> createState() => _CustomerDetailScreenState();
}

class _CustomerDetailScreenState extends State<CustomerDetailScreen> {
  String _filter = 'ALL';

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    // Get live customer
    final customer = state.customers.where((c) => c.id == widget.customer.id).firstOrNull ?? widget.customer;
    final summary = state.getCustomerSummary(customer);
    var txns = state.transactions.where((t) => t.customerId == customer.id).toList();

    if (_filter != 'ALL') {
      txns = txns.where((t) => t.type.toUpperCase() == _filter).toList();
    }

    final isDue = summary.currentOutstanding > 0;
    final balanceColor = isDue ? AppColors.redUdhar : AppColors.greenAdvance;

    return Scaffold(
      backgroundColor: AppColors.backgroundSlate,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat_outlined, color: AppColors.primaryBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerChatScreen(customer: customer, state: state),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.receipt_long, color: AppColors.primaryBlue),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CustomerStatementScreen(customer: customer, state: state),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            color: AppColors.cardSurface,
            onSelected: (val) {
              if (val == 'delete') {
                state.deleteCustomer(customer.id);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${customer.name} deleted')),
                );
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: 'delete',
                child: Text('Delete Customer', style: TextStyle(color: AppColors.redUdhar)),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: AppColors.backgroundSlate.withValues(alpha: 0.9),
            border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.redUdhar,
                    foregroundColor: const Color(0xFF601410),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Modals.showAddUdhar(context, state, initialCustomerId: customer.id);
                  },
                  icon: const Icon(Icons.arrow_upward, size: 18),
                  label: const Text('Add Udhar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.greenAdvance,
                    foregroundColor: const Color(0xFF062622),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    Modals.showReceivePayment(context, state, initialCustomerId: customer.id);
                  },
                  icon: const Icon(Icons.arrow_downward, size: 18),
                  label: const Text('Receive Payment', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: AtmosphericBackdrop(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Customer Header Card
            GlassCard(
              radius: 20,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 26,
                        backgroundColor: AppColors.primaryBlueBg,
                        child: Text(
                          customer.name.isNotEmpty ? customer.name[0] : 'C',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.primaryBlue),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                            Text(customer.phone, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                            Text(customer.location, style: const TextStyle(color: AppColors.textMuted, fontSize: 11)),
                          ],
                        ),
                      ),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.greenAdvance.withValues(alpha: 0.2),
                          foregroundColor: AppColors.greenAdvance,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          Modals.showWhatsAppReminder(
                            context,
                            customer,
                            summary.currentOutstanding,
                            state.shopProfile,
                          );
                        },
                        icon: const Icon(Icons.send, size: 14),
                        label: const Text('WhatsApp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                  const Divider(height: 24, color: Colors.white12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Net Balance', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(
                            '₹ ${summary.currentOutstanding.abs().toInt()}',
                            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 24, color: balanceColor),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: balanceColor.withValues(alpha: 0.16),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: balanceColor.withValues(alpha: 0.5)),
                        ),
                        child: Text(
                          isDue ? 'YOU WILL GET' : 'ADVANCE BALANCE',
                          style: TextStyle(color: balanceColor, fontWeight: FontWeight.bold, fontSize: 11),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Filter Tabs
            Row(
              children: ['ALL', 'UDHAAR', 'PAYMENT', 'ADVANCE'].map((f) {
                final isSel = _filter == f;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(f, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isSel ? Colors.black : AppColors.textSecondary)),
                    selected: isSel,
                    selectedColor: AppColors.primaryBlue,
                    backgroundColor: AppColors.cardSurface,
                    onSelected: (_) => setState(() => _filter = f),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 14),

            // Transactions Timeline
            if (txns.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32),
                  child: Text('No transactions recorded yet', style: TextStyle(color: AppColors.textSecondary)),
                ),
              )
            else
              ...txns.map((txn) {
                final isU = txn.type.toUpperCase() == 'UDHAAR';
                final color = isU ? AppColors.redUdhar : AppColors.greenAdvance;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GlassCard(
                    radius: 16,
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: color.withValues(alpha: 0.18),
                          child: Icon(isU ? Icons.north_east : Icons.south_west, color: color, size: 18),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(txn.note.isNotEmpty ? txn.note : txn.type, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                              Text(
                                '${txn.date.day}/${txn.date.month}/${txn.date.year} • ${txn.paymentMethod}',
                                style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          '${isU ? '-' : '+'} ₹ ${txn.amount.toInt()}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color),
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
