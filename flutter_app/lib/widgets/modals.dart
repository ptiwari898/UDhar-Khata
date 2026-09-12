import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

ShapeBorder roundedCornerShape(double radius) => RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius));

class Modals {
  static void showAddCustomer(BuildContext context, LedgerState state) {
    final nameCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final locCtrl = TextEditingController(text: 'Bhopal, MP');
    String selectedRisk = 'Low';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.backgroundSlate,
          shape: roundedCornerShape(20),
          title: const Text('Add New Customer', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameCtrl,
                  decoration: const InputDecoration(labelText: 'Customer Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Mobile Number', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locCtrl,
                  decoration: const InputDecoration(labelText: 'Location / City', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Risk Level: ', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedRisk,
                      dropdownColor: AppColors.cardSurface,
                      items: ['Low', 'Medium', 'High'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedRisk = val);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: const Color(0xFF062622)),
              onPressed: () {
                if (nameCtrl.text.trim().isNotEmpty) {
                  state.addCustomer(
                    name: nameCtrl.text.trim(),
                    phone: phoneCtrl.text.trim(),
                    location: locCtrl.text.trim(),
                    riskLevel: selectedRisk,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${nameCtrl.text.trim()} added successfully!')),
                  );
                }
              },
              child: const Text('Save Customer', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static void showAddUdhar(BuildContext context, LedgerState state, {int? initialCustomerId}) {
    Customer? selectedCust = state.customers.where((c) => c.id == initialCustomerId).firstOrNull ?? state.customers.firstOrNull;
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController(text: 'Grocery Items');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.backgroundSlate,
          shape: roundedCornerShape(20),
          title: const Row(
            children: [
              Icon(Icons.arrow_upward, color: AppColors.redUdhar),
              SizedBox(width: 8),
              Text('Add Udhar / Credit', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Customer>(
                  initialValue: selectedCust,
                  dropdownColor: AppColors.cardSurface,
                  decoration: const InputDecoration(labelText: 'Customer', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCust = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount (₹)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteCtrl,
                  decoration: const InputDecoration(labelText: 'Note (Optional)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.redUdhar, foregroundColor: const Color(0xFF601410)),
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                if (selectedCust != null && amt > 0) {
                  state.addTransaction(
                    customerId: selectedCust!.id,
                    type: 'UDHAAR',
                    amount: amt,
                    note: noteCtrl.text.trim(),
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Added ₹${amt.toInt()} Udhar for ${selectedCust!.name}')),
                  );
                }
              },
              child: const Text('Save Udhar', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static void showReceivePayment(BuildContext context, LedgerState state, {int? initialCustomerId}) {
    Customer? selectedCust = state.customers.where((c) => c.id == initialCustomerId).firstOrNull ?? state.customers.firstOrNull;
    final amountCtrl = TextEditingController();
    final refCtrl = TextEditingController();
    String selectedMethod = 'Cash';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.backgroundSlate,
          shape: roundedCornerShape(20),
          title: const Row(
            children: [
              Icon(Icons.arrow_downward, color: AppColors.greenAdvance),
              SizedBox(width: 8),
              Text('Receive Payment', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Customer>(
                  initialValue: selectedCust,
                  dropdownColor: AppColors.cardSurface,
                  decoration: const InputDecoration(labelText: 'Customer', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCust = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Amount (₹)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 14),
                const Text('Payment Method', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: ['Cash', 'UPI', 'Bank'].map((m) {
                    final isSel = selectedMethod == m;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(m),
                        selected: isSel,
                        selectedColor: AppColors.greenAdvance,
                        backgroundColor: AppColors.cardSurface,
                        onSelected: (_) => setDialogState(() => selectedMethod = m),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: refCtrl,
                  decoration: const InputDecoration(labelText: 'Reference / Remark', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenAdvance, foregroundColor: const Color(0xFF062622)),
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                if (selectedCust != null && amt > 0) {
                  state.addTransaction(
                    customerId: selectedCust!.id,
                    type: 'PAYMENT',
                    amount: amt,
                    paymentMethod: selectedMethod,
                    reference: refCtrl.text.trim(),
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Received ₹${amt.toInt()} payment from ${selectedCust!.name}')),
                  );
                }
              },
              child: const Text('Save Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static void showAddOrder(BuildContext context, LedgerState state) {
    Customer? selectedCust = state.customers.firstOrNull;
    final itemsCtrl = TextEditingController(text: 'Atta 5kg, Rice 2kg, Sugar 1kg');
    final totalCtrl = TextEditingController(text: '750');
    final advCtrl = TextEditingController(text: '200');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.backgroundSlate,
          shape: roundedCornerShape(20),
          title: const Text('Create Grocery Order', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<Customer>(
                  initialValue: selectedCust,
                  dropdownColor: AppColors.cardSurface,
                  decoration: const InputDecoration(labelText: 'Customer', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCust = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: itemsCtrl,
                  decoration: const InputDecoration(labelText: 'Items List', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: totalCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Total Amount (₹)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: advCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Advance Paid (₹)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: const Color(0xFF062622)),
              onPressed: () {
                final total = double.tryParse(totalCtrl.text.trim()) ?? 0;
                final adv = double.tryParse(advCtrl.text.trim()) ?? 0;
                if (selectedCust != null && total > 0) {
                  state.addOrder(
                    customerId: selectedCust!.id,
                    itemsSummary: itemsCtrl.text.trim(),
                    totalAmount: total,
                    advancePaid: adv,
                  );
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Order created successfully!')),
                  );
                }
              },
              child: const Text('Create Order', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static void showWhatsAppReminder(BuildContext context, Customer customer, double outstanding, ShopProfile profile) {
    final formattedAmt = outstanding.toStringAsFixed(0);
    final msg = 'Hello ${customer.name},\n\n'
        'Your pending balance at ${profile.shopName} is Rs. $formattedAmt.\n'
        'UPI ID: ${profile.upiId}\n\n'
        'Please clear when convenient via UPI or Cash.\nThank you!';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSlate,
        shape: roundedCornerShape(20),
        title: const Text('📱 WhatsApp Payment Reminder', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pre-formatted Reminder Message:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
              ),
              child: Text(msg, style: const TextStyle(fontSize: 13, color: AppColors.textPrimary)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.greenAdvance, foregroundColor: const Color(0xFF062622)),
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Opening WhatsApp for ${customer.name}...')),
              );
            },
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Send Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void showVoiceModal(BuildContext context, LedgerState state) {
    final inputCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSlate,
        shape: roundedCornerShape(20),
        title: const Text('🎙️ Voice Entry (Gemini AI)', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryBlue.withValues(alpha: 0.2),
                  border: Border.all(color: AppColors.primaryBlue, width: 2),
                ),
                child: const Icon(Icons.mic, size: 36, color: AppColors.primaryBlue),
              ),
              const SizedBox(height: 14),
              const Text(
                'Speak or type transaction in Hindi or English',
                style: TextStyle(color: AppColors.textSecondary, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: inputCtrl,
                decoration: const InputDecoration(
                  hintText: 'e.g. Rahul ko 500 rupaye udhar diya',
                  hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Examples:\n• Ramesh ko 1200 udhar diya\n• Sanjay ne 1000 cash diya',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: const Color(0xFF062622)),
            onPressed: () {
              final spoken = inputCtrl.text.trim().isNotEmpty
                  ? inputCtrl.text.trim()
                  : 'Ramesh General Store ko 500 udhar diya';
              final parsed = state.parseVoiceText(spoken);
              Navigator.pop(ctx);
              _showVoiceConfirm(context, state, parsed);
            },
            child: const Text('Process AI Voice', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  static void _showVoiceConfirm(BuildContext context, LedgerState state, Map<String, dynamic> parsed) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.backgroundSlate,
        shape: roundedCornerShape(20),
        title: const Text('Confirm AI Transaction', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Raw: "${parsed['note']}"', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryBlueBg.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.4)),
              ),
              child: Column(
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Customer:', style: TextStyle(color: AppColors.textSecondary)),
                    Text(parsed['customerName'], style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  ]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Type:', style: TextStyle(color: AppColors.textSecondary)),
                    Text(parsed['type'], style: TextStyle(fontWeight: FontWeight.bold, color: parsed['type'] == 'UDHAAR' ? AppColors.redUdhar : AppColors.greenAdvance)),
                  ]),
                  const SizedBox(height: 6),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                    const Text('Amount:', style: TextStyle(color: AppColors.textSecondary)),
                    Text('₹ ${parsed['amount'].toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary)),
                  ]),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: const Color(0xFF062622)),
            onPressed: () {
              int? custId = parsed['customerId'];
              if (custId == null) {
                final newCust = state.addCustomer(name: parsed['customerName'], phone: '98765 00000', location: 'Bhopal, MP');
                custId = newCust.id;
              }
              state.addTransaction(
                customerId: custId,
                type: parsed['type'],
                amount: parsed['amount'],
                note: parsed['note'],
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Transaction saved successfully!')),
              );
            },
            child: const Text('Confirm & Save', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
