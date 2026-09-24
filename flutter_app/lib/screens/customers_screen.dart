import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';
import 'add_customer_screen.dart';
import 'customer_detail_screen.dart';

class CustomersScreen extends StatefulWidget {
  final LedgerState state;
  const CustomersScreen({super.key, required this.state});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _search = '';
  String _selectedFilter = 'All'; // All, Pending, Overdue, Active

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final p = state.activePalette;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    var customerSummaries = state.customers.map(state.getCustomerSummary).toList();

    // Filter by Search
    if (_search.isNotEmpty) {
      customerSummaries = customerSummaries.where((s) {
        return s.customer.name.toLowerCase().contains(_search.toLowerCase()) ||
            s.customer.phone.contains(_search);
      }).toList();
    }

    // Filter by Chip
    if (_selectedFilter == 'Pending') {
      customerSummaries = customerSummaries.where((s) => s.currentOutstanding > 0).toList();
    } else if (_selectedFilter == 'Overdue') {
      customerSummaries = customerSummaries.where((s) => s.currentOutstanding > 3500).toList();
    } else if (_selectedFilter == 'Active') {
      customerSummaries = customerSummaries.where((s) => s.currentOutstanding > 0 && s.currentOutstanding <= 3500).toList();
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: p.primaryAccent,
        foregroundColor: p.textDarkOnWhite,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add, size: 20),
        label: const Text('Add Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddCustomerScreen(state: state)),
          );
        },
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 100),
          children: [
            // Header Bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Customers',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: titleColor),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: cardBg,
                    border: Border.all(color: cardBorder),
                  ),
                  child: Icon(Icons.qr_code_scanner, size: 20, color: titleColor),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: cardBg,
                borderRadius: BorderRadius.circular(14),
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
                  Icon(Icons.search, color: subtitleColor, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      style: TextStyle(color: titleColor, fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search customers...',
                        hintStyle: TextStyle(color: p.textMuted, fontSize: 14),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Filter Chips: All, Pending, Overdue, Active
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('All', p, cardBg, cardBorder, titleColor),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending', p, cardBg, cardBorder, titleColor),
                  const SizedBox(width: 8),
                  _buildFilterChip('Overdue', p, cardBg, cardBorder, titleColor),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active', p, cardBg, cardBorder, titleColor),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Customer Cards
            ...customerSummaries.map((summary) {
              final c = summary.customer;
              final outstanding = summary.currentOutstanding;
              final isOverdue = outstanding > 3500;
              final isSettled = outstanding == 0;
              final statusText = isSettled ? 'Settled' : (isOverdue ? 'Overdue' : 'Active');
              final badgeBg = isSettled
                  ? (p.isDark ? Colors.white12 : const Color(0xFFF3F4F6))
                  : (isOverdue ? p.redBg : p.greenBg);
              final badgeTextColor = isSettled
                  ? subtitleColor
                  : (isOverdue ? p.redUdhar : p.greenAdvance);

              final initials = c.name.isNotEmpty
                  ? c.name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join()
                  : 'C';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerDetailScreen(state: state, customer: c),
                    ),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: cardBorder),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: p.isDark ? 0.2 : 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // Avatar
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: isOverdue ? p.orangeBg : (p.isDark ? const Color(0x336366F1) : const Color(0xFFE0E7FF)),
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: isOverdue ? p.orangeMedium : (p.isDark ? const Color(0xFFA5B4FC) : const Color(0xFF4338CA)),
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
                              c.name,
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: titleColor),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              c.phone,
                              style: TextStyle(fontSize: 12, color: subtitleColor),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${outstanding.toInt()}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeBg,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              statusText,
                              style: TextStyle(
                                color: badgeTextColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
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

  Widget _buildFilterChip(String label, ThemePalette p, Color cardBg, Color cardBorder, Color titleColor) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? p.primaryAccent : cardBg,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? p.primaryAccent : cardBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? p.textDarkOnWhite : titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}

