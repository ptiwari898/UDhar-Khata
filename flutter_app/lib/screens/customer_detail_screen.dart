import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../widgets/modals.dart';
import 'customer_chat_screen.dart';
import 'customer_statement_screen.dart';
import 'send_reminder_screen.dart';
import 'upi_payment_screen.dart';

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

class _CustomerDetailScreenState extends State<CustomerDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final customer = state.customers.where((c) => c.id == widget.customer.id).firstOrNull ?? widget.customer;
    final summary = state.getCustomerSummary(customer);
    final txns = state.transactions.where((t) => t.customerId == customer.id).toList();
    final orders = state.orders.where((o) => o.customerId == customer.id).toList();

    final isOverdue = summary.currentOutstanding > 3500;
    final isSettled = summary.currentOutstanding == 0;
    final statusText = isSettled ? 'Settled' : (isOverdue ? 'Overdue' : 'Active');
    final badgeBg = isSettled
        ? const Color(0xFFF3F4F6)
        : (isOverdue ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7));
    final badgeTextColor = isSettled
        ? const Color(0xFF6B7280)
        : (isOverdue ? const Color(0xFFDC2626) : const Color(0xFF16A34A));

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: const Color(0xFFFED7AA),
              child: Text(
                customer.name.isNotEmpty ? customer.name[0] : 'C',
                style: const TextStyle(color: Color(0xFFC2410C), fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              customer.name,
              style: const TextStyle(color: Color(0xFF1E1E1E), fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badgeBg,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                statusText,
                style: TextStyle(color: badgeTextColor, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long, color: Color(0xFF1E1E1E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CustomerStatementScreen(customer: customer, state: state)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.chat_outlined, color: Color(0xFF1E1E1E)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => CustomerChatScreen(customer: customer, state: state)),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDF7528),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Modals.showAddUdhar(context, state, initialCustomerId: customer.id),
                  child: const Text('Give Udhaar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF16A34A),
                    side: const BorderSide(color: Color(0xFF16A34A), width: 1.5),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => Modals.showReceivePayment(context, state, initialCustomerId: customer.id),
                  child: const Text('Receive Payment', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
        children: [
          // 4 Action Buttons Row (Call, WhatsApp, UPI, More)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                icon: Icons.call_outlined,
                label: 'Call',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Calling ${customer.phone}...')),
                  );
                },
              ),
              _buildActionButton(
                icon: Icons.chat,
                label: 'WhatsApp',
                iconColor: const Color(0xFF25D366),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => SendReminderScreen(
                        state: state,
                        customer: customer,
                        amount: summary.currentOutstanding,
                      ),
                    ),
                  );
                },
              ),
              _buildActionButton(
                icon: Icons.qr_code,
                label: 'UPI',
                iconColor: const Color(0xFF2563EB),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => UpiPaymentScreen(
                        state: state,
                        customer: customer,
                        amount: summary.currentOutstanding,
                      ),
                    ),
                  );
                },
              ),
              _buildActionButton(
                icon: Icons.more_horiz,
                label: 'More',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => CustomerStatementScreen(customer: customer, state: state)),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Outstanding Summary Card (Screen 7)
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Outstanding', style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  '₹${summary.currentOutstanding.toInt()}',
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Credit', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(
                            '₹${summary.totalUdhar.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E1E1E)),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Total Payment', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(
                            '₹${summary.totalPaid.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E1E1E)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Last Transaction', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                          const SizedBox(height: 2),
                          Text(
                            txns.isNotEmpty ? '${txns.first.date.day} Sep ${txns.first.date.year}' : '12 Sep 2024',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E1E)),
                          ),
                        ],
                      ),
                    ),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer Since', style: TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
                          SizedBox(height: 2),
                          Text('Jan 2024', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E1E))),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),

          // Tabs: Transactions, Orders, Notes
          TabBar(
            controller: _tabController,
            labelColor: const Color(0xFF1E1E1E),
            unselectedLabelColor: const Color(0xFF9CA3AF),
            indicatorColor: const Color(0xFFDF7528),
            indicatorWeight: 3,
            tabs: const [
              Tab(text: 'Transactions'),
              Tab(text: 'Orders'),
              Tab(text: 'Notes'),
            ],
          ),
          const SizedBox(height: 12),

          // Transactions Timeline List
          ...txns.map((t) {
            final isUdhaar = t.type.toUpperCase() == 'UDHAAR';
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isUdhaar ? const Color(0xFFFFEDD5) : const Color(0xFFDCFCE7),
                    ),
                    child: Icon(
                      isUdhaar ? Icons.arrow_outward : Icons.arrow_downward,
                      size: 18,
                      color: isUdhaar ? const Color(0xFFEA580C) : const Color(0xFF16A34A),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${t.date.day} Sep ${t.date.year} • ${t.type}${t.note.isNotEmpty ? ' - ${t.note}' : ''}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E1E)),
                        ),
                        Text(
                          'Mode: ${t.paymentMethod}',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isUdhaar ? "+" : "-"} ₹${t.amount.toInt()}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: isUdhaar ? const Color(0xFFDC2626) : const Color(0xFF16A34A),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    Color? iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE5E7EB)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: iconColor ?? const Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF4B5563)),
          ),
        ],
      ),
    );
  }
}
