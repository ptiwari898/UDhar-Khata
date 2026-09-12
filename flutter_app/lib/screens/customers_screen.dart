import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';
import '../widgets/modals.dart';
import 'customer_detail_screen.dart';

class CustomersScreen extends StatefulWidget {
  final LedgerState state;
  const CustomersScreen({super.key, required this.state});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  String _search = '';
  String _sortBy = 'HighToLow'; // HighToLow, LowToHigh, Name

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    var customerSummaries = state.customers.map(state.getCustomerSummary).toList();

    // Filter
    if (_search.isNotEmpty) {
      customerSummaries = customerSummaries.where((s) {
        return s.customer.name.toLowerCase().contains(_search.toLowerCase()) ||
            s.customer.phone.contains(_search);
      }).toList();
    }

    // Sort
    if (_sortBy == 'HighToLow') {
      customerSummaries.sort((a, b) => b.currentOutstanding.compareTo(a.currentOutstanding));
    } else if (_sortBy == 'LowToHigh') {
      customerSummaries.sort((a, b) => a.currentOutstanding.compareTo(b.currentOutstanding));
    } else {
      customerSummaries.sort((a, b) => a.customer.name.compareTo(b.customer.name));
    }

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: const Color(0xFF062622),
        icon: const Icon(Icons.person_add),
        label: const Text('Add Customer', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => Modals.showAddCustomer(context, state),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Customers Directory', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text('${customerSummaries.length} Total Customers', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
              DropdownButton<String>(
                value: _sortBy,
                dropdownColor: AppColors.cardSurface,
                style: const TextStyle(color: AppColors.primaryBlue, fontSize: 12, fontWeight: FontWeight.bold),
                underline: const SizedBox(),
                items: const [
                  DropdownMenuItem(value: 'HighToLow', child: Text('Sort: High Udhar')),
                  DropdownMenuItem(value: 'LowToHigh', child: Text('Sort: Low Udhar')),
                  DropdownMenuItem(value: 'Name', child: Text('Sort: Name')),
                ],
                onChanged: (v) {
                  if (v != null) setState(() => _sortBy = v);
                },
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Field
          GlassCard(
            radius: 16,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              onChanged: (v) => setState(() => _search = v),
              style: const TextStyle(color: AppColors.textPrimary),
              decoration: const InputDecoration(
                hintText: 'Search customer name or phone...',
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                prefixIcon: Icon(Icons.search, color: AppColors.primaryBlue),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Customer List
          ...customerSummaries.map((summary) {
            final cust = summary.customer;
            final isDue = summary.currentOutstanding > 0;
            final isAdvance = summary.currentOutstanding < 0;
            final balanceColor = isDue
                ? AppColors.redUdhar
                : (isAdvance ? AppColors.greenAdvance : AppColors.textSecondary);

            final riskColor = cust.riskLevel == 'High'
                ? AppColors.redUdhar
                : (cust.riskLevel == 'Medium' ? AppColors.orangeMedium : AppColors.greenAdvance);

            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: GlassCard(
                radius: 18,
                padding: const EdgeInsets.all(14),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CustomerDetailScreen(customer: cust, state: state),
                    ),
                  );
                },
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.primaryBlueBg,
                      child: Text(
                        cust.name.isNotEmpty ? cust.name[0].toUpperCase() : 'C',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(cust.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: riskColor.withValues(alpha: 0.15),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: riskColor.withValues(alpha: 0.4)),
                                ),
                                child: Text(
                                  cust.riskLevel,
                                  style: TextStyle(color: riskColor, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text('${cust.phone} • ${cust.location}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹ ${summary.currentOutstanding.abs().toInt()}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: balanceColor),
                        ),
                        Text(
                          isDue ? 'Due' : (isAdvance ? 'Advance' : 'Settled'),
                          style: TextStyle(fontSize: 10, color: balanceColor.withValues(alpha: 0.8), fontWeight: FontWeight.w600),
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
    );
  }
}
