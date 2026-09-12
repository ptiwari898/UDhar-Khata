import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class RecordEntryScreen extends StatefulWidget {
  final LedgerState state;
  final VoidCallback onBack;

  const RecordEntryScreen({
    super.key,
    required this.state,
    required this.onBack,
  });

  @override
  State<RecordEntryScreen> createState() => _RecordEntryScreenState();
}

class _RecordEntryScreenState extends State<RecordEntryScreen> {
  String _selectedType = 'UDHAAR'; // UDHAAR, PAYMENT, ADVANCE
  Customer? _selectedCustomer;
  final _amountCtrl = TextEditingController();
  final _noteCtrl = TextEditingController();
  String _paymentMethod = 'Cash';

  @override
  void initState() {
    super.initState();
    _selectedCustomer = widget.state.customers.firstOrNull;
  }

  void _addQuickAmount(int val) {
    final current = double.tryParse(_amountCtrl.text) ?? 0;
    _amountCtrl.text = (current + val).toInt().toString();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final isUdhar = _selectedType == 'UDHAAR';
    final isPayment = _selectedType == 'PAYMENT';
    final activeColor = isUdhar
        ? AppColors.redUdhar
        : (isPayment ? AppColors.greenAdvance : AppColors.primaryBlue);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: widget.onBack,
              ),
              const SizedBox(width: 4),
              const Text(
                'Record Entry',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Type Toggle Row
          Row(
            children: [
              _TypeBtn(
                title: 'Give Udhar',
                isSelected: isUdhar,
                color: AppColors.redUdhar,
                onTap: () => setState(() => _selectedType = 'UDHAAR'),
              ),
              const SizedBox(width: 8),
              _TypeBtn(
                title: 'Receive Payment',
                isSelected: isPayment,
                color: AppColors.greenAdvance,
                onTap: () => setState(() => _selectedType = 'PAYMENT'),
              ),
              const SizedBox(width: 8),
              _TypeBtn(
                title: 'Advance',
                isSelected: _selectedType == 'ADVANCE',
                color: AppColors.primaryBlue,
                onTap: () => setState(() => _selectedType = 'ADVANCE'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Customer Selector & Amount Entry
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DropdownButtonFormField<Customer>(
                  initialValue: _selectedCustomer,
                  dropdownColor: AppColors.cardSurface,
                  decoration: const InputDecoration(
                    labelText: 'Select Customer',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    prefixIcon: Icon(Icons.person, color: AppColors.primaryBlue),
                  ),
                  items: state.customers.map((c) => DropdownMenuItem(value: c, child: Text(c.name))).toList(),
                  onChanged: (val) => setState(() => _selectedCustomer = val),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _amountCtrl,
                  keyboardType: TextInputType.number,
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: activeColor),
                  decoration: InputDecoration(
                    labelText: 'Amount (₹)',
                    labelStyle: const TextStyle(color: AppColors.textSecondary),
                    prefixText: '₹ ',
                    prefixStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: activeColor),
                  ),
                ),
                const SizedBox(height: 12),
                // Quick Amount Chips
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [100, 500, 1000, 2000].map((amt) {
                    return BouncyWidget(
                      onTap: () => _addQuickAmount(amt),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.white12),
                        ),
                        child: Text('+₹$amt', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                const Text('Payment Method', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: ['Cash', 'UPI', 'Bank Transfer'].map((m) {
                    final isSel = _paymentMethod == m;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(m),
                        selected: isSel,
                        selectedColor: activeColor,
                        backgroundColor: AppColors.cardSurface,
                        onSelected: (_) => setState(() => _paymentMethod = m),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _noteCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Note / Items Description',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    hintText: 'e.g. Grocery items, 5kg Atta',
                    hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: activeColor,
                      foregroundColor: const Color(0xFF062622),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      final amt = double.tryParse(_amountCtrl.text.trim()) ?? 0;
                      if (_selectedCustomer != null && amt > 0) {
                        state.addTransaction(
                          customerId: _selectedCustomer!.id,
                          type: _selectedType,
                          amount: amt,
                          note: _noteCtrl.text.trim().isNotEmpty ? _noteCtrl.text.trim() : 'Manual Entry',
                          paymentMethod: _paymentMethod,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Saved ₹${amt.toInt()} $_selectedType entry!')),
                        );
                        widget.onBack();
                      }
                    },
                    child: Text('Save $_selectedType', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TypeBtn extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  const _TypeBtn({
    required this.title,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BouncyWidget(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.22) : Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isSelected ? color : Colors.white12, width: isSelected ? 1.5 : 1),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: isSelected ? color : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}
