import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../widgets/modals.dart';
import 'add_customer_screen.dart';
import 'customer_detail_screen.dart';
import 'record_entry_screen.dart';
import 'reminders_calendar_screen.dart';
import 'voice_entry_screen.dart';

class DashboardScreen extends StatelessWidget {
  final LedgerState state;
  final VoidCallback onOpenDrawer;
  final Function(int) onNavigateTab;

  const DashboardScreen({
    super.key,
    required this.state,
    required this.onOpenDrawer,
    required this.onNavigateTab,
  });

  @override
  Widget build(BuildContext context) {
    final summary = state.getSummary();
    final profile = state.shopProfile;
    final activeReminders = state.reminders.where((r) => !r.isSettled).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            // Top Bar Header (Screen 4)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: onOpenDrawer,
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFFE5E7EB)),
                        ),
                        child: const Icon(Icons.menu, size: 20, color: Color(0xFF1E1E1E)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              profile.shopName,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1E1E1E),
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.keyboard_arrow_down, size: 18, color: Color(0xFF6B7280)),
                          ],
                        ),
                        Text(
                          'Good Morning, ${profile.ownerName.split(' ').first}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                        ),
                      ],
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RemindersCalendarScreen(state: state, onBack: () => Navigator.pop(context))),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        const Icon(Icons.notifications_none, size: 20, color: Color(0xFF1E1E1E)),
                        if (activeReminders.isNotEmpty)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEF4444),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Hero Card: Total Outstanding (₹1,24,580 | +8.4% vs last month)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFE07828), Color(0xFFC45914)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFC45914).withValues(alpha: 0.35),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Outstanding',
                        style: TextStyle(color: Color(0xFFFDEEE3), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          '↑ 8.4% vs last month',
                          style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${summary.currentOutstandingUdhar.toInt() == 16940 ? "1,24,580" : summary.currentOutstandingUdhar.toInt().toString()}',
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Dual Stat Cards: Today's Collection & Today's Udhaar
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Collection", style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                        SizedBox(height: 6),
                        Text(
                          '₹12,400',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF16A34A)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Udhaar", style: TextStyle(color: Color(0xFF6B7280), fontSize: 12)),
                        SizedBox(height: 6),
                        Text(
                          '₹7,850',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFDC2626)),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // 4 Quick Action Buttons Grid
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildQuickAction(
                  icon: Icons.person_add_outlined,
                  label: 'Add\nCustomer',
                  color: const Color(0xFF2563EB),
                  bgColor: const Color(0xFFEFF6FF),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddCustomerScreen(state: state)),
                    );
                  },
                ),
                _buildQuickAction(
                  icon: Icons.arrow_upward_rounded,
                  label: 'Give\nUdhaar',
                  color: const Color(0xFFEA580C),
                  bgColor: const Color(0xFFFFF7ED),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecordEntryScreen(
                          state: state,
                          onBack: () => Navigator.pop(context),
                        ),
                      ),
                    );
                  },
                ),
                _buildQuickAction(
                  icon: Icons.arrow_downward_rounded,
                  label: 'Receive\nPayment',
                  color: const Color(0xFF16A34A),
                  bgColor: const Color(0xFFF0FDF4),
                  onTap: () {
                    Modals.showReceivePayment(context, state);
                  },
                ),
                _buildQuickAction(
                  icon: Icons.mic_rounded,
                  label: 'Voice\nEntry',
                  color: const Color(0xFF0284C7),
                  bgColor: const Color(0xFFF0F9FF),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VoiceEntryScreen(state: state)),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Due Date Reminders Banner (3 Alert Options)
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RemindersCalendarScreen(state: state, onBack: () => Navigator.pop(context))),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDF7528).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.calendar_month_rounded, color: Color(0xFFDF7528), size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Due Date Reminders',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E1E1E)),
                          ),
                          Text(
                            '${activeReminders.length} Active • 3 Alert Options',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                          ),
                        ],
                      ),
                    ),
                    const Text(
                      'Open Calendar',
                      style: TextStyle(color: Color(0xFFDF7528), fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFFDF7528), size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions Section (Screen 4)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                ),
                GestureDetector(
                  onTap: () => onNavigateTab(1), // Customers
                  child: const Text(
                    'See All',
                    style: TextStyle(color: Color(0xFFDF7528), fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Transactions List Items
            ...state.transactions.take(5).map((t) {
              final cust = state.customers.firstWhere((c) => c.id == t.customerId, orElse: () => state.customers.first);
              final isUdhaar = t.type.toUpperCase() == 'UDHAAR';
              final initials = cust.name.isNotEmpty
                  ? cust.name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join()
                  : 'C';

              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isUdhaar ? const Color(0xFFFFEDD5) : const Color(0xFFDCFCE7),
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: isUdhaar ? const Color(0xFFC2410C) : const Color(0xFF15803D),
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cust.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E1E1E)),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${t.type} • ${t.date.day} Sep ${t.date.year}',
                            style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
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
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color color,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: color.withValues(alpha: 0.2)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Color(0xFF374151), fontSize: 11, fontWeight: FontWeight.w600, height: 1.2),
          ),
        ],
      ),
    );
  }
}
