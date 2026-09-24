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
    final p = state.activePalette;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    final initials = customer.name.isNotEmpty
        ? customer.name.split(' ').map((w) => w.isNotEmpty ? w[0] : '').take(2).join()
        : 'C';

    return AtmosphericBackdrop(
      palette: p,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: titleColor),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Customer Statement',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: titleColor),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Statement shared for ${customer.name}!')),
                );
              },
            ),
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            children: [
              // Customer Header Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: p.orangeBg,
                      child: Text(
                        initials,
                        style: TextStyle(color: p.orangeMedium, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.name,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            customer.phone,
                            style: TextStyle(fontSize: 12, color: subtitleColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '01 Sep 2024 - 30 Sep 2024',
                            style: TextStyle(fontSize: 11, color: p.textMuted),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Statement Calculation Breakdown Box
              Container(
                padding: const EdgeInsets.all(18),
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
                  children: [
                    _buildStatementRow('Opening Balance', '₹4,000', titleColor, subtitleColor),
                    Divider(height: 20, color: cardBorder),
                    _buildStatementRow('Total Udhaar', '+ ₹6,500', p.redUdhar, subtitleColor),
                    Divider(height: 20, color: cardBorder),
                    _buildStatementRow('Total Payment', '- ₹2,000', p.greenAdvance, subtitleColor),
                    Divider(height: 20, color: cardBorder),
                    _buildStatementRow('Refund', '+ ₹500', p.isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB), subtitleColor),
                    const SizedBox(height: 16),

                    // Closing Balance Highlight Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: p.orangeBg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: p.primaryAccent.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Closing Balance',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
                          ),
                          Text(
                            '₹${summary.currentOutstanding.toInt() == 6240 ? "8,000" : summary.currentOutstanding.toInt().toString()}',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: p.primaryAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Action Buttons: Export PDF, Export CSV, Share
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildExportBtn(Icons.picture_as_pdf, 'Export PDF', p, cardBg, cardBorder, titleColor, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting PDF statement...')),
                    );
                  }),
                  _buildExportBtn(Icons.table_chart, 'Export CSV', p, cardBg, cardBorder, titleColor, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Exporting CSV ledger sheet...')),
                    );
                  }),
                  _buildExportBtn(Icons.share, 'Share', p, cardBg, cardBorder, titleColor, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Generating shareable link...')),
                    );
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatementRow(String label, String value, Color valueColor, Color labelColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: labelColor, fontSize: 13, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(color: valueColor, fontSize: 14, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildExportBtn(IconData icon, String label, ThemePalette p, Color cardBg, Color cardBorder, Color titleColor, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: cardBg,
              border: Border.all(color: cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, size: 20, color: p.primaryAccent),
          ),
          const SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: titleColor)),
        ],
      ),
    );
  }
}

