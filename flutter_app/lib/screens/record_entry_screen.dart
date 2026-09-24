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
  final _amountCtrl = TextEditingController(text: '500');
  final _noteCtrl = TextEditingController(text: 'Tel diya');
  String _paymentMode = 'Cash';
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _selectedCustomer = widget.state.customers.firstOrNull;
  }

  @override
  void dispose() {
    _amountCtrl.dispose();
    _noteCtrl.dispose();
    super.dispose();
  }

  void _saveTransaction() {
    if (_selectedCustomer == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a customer')),
      );
      return;
    }

    final amount = double.tryParse(_amountCtrl.text.trim()) ?? 0;
    if (amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount greater than 0')),
      );
      return;
    }

    widget.state.addTransaction(
      customerId: _selectedCustomer!.id,
      amount: amount,
      type: _selectedType,
      note: _noteCtrl.text.trim(),
      paymentMethod: _paymentMode,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved ₹${amount.toInt()} $_selectedType for ${_selectedCustomer!.name}!'),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );
    widget.onBack();
  }

  Widget _buildTypePill(String type, String label, ThemePalette p, Color cardBg, Color cardBorder, Color titleColor) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? p.primaryAccent : cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? p.primaryAccent : cardBorder),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? p.textDarkOnWhite : titleColor,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final p = state.activePalette;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    return AtmosphericBackdrop(
      palette: p,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: titleColor),
            onPressed: widget.onBack,
          ),
          title: Text(
            'Add Transaction',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Customer Selector Chip / Dropdown
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    Icon(Icons.person, color: p.primaryAccent, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Customer>(
                          value: _selectedCustomer,
                          isDense: true,
                          dropdownColor: AppColors.dropdownSurface,
                          borderRadius: BorderRadius.circular(14),
                          style: TextStyle(fontWeight: FontWeight.bold, color: titleColor, fontSize: 14),
                          items: state.customers.map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(c.name, style: TextStyle(color: titleColor)),
                            );
                          }).toList(),
                          onChanged: (c) => setState(() => _selectedCustomer = c),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() => _selectedCustomer = state.customers.firstOrNull);
                      },
                      child: Icon(Icons.close, size: 18, color: subtitleColor),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Transaction Type Selector Pills: Udhaar, Payment, Advance
              Text(
                'Transaction Type',
                style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildTypePill('UDHAAR', 'Udhaar', p, cardBg, cardBorder, titleColor),
                  const SizedBox(width: 8),
                  _buildTypePill('PAYMENT', 'Payment', p, cardBg, cardBorder, titleColor),
                  const SizedBox(width: 8),
                  _buildTypePill('ADVANCE', 'Advance', p, cardBg, cardBorder, titleColor),
                ],
              ),
              const SizedBox(height: 20),

              // Amount Input
              Text(
                'Amount *',
                style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder),
                ),
                child: Row(
                  children: [
                    Text('₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: subtitleColor)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _amountCtrl,
                        keyboardType: TextInputType.number,
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),
                        decoration: InputDecoration(border: InputBorder.none, hintText: '0', hintStyle: TextStyle(color: p.textMuted)),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Payment Mode Dropdown
              Text(
                'Payment Mode',
                style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _paymentMode,
                    isExpanded: true,
                    dropdownColor: AppColors.dropdownSurface,
                    borderRadius: BorderRadius.circular(12),
                    items: ['Cash', 'UPI', 'Bank Transfer', 'Other'].map((m) {
                      return DropdownMenuItem(value: m, child: Text(m, style: TextStyle(color: titleColor)));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _paymentMode = v);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Date Picker
              Text(
                'Date',
                style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  final d = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (d != null) setState(() => _selectedDate = d);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                  decoration: BoxDecoration(
                    color: cardBg,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cardBorder),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${_selectedDate.day} Sep ${_selectedDate.year}',
                        style: TextStyle(color: titleColor, fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                      Icon(Icons.calendar_today, size: 18, color: subtitleColor),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Note Input
              Text(
                'Note',
                style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: cardBorder),
                ),
                child: TextField(
                  controller: _noteCtrl,
                  style: TextStyle(color: titleColor, fontSize: 14),
                  decoration: InputDecoration(border: InputBorder.none, hintText: 'Add a note...', hintStyle: TextStyle(color: p.textMuted)),
                ),
              ),
              const SizedBox(height: 32),

              // Save Transaction Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.primaryAccent,
                    foregroundColor: p.textDarkOnWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  onPressed: _saveTransaction,
                  child: const Text('Save Transaction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
