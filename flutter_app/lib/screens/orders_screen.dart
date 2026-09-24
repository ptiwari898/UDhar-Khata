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
    final p = state.activePalette;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: p.primaryAccent,
        foregroundColor: p.textDarkOnWhite,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        icon: const Icon(Icons.add_shopping_cart, size: 20),
        label: const Text('Create Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
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
                  Text('Orders & Advances', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: titleColor)),
                  Text('${orders.length} Active Orders', style: TextStyle(fontSize: 12, color: subtitleColor)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...orders.map((order) {
            final cust = state.customers.where((c) => c.id == order.customerId).firstOrNull;
            final due = order.totalAmount - order.advancePaid;

            Color statusColor;
            Color statusBg;
            switch (order.status.toUpperCase()) {
              case 'READY':
                statusColor = p.greenAdvance;
                statusBg = p.greenBg;
                break;
              case 'DELIVERED':
                statusColor = p.primaryAccent;
                statusBg = p.primaryAccent.withValues(alpha: 0.18);
                break;
              default:
                statusColor = p.orangeMedium;
                statusBg = p.orangeBg;
                break;
            }

            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: p.isDark ? 0.3 : 0.03),
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
                        Flexible(
                          child: Text(
                            cust?.name ?? 'Customer',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: statusBg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: statusColor.withValues(alpha: 0.4)),
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
                      style: TextStyle(color: subtitleColor, fontSize: 13),
                    ),
                    Divider(height: 20, color: cardBorder),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Total Bill', style: TextStyle(fontSize: 11, color: subtitleColor)),
                            Text('₹ ${order.totalAmount.toInt()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Advance Paid', style: TextStyle(fontSize: 11, color: subtitleColor)),
                            Text('₹ ${order.advancePaid.toInt()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.greenAdvance)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Remaining Due', style: TextStyle(fontSize: 11, color: subtitleColor)),
                            Text('₹ ${due.toInt()}', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.redUdhar)),
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
