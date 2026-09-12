import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';

class ReportsScreen extends StatefulWidget {
  final LedgerState state;
  const ReportsScreen({super.key, required this.state});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedInterval = 'Daily'; // Daily, Monthly, Yearly

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final summary = state.getSummary();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: const Text(
          'Reports',
          style: TextStyle(color: Color(0xFF1E1E1E), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(18, 4, 18, 100),
        children: [
          // Date Filter Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.chevron_left, color: Color(0xFF6B7280), size: 20),
                Row(
                  children: [
                    Text(
                      '01 Sep - 30 Sep 2024',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E1E)),
                    ),
                    SizedBox(width: 6),
                    Icon(Icons.calendar_today, size: 16, color: Color(0xFFDF7528)),
                  ],
                ),
                Icon(Icons.chevron_right, color: Color(0xFF6B7280), size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Interval Tabs: Daily, Monthly, Yearly
          Row(
            children: [
              _buildTab('Daily'),
              const SizedBox(width: 8),
              _buildTab('Monthly'),
              const SizedBox(width: 8),
              _buildTab('Yearly'),
            ],
          ),
          const SizedBox(height: 16),

          // 2x2 Metric Grid (Screen 11)
          Row(
            children: [
              _buildMetricCard('Total Credit', '₹58,400', const Color(0xFFDC2626)),
              const SizedBox(width: 12),
              _buildMetricCard('Total Collection', '₹42,600', const Color(0xFF16A34A)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetricCard('Outstanding', '₹1,24,580', const Color(0xFF1E1E1E)),
              const SizedBox(width: 12),
              _buildMetricCard('Recovery Rate', '72%', const Color(0xFF2563EB)),
            ],
          ),
          const SizedBox(height: 20),

          // Daily Collection vs Credit Bar Chart Card
          Container(
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Daily Collection vs Credit',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E1E)),
                    ),
                    Row(
                      children: [
                        _buildLegend(const Color(0xFF2563EB), 'Collection'),
                        const SizedBox(width: 8),
                        _buildLegend(const Color(0xFFDF7528), 'Credit'),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 18),

                // Stylized Bar Chart
                SizedBox(
                  height: 120,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      _buildBarGroup('1 Sep', 60, 45),
                      _buildBarGroup('5 Sep', 85, 90),
                      _buildBarGroup('10 Sep', 40, 70),
                      _buildBarGroup('15 Sep', 95, 60),
                      _buildBarGroup('20 Sep', 70, 80),
                      _buildBarGroup('25 Sep', 55, 30),
                      _buildBarGroup('30 Sep', 80, 50),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Top Customers Breakdown (Screen 11)
          const Text(
            'Top Customers',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E1E)),
          ),
          const SizedBox(height: 10),

          _buildTopCustomerRow(1, 'Ramesh Kumar', '₹8,240', const Color(0xFFFED7AA), const Color(0xFFC2410C)),
          _buildTopCustomerRow(2, 'Maa Traders', '₹15,200', const Color(0xFFFDE68A), const Color(0xFFB45309)),
          _buildTopCustomerRow(3, 'Sanjay Verma', '₹2,500', const Color(0xFFBBF7D0), const Color(0xFF15803D)),
        ],
      ),
    );
  }

  Widget _buildTab(String label) {
    final isSelected = _selectedInterval == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedInterval = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFDF7528) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? const Color(0xFFDF7528) : const Color(0xFFE5E7EB)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color valueColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Color(0xFF6B7280), fontSize: 11)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
      ],
    );
  }

  Widget _buildBarGroup(String date, double h1, double h2) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 8,
              height: h1,
              decoration: BoxDecoration(color: const Color(0xFF2563EB), borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: 3),
            Container(
              width: 8,
              height: h2,
              decoration: BoxDecoration(color: const Color(0xFFDF7528), borderRadius: BorderRadius.circular(3)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(date, style: const TextStyle(fontSize: 9, color: Color(0xFF9CA3AF))),
      ],
    );
  }

  Widget _buildTopCustomerRow(int rank, String name, String amount, Color avatarBg, Color avatarColor) {
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
          CircleAvatar(
            radius: 16,
            backgroundColor: avatarBg,
            child: Text(
              name.isNotEmpty ? name[0] : '$rank',
              style: TextStyle(color: avatarColor, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E1E1E)),
            ),
          ),
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E1E1E)),
          ),
        ],
      ),
    );
  }
}
