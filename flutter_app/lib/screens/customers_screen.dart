import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
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
      backgroundColor: const Color(0xFFFAF7F2),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFDF7528),
        foregroundColor: Colors.white,
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
            // Header Bar (Screen 5)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Customers',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                ),
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: const Icon(Icons.qr_code_scanner, size: 20, color: Color(0xFF1E1E1E)),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
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
                  const Icon(Icons.search, color: Color(0xFF9CA3AF), size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: (v) => setState(() => _search = v),
                      style: const TextStyle(color: Color(0xFF1E1E1E), fontSize: 14),
                      decoration: const InputDecoration(
                        hintText: 'Search customers...',
                        hintStyle: TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
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
                  _buildFilterChip('All'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Pending'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Overdue'),
                  const SizedBox(width: 8),
                  _buildFilterChip('Active'),
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
                  ? const Color(0xFFF3F4F6)
                  : (isOverdue ? const Color(0xFFFEE2E2) : const Color(0xFFDCFCE7));
              final badgeTextColor = isSettled
                  ? const Color(0xFF6B7280)
                  : (isOverdue ? const Color(0xFFDC2626) : const Color(0xFF16A34A));

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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
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
                        backgroundColor: isOverdue ? const Color(0xFFFFEDD5) : const Color(0xFFE0E7FF),
                        child: Text(
                          initials,
                          style: TextStyle(
                            color: isOverdue ? const Color(0xFFC2410C) : const Color(0xFF4338CA),
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
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E1E)),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              c.phone,
                              style: const TextStyle(fontSize: 12, color: Color(0xFF6B7280)),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${outstanding.toInt()}',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E1E1E)),
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

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF78350F) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: isSelected ? const Color(0xFF78350F) : const Color(0xFFE5E7EB)),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF4B5563),
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ),
    );
  }
}
