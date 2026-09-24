import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

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
    final p = state.activePalette;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: titleColor),
          onPressed: () => Navigator.maybePop(context),
        ),
        title: Text(
          'Reports',
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
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
              color: cardBg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: cardBorder),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(Icons.chevron_left, color: subtitleColor, size: 20),
                Row(
                  children: [
                    Text(
                      '01 Sep - 30 Sep 2024',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.calendar_today, size: 16, color: p.primaryAccent),
                  ],
                ),
                Icon(Icons.chevron_right, color: subtitleColor, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Interval Tabs: Daily, Monthly, Yearly
          Row(
            children: [
              _buildTab('Daily', p, cardBg, cardBorder, titleColor),
              const SizedBox(width: 8),
              _buildTab('Monthly', p, cardBg, cardBorder, titleColor),
              const SizedBox(width: 8),
              _buildTab('Yearly', p, cardBg, cardBorder, titleColor),
            ],
          ),
          const SizedBox(height: 16),

          // 2x2 Metric Grid
          Row(
            children: [
              _buildMetricCard('Total Credit', '₹58,400', p.redUdhar, cardBg, cardBorder, subtitleColor),
              const SizedBox(width: 12),
              _buildMetricCard('Total Collection', '₹42,600', p.greenAdvance, cardBg, cardBorder, subtitleColor),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildMetricCard('Outstanding', '₹1,24,580', titleColor, cardBg, cardBorder, subtitleColor),
              const SizedBox(width: 12),
              _buildMetricCard('Recovery Rate', '72%', p.isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB), cardBg, cardBorder, subtitleColor),
            ],
          ),
          const SizedBox(height: 20),

          // Daily Collection vs Credit Bar Chart Card
          Container(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Daily Collection vs Credit',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor),
                    ),
                    Row(
                      children: [
                        _buildLegend(p.isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB), 'Collection', subtitleColor),
                        const SizedBox(width: 8),
                        _buildLegend(p.primaryAccent, 'Credit', subtitleColor),
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
                      _buildBarGroup('1 Sep', 60, 45, p),
                      _buildBarGroup('5 Sep', 85, 90, p),
                      _buildBarGroup('10 Sep', 40, 70, p),
                      _buildBarGroup('15 Sep', 95, 60, p),
                      _buildBarGroup('20 Sep', 70, 80, p),
                      _buildBarGroup('25 Sep', 55, 30, p),
                      _buildBarGroup('30 Sep', 80, 50, p),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Top Customers Breakdown
          Text(
            'Top Customers',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: titleColor),
          ),
          const SizedBox(height: 10),

          _buildTopCustomerRow(1, 'Ramesh Kumar', '₹8,240', p.orangeBg, p.orangeMedium, cardBg, cardBorder, titleColor),
          _buildTopCustomerRow(2, 'Maa Traders', '₹15,200', p.orangeBg, p.orangeMedium, cardBg, cardBorder, titleColor),
          _buildTopCustomerRow(3, 'Sanjay Verma', '₹2,500', p.greenBg, p.greenAdvance, cardBg, cardBorder, titleColor),
        ],
      ),
    );
  }

  Widget _buildTab(String label, ThemePalette p, Color cardBg, Color cardBorder, Color titleColor) {
    final isSelected = _selectedInterval == label;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedInterval = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? p.primaryAccent : cardBg,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: isSelected ? p.primaryAccent : cardBorder),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? p.textDarkOnWhite : titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMetricCard(String label, String value, Color valueColor, Color cardBg, Color cardBorder, Color subtitleColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cardBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: subtitleColor, fontSize: 11)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: valueColor)),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend(Color color, String label, Color subtitleColor) {
    return Row(
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: subtitleColor)),
      ],
    );
  }

  Widget _buildBarGroup(String date, double h1, double h2, ThemePalette p) {
    final color1 = p.isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB);
    final color2 = p.primaryAccent;

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              width: 8,
              height: h1,
              decoration: BoxDecoration(color: color1, borderRadius: BorderRadius.circular(3)),
            ),
            const SizedBox(width: 3),
            Container(
              width: 8,
              height: h2,
              decoration: BoxDecoration(color: color2, borderRadius: BorderRadius.circular(3)),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(date, style: TextStyle(fontSize: 9, color: p.textMuted)),
      ],
    );
  }

  Widget _buildTopCustomerRow(int rank, String name, String amount, Color avatarBg, Color avatarColor, Color cardBg, Color cardBorder, Color titleColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cardBorder),
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
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor),
            ),
          ),
          Text(
            amount,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
          ),
        ],
      ),
    );
  }
}

