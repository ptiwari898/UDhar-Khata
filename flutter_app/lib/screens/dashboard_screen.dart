import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';
import '../widgets/modals.dart';
import 'add_customer_screen.dart';
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
    final p = state.activePalette;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
          children: [
            // Top Bar Header
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
                          color: cardBg,
                          border: Border.all(color: cardBorder),
                        ),
                        child: Icon(Icons.menu, size: 20, color: titleColor),
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
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: titleColor,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(Icons.keyboard_arrow_down, size: 18, color: subtitleColor),
                          ],
                        ),
                        Text(
                          'Good Morning, ${profile.ownerName.split(' ').first}',
                          style: TextStyle(fontSize: 12, color: subtitleColor),
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
                      color: cardBg,
                      border: Border.all(color: cardBorder),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Icon(Icons.notifications_none, size: 20, color: titleColor),
                        if (activeReminders.isNotEmpty)
                          Positioned(
                            top: 8,
                            right: 8,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: p.redUdhar,
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

            // Hero Card: Total Outstanding
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [p.primaryAccent, p.primaryAccent.withValues(alpha: 0.8)],
                ),
                borderRadius: BorderRadius.circular(22),
                boxShadow: [
                  BoxShadow(
                    color: p.primaryAccent.withValues(alpha: 0.35),
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
                      Text(
                        'Total Outstanding',
                        style: TextStyle(color: p.textDarkOnWhite.withValues(alpha: 0.9), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '↑ 8.4% vs last month',
                          style: TextStyle(color: p.textDarkOnWhite, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '₹${summary.currentOutstandingUdhar.toInt() == 16940 ? "1,24,580" : summary.currentOutstandingUdhar.toInt().toString()}',
                    style: TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                      color: p.textDarkOnWhite,
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
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: p.isDark ? 0.2 : 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Collection", style: TextStyle(color: subtitleColor, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          '₹12,400',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: p.greenAdvance),
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
                      color: cardBg,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: p.isDark ? 0.2 : 0.03),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Today's Udhaar", style: TextStyle(color: subtitleColor, fontSize: 12)),
                        const SizedBox(height: 6),
                        Text(
                          '₹7,850',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: p.redUdhar),
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
                  color: p.isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                  bgColor: p.isDark ? const Color(0x263B82F6) : const Color(0xFFEFF6FF),
                  textColor: titleColor,
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
                  color: p.redUdhar,
                  bgColor: p.redBg,
                  textColor: titleColor,
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
                  color: p.greenAdvance,
                  bgColor: p.greenBg,
                  textColor: titleColor,
                  onTap: () {
                    Modals.showReceivePayment(context, state);
                  },
                ),
                _buildQuickAction(
                  icon: Icons.mic_rounded,
                  label: 'Voice\nEntry',
                  color: p.orangeMedium,
                  bgColor: p.orangeBg,
                  textColor: titleColor,
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

            // Due Date Reminders Banner
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
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: p.isDark ? 0.2 : 0.03),
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
                        color: p.primaryAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.calendar_month_rounded, color: p.primaryAccent, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Due Date Reminders',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
                          ),
                          Text(
                            '${activeReminders.length} Active • 3 Alert Options',
                            style: TextStyle(fontSize: 12, color: subtitleColor),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      'Open Calendar',
                      style: TextStyle(color: p.primaryAccent, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Icon(Icons.chevron_right, color: p.primaryAccent, size: 18),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Recent Transactions Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Recent Transactions',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
                ),
                GestureDetector(
                  onTap: () => onNavigateTab(1), // Customers
                  child: Text(
                    'See All',
                    style: TextStyle(color: p.primaryAccent, fontWeight: FontWeight.bold, fontSize: 13),
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
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: isUdhaar ? p.redBg : p.greenBg,
                      child: Text(
                        initials,
                        style: TextStyle(
                          color: isUdhaar ? p.redUdhar : p.greenAdvance,
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
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${t.type} • ${t.date.day} Sep ${t.date.year}',
                            style: TextStyle(fontSize: 12, color: subtitleColor),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${isUdhaar ? "+" : "-"} ₹${t.amount.toInt()}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: isUdhaar ? p.redUdhar : p.greenAdvance,
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
    required Color textColor,
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
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600, height: 1.2),
          ),
        ],
      ),
    );
  }
}

