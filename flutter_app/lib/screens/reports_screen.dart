import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class ReportsScreen extends StatelessWidget {
  final LedgerState state;
  const ReportsScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final summary = state.getSummary();
    final totalTurnover = summary.totalLoanedTillDate + summary.totalRepaid;
    final collectionRate = totalTurnover > 0 ? ((summary.totalRepaid / totalTurnover) * 100).toInt() : 85;

    final highRiskCount = state.customers.where((c) => c.riskLevel == 'High').length;
    final medRiskCount = state.customers.where((c) => c.riskLevel == 'Medium').length;
    final lowRiskCount = state.customers.where((c) => c.riskLevel == 'Low').length;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const Text('Financial Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Text('Business ledger health & collection metrics', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),

          // Collection Rate Card
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Collection Efficiency', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$collectionRate% Repaid', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.greenAdvance)),
                    const Icon(Icons.trending_up, color: AppColors.greenAdvance, size: 28),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: collectionRate / 100,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(AppColors.greenAdvance),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Risk Exposure Breakdown
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Customer Risk Distribution', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 14),
                Row(
                  children: [
                    _RiskStat(label: 'High Risk', count: highRiskCount, color: AppColors.redUdhar),
                    const SizedBox(width: 8),
                    _RiskStat(label: 'Medium Risk', count: medRiskCount, color: AppColors.orangeMedium),
                    const SizedBox(width: 8),
                    _RiskStat(label: 'Low Risk', count: lowRiskCount, color: AppColors.greenAdvance),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),

          // Monthly Cashflow Breakdown
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('30-Day Ledger Totals', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                const SizedBox(height: 14),
                _StatRow(label: 'Total Credit (Udhar) Given', amount: '₹ ${summary.totalLoanedTillDate.toInt()}', color: AppColors.redUdhar),
                const Divider(height: 18, color: Colors.white12),
                _StatRow(label: 'Total Cash / UPI Received', amount: '₹ ${summary.totalRepaid.toInt()}', color: AppColors.greenAdvance),
                const Divider(height: 18, color: Colors.white12),
                _StatRow(label: 'Advance Balance with Shop', amount: '₹ ${summary.advanceBalance.toInt()}', color: AppColors.primaryBlue),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RiskStat extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const _RiskStat({required this.label, required this.count, required this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.14),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color.withValues(alpha: 0.4)),
        ),
        child: Column(
          children: [
            Text('$count', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: AppColors.textSecondary)),
          ],
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String amount;
  final Color color;

  const _StatRow({required this.label, required this.amount, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
        Text(amount, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: color)),
      ],
    );
  }
}
