import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';
import '../widgets/modals.dart';

class OrdersScreen extends StatelessWidget {
  final LedgerState state;
  const OrdersScreen({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final orders = state.orders;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFA78BFA),
        foregroundColor: const Color(0xFF062622),
        icon: const Icon(Icons.add_shopping_cart),
        label: const Text('Create Order', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: () => Modals.showAddOrder(context, state),
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
                  const Text('Orders & Advances', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  Text('${orders.length} Active Orders', style: const TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...orders.map((order) {
            final cust = state.customers.where((c) => c.id == order.customerId).firstOrNull;
            final due = order.totalAmount - order.advancePaid;

            Color statusColor;
            switch (order.status.toUpperCase()) {
              case 'READY':
                statusColor = AppColors.greenAdvance;
                break;
              case 'DELIVERED':
                statusColor = AppColors.primaryBlue;
                break;
              default:
                statusColor = AppColors.orangeMedium;
                break;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: GlassCard(
                radius: 20,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          cust?.name ?? 'Customer',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                          ),
                          child: Text(
                            order.status,
                            style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      order.itemsSummary,
                      style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
                    ),
                    const Divider(height: 20, color: Colors.white12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Total Bill', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text('₹ ${order.totalAmount.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Advance Paid', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text('₹ ${order.advancePaid.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.greenAdvance)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            const Text('Remaining Due', style: TextStyle(fontSize: 10, color: AppColors.textMuted)),
                            Text('₹ ${due.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.redUdhar)),
                          ],
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
