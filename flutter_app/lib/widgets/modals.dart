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
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Customer Name',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Mobile Number',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: locCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Location / City',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Risk Level: ', style: TextStyle(color: AppColors.textSecondary)),
                    const SizedBox(width: 8),
                    DropdownButton<String>(
                      value: selectedRisk,
                      dropdownColor: AppColors.dropdownSurface,
                      style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                      borderRadius: BorderRadius.circular(12),
                      items: ['Low', 'Medium', 'High'].map((r) => DropdownMenuItem(value: r, child: Text(r, style: const TextStyle(color: Colors.white)))).toList(),
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
                  dropdownColor: AppColors.dropdownSurface,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  borderRadius: BorderRadius.circular(14),
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                  items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name, style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCust = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: noteCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Note / Items',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
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
                  dropdownColor: AppColors.dropdownSurface,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  borderRadius: BorderRadius.circular(14),
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                  items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name, style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCust = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
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
                        label: Text(m, style: TextStyle(color: isSel ? const Color(0xFF062622) : Colors.white, fontWeight: FontWeight.bold)),
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
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Reference / Remark',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
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
                  dropdownColor: AppColors.dropdownSurface,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  borderRadius: BorderRadius.circular(14),
                  decoration: const InputDecoration(
                    labelText: 'Customer',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                  items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name, style: const TextStyle(color: Colors.white)))).toList(),
                  onChanged: (val) => setDialogState(() => selectedCust = val),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: itemsCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Items List',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: totalCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Total Amount (₹)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: advCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Advance Paid (₹)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
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
    final inputCtrl = TextEditingController(text: 'Ramesh ko 1200 udhar diya');
    bool isListening = false;
    Map<String, dynamic> parsed = state.parseVoiceText(inputCtrl.text);

    final voicePresets = [
      'Ramesh ko 1200 udhar diya',
      'Sanjay se 2000 cash payment mila',
      'Amit Sharma ko 850 udhar',
      'Anita Patel se 3000 advance mila',
      'Pooja Verma ne 500 payment UPI kiya',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          void updateText(String text) {
            setDialogState(() {
              inputCtrl.text = text;
              parsed = state.parseVoiceText(text);
            });
          }

          void startListeningSimulation() {
            setDialogState(() {
              isListening = true;
              inputCtrl.text = 'Listening... बोलिए (Speak now)...';
            });

            // Simulate real-time speech transcription after brief listening pulse
            Future.delayed(const Duration(milliseconds: 1400), () {
              if (ctx.mounted) {
                final randomSample = voicePresets[(DateTime.now().second) % voicePresets.length];
                setDialogState(() {
                  isListening = false;
                  inputCtrl.text = randomSample;
                  parsed = state.parseVoiceText(randomSample);
                });
              }
            });
          }

          final isUdhar = parsed['type'] == 'UDHAAR';
          final isPayment = parsed['type'] == 'PAYMENT';
          final badgeColor = isUdhar
              ? AppColors.redUdhar
              : (isPayment ? AppColors.greenAdvance : AppColors.primaryBlue);

          return AlertDialog(
            backgroundColor: AppColors.backgroundSlate,
            shape: roundedCornerShape(22),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.mic, color: AppColors.primaryBlue, size: 20),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Voice Entry (बोलकर खाता लिखें)',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                      ),
                      Text(
                        'Natural Hindi & English Recognition',
                        style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated Mic Action Center
                  GestureDetector(
                    onTap: startListeningSimulation,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: isListening ? 84 : 74,
                      height: isListening ? 84 : 74,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isListening
                            ? AppColors.redUdhar.withValues(alpha: 0.25)
                            : AppColors.primaryBlue.withValues(alpha: 0.2),
                        border: Border.all(
                          color: isListening ? AppColors.redUdhar : AppColors.primaryBlue,
                          width: isListening ? 3 : 2,
                        ),
                        boxShadow: [
                          if (isListening)
                            BoxShadow(
                              color: AppColors.redUdhar.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 4,
                            ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isListening ? Icons.graphic_eq_rounded : Icons.mic,
                            size: isListening ? 38 : 34,
                            color: isListening ? AppColors.redUdhar : AppColors.primaryBlue,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isListening ? '🎙️ Listening... बोलिए...' : 'Tap Mic to Speak (माइक दबाकर बोलें)',
                    style: TextStyle(
                      color: isListening ? AppColors.redUdhar : AppColors.primaryBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Voice input transcription field
                  TextField(
                    controller: inputCtrl,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 14),
                    onChanged: (val) {
                      setDialogState(() {
                        parsed = state.parseVoiceText(val);
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'e.g. Rahul ko 500 rupaye udhar diya',
                      hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      filled: true,
                      fillColor: AppColors.cardSurface,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear, size: 18, color: AppColors.textSecondary),
                        onPressed: () => updateText(''),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // 1-Tap Voice Phrase Chips
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Quick Voice Samples (तुरंत बोलें):',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: voicePresets.map((sample) {
                      return InkWell(
                        onTap: () => updateText(sample),
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                          decoration: BoxDecoration(
                            color: AppColors.cardSurface.withValues(alpha: 0.8),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.white10),
                          ),
                          child: Text(
                            '🎙️ $sample',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  // Real-time AI Parsed Card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: badgeColor.withValues(alpha: 0.4), width: 1.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('AI Detected Entity', style: TextStyle(color: AppColors.textSecondary, fontSize: 11, fontWeight: FontWeight.bold)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: badgeColor.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                parsed['type'],
                                style: TextStyle(color: badgeColor, fontWeight: FontWeight.bold, fontSize: 11),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '👤 ${parsed['customerName']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                            ),
                            Text(
                              '₹ ${parsed['amount'].toInt()}',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: badgeColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: const Color(0xFF062622),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.check_circle_outline, size: 18),
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
                    SnackBar(
                      content: Text('✅ Saved: ${parsed['type']} ₹${parsed['amount'].toInt()} for ${parsed['customerName']}'),
                      backgroundColor: const Color(0xFF10B981),
                    ),
                  );
                },
                label: const Text('Confirm & Save Entry', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          );
        },
      ),
    );
  }

  static void showVoiceConfirm(BuildContext context, LedgerState state, Map<String, dynamic> parsed) {
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

  static void showAddReminder(BuildContext context, LedgerState state, {int? initialCustomerId, String? initialType}) {
    String reminderType = initialType ?? 'RECOVER_UDHAR';
    Customer? selectedCust = state.customers.where((c) => c.id == initialCustomerId).firstOrNull ?? state.customers.firstOrNull;
    final titleCtrl = TextEditingController(text: selectedCust?.name ?? '');
    final amountCtrl = TextEditingController();
    final noteCtrl = TextEditingController(text: 'Due date payment settlement');
    DateTime selectedDate = DateTime.now().add(const Duration(days: 2));
    AlertOption selectedAlert = AlertOption.oneDayBefore;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          backgroundColor: AppColors.backgroundSlate,
          shape: roundedCornerShape(20),
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.alarm_add_rounded, color: AppColors.primaryBlue),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'Set Due Date Reminder',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary),
                ),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Reminder Type Toggle
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardSurface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white12),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => setDialogState(() {
                            reminderType = 'RECOVER_UDHAR';
                            if (selectedCust != null) titleCtrl.text = selectedCust!.name;
                          }),
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: reminderType == 'RECOVER_UDHAR' ? AppColors.redUdhar.withValues(alpha: 0.2) : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(left: Radius.circular(12)),
                              border: reminderType == 'RECOVER_UDHAR' ? Border.all(color: AppColors.redUdhar, width: 1.5) : null,
                            ),
                            child: Center(
                              child: Text(
                                '💰 Recover Udhar\n(ग्राहक से वसूली)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: reminderType == 'RECOVER_UDHAR' ? AppColors.redUdhar : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: InkWell(
                          onTap: () => setDialogState(() {
                            reminderType = 'PAY_SUPPLIER';
                            if (titleCtrl.text.isEmpty || titleCtrl.text == selectedCust?.name) {
                              titleCtrl.text = 'Supplier / Vendor Bill';
                            }
                          }),
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: reminderType == 'PAY_SUPPLIER' ? AppColors.primaryBlue.withValues(alpha: 0.2) : Colors.transparent,
                              borderRadius: const BorderRadius.horizontal(right: Radius.circular(12)),
                              border: reminderType == 'PAY_SUPPLIER' ? Border.all(color: AppColors.primaryBlue, width: 1.5) : null,
                            ),
                            child: Center(
                              child: Text(
                                '📦 Pay Supplier\n(सप्लायर बिल)',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: reminderType == 'PAY_SUPPLIER' ? AppColors.primaryBlue : AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Customer / Title selector
                if (reminderType == 'RECOVER_UDHAR') ...[
                  const Text('Select Customer:', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white12),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Customer>(
                        value: selectedCust,
                        isExpanded: true,
                        dropdownColor: AppColors.dropdownSurface,
                        borderRadius: BorderRadius.circular(14),
                        items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name, style: const TextStyle(color: Colors.white)))).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setDialogState(() {
                              selectedCust = val;
                              titleCtrl.text = val.name;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ] else ...[
                  TextField(
                    controller: titleCtrl,
                    style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                    decoration: const InputDecoration(
                      labelText: 'Supplier / Party Name',
                      labelStyle: TextStyle(color: AppColors.textSecondary),
                      hintStyle: TextStyle(color: AppColors.textMuted),
                      hintText: 'e.g. Amul Milk, Kirana Distributor',
                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // Amount
                TextField(
                  controller: amountCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 16, fontWeight: FontWeight.bold),
                  decoration: const InputDecoration(
                    labelText: 'Amount (₹)',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    prefixText: '₹ ',
                    prefixStyle: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
                const SizedBox(height: 14),

                // Due Date Picker
                const Text('Due Date (भुगतान की अंतिम तारीख):', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 6),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now().subtract(const Duration(days: 30)),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.cardSurface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.primaryBlue.withValues(alpha: 0.4)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.calendar_month, color: AppColors.primaryBlue, size: 20),
                            const SizedBox(width: 10),
                            Text(
                              '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
                            ),
                          ],
                        ),
                        const Text('Change 📅', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 3 ALERT OPTIONS
                const Text('⏰ 3 Alert Options (अलर्ट का समय चुनें):', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 12)),
                const SizedBox(height: 6),
                Column(
                  children: [
                    _buildAlertRadioTile(
                      title: 'Option 1: ⚡ On Due Date (आज के दिन)',
                      subtitle: 'Alert on due morning (9:00 AM)',
                      value: AlertOption.sameDay,
                      groupValue: selectedAlert,
                      onChanged: (val) => setDialogState(() => selectedAlert = val!),
                    ),
                    const SizedBox(height: 4),
                    _buildAlertRadioTile(
                      title: 'Option 2: 🔔 1 Day Before (1 दिन पहले)',
                      subtitle: 'Advance reminder 24h prior',
                      value: AlertOption.oneDayBefore,
                      groupValue: selectedAlert,
                      onChanged: (val) => setDialogState(() => selectedAlert = val!),
                    ),
                    const SizedBox(height: 4),
                    _buildAlertRadioTile(
                      title: 'Option 3: 📅 3 Days Before (3 दिन पहले)',
                      subtitle: 'Early notice for heavy balances',
                      value: AlertOption.threeDaysBefore,
                      groupValue: selectedAlert,
                      onChanged: (val) => setDialogState(() => selectedAlert = val!),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Note
                TextField(
                  controller: noteCtrl,
                  style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
                  decoration: const InputDecoration(
                    labelText: 'Notes / Remarks',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintStyle: TextStyle(color: AppColors.textMuted),
                    hintText: 'Bill #, items, or agreement',
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.borderLight)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.accentGold)),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: const Color(0xFF062622)),
              onPressed: () {
                final amt = double.tryParse(amountCtrl.text.trim()) ?? 0;
                if (amt <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a valid amount!')),
                  );
                  return;
                }
                final finalTitle = titleCtrl.text.trim().isNotEmpty ? titleCtrl.text.trim() : (selectedCust?.name ?? 'Payment Reminder');
                state.addReminder(
                  customerId: reminderType == 'RECOVER_UDHAR' ? (selectedCust?.id ?? 0) : 0,
                  title: finalTitle,
                  amount: amt,
                  dueDate: selectedDate,
                  reminderType: reminderType,
                  alertOption: selectedAlert,
                  note: noteCtrl.text.trim(),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('📅 Reminder set for ₹${amt.toInt()} with ${state.getAlertOptionLabel(selectedAlert)}!'),
                    backgroundColor: const Color(0xFF10B981),
                  ),
                );
              },
              child: const Text('Set Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildAlertRadioTile({
    required String title,
    required String subtitle,
    required AlertOption value,
    required AlertOption groupValue,
    required ValueChanged<AlertOption?> onChanged,
  }) {
    final isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withValues(alpha: 0.12) : AppColors.cardSurface.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.white10,
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? AppColors.primaryBlue : AppColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
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

