import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';
import '../widgets/modals.dart';

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
    final totalTurnover = summary.totalLoanedTillDate + summary.totalRepaid;
    final collectionPercent = totalTurnover > 0
        ? (summary.totalRepaid / totalTurnover).clamp(0.0, 1.0)
        : 0.85;

    return ListView(
      padding: const EdgeInsets.fromLTRB(18, 8, 18, 110),
      children: [
        // Minimalist Top Bar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                BouncyWidget(
                  onTap: onOpenDrawer,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.16),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                    ),
                    child: const Icon(Icons.menu, color: AppColors.textPrimary, size: 20),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.shopName.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Text(
                      '${DateTime.now().day} September • Daily Ledger',
                      style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                BouncyWidget(
                  onTap: () => onNavigateTab(3), // Profile
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withValues(alpha: 0.35), width: 1.5),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFDF8532).withValues(alpha: 0.35),
                          blurRadius: 10,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 20),

        // Grand "Total to Collect" Hero Card (Matching reference mindset score style)
        GlassCard(
          radius: 28,
          padding: const EdgeInsets.all(22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'TOTAL TO COLLECT',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.1,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.20),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withValues(alpha: 0.35)),
                    ),
                    child: Text(
                      '${summary.customerBreakdown.where((c) => c.currentOutstanding > 0).length} Pending',
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '₹ ${summary.currentOutstandingUdhar.toInt()}',
                style: const TextStyle(
                  fontSize: 38,
                  fontWeight: FontWeight.w900,
                  color: AppColors.textPrimary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 18),

              // Smooth rounded metric slider (Matching reference design)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Collection Efficiency',
                        style: TextStyle(fontSize: 12, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '${(collectionPercent * 100).toInt()}%',
                        style: const TextStyle(fontSize: 13, color: AppColors.textPrimary, fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    height: 10,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: FractionallySizedBox(
                      alignment: Alignment.centerLeft,
                      widthFactor: collectionPercent,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.buttonSolidWhite,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withValues(alpha: 0.5),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // 2 Big Prominent Action Buttons (Matching "Share Results" & "Get Started" from image)
        Row(
          children: [
            // Give Udhar Pill (Frosted Glass)
            Expanded(
              child: BouncyWidget(
                onTap: () => Modals.showAddUdhar(context, state),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.4)),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: AppColors.textPrimary, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Give Udhar',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Receive Payment Pill (Solid Pure White Button)
            Expanded(
              child: BouncyWidget(
                onTap: () => Modals.showReceivePayment(context, state),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: AppColors.buttonSolidWhite,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 14,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_downward, color: AppColors.textDarkOnWhite, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Receive Money',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDarkOnWhite,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Secondary Action Bubbles Row (Voice AI & Orders)
        Row(
          children: [
            Expanded(
              child: _ActionBubble(
                icon: Icons.mic,
                title: 'AI Voice Entry',
                subtitle: 'Speak in Hindi / English',
                onTap: () => Modals.showVoiceModal(context, state),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionBubble(
                icon: Icons.shopping_bag_outlined,
                title: 'New Order',
                subtitle: 'Track advance deposit',
                onTap: () => Modals.showAddOrder(context, state),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),

        // Recent Activity Section
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Ledger Activity',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
            ),
            TextButton(
              onPressed: () => onNavigateTab(1), // Customers
              child: const Text('View All', style: TextStyle(color: AppColors.textSecondary, fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Activity Cards with Pure White Circular Avatars
        ...state.transactions.take(4).map((txn) {
          final cust = state.customers.where((c) => c.id == txn.customerId).firstOrNull;
          final isUdhar = txn.type.toUpperCase() == 'UDHAAR';

          return Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GlassCard(
              radius: 20,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                children: [
                  // Pure White Initial Bubble
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        cust?.name.isNotEmpty == true ? cust!.name[0].toUpperCase() : 'C',
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textDarkOnWhite,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cust?.name ?? 'Customer',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${txn.note} • ${txn.paymentMethod}',
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  // Amount Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isUdhar
                          ? Colors.white.withValues(alpha: 0.15)
                          : AppColors.buttonSolidWhite,
                      borderRadius: BorderRadius.circular(14),
                      border: isUdhar ? Border.all(color: Colors.white.withValues(alpha: 0.3)) : null,
                    ),
                    child: Text(
                      '${isUdhar ? '-' : '+'} ₹ ${txn.amount.toInt()}',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 13,
                        color: isUdhar ? AppColors.textPrimary : AppColors.textDarkOnWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ActionBubble extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ActionBubble({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BouncyWidget(
      onTap: onTap,
      child: GlassCard(
        radius: 20,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: Icon(icon, color: AppColors.textDarkOnWhite, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
