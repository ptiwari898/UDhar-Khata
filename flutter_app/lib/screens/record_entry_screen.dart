import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';

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

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: widget.onBack,
        ),
        title: const Text(
          'Add Transaction',
          style: TextStyle(color: Color(0xFF1E1E1E), fontWeight: FontWeight.bold, fontSize: 18),
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
                color: const Color(0xFFEFF6FF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFBFDBFE)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Color(0xFF2563EB), size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<Customer>(
                        value: _selectedCustomer,
                        isDense: true,
                        dropdownColor: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E), fontSize: 14),
                        items: state.customers.map((c) {
                          return DropdownMenuItem(
                            value: c,
                            child: Text(c.name, style: const TextStyle(color: Color(0xFF1E1E1E))),
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
                    child: const Icon(Icons.close, size: 18, color: Color(0xFF6B7280)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Transaction Type Selector Pills: Udhaar, Payment, Advance
            const Text(
              'Transaction Type',
              style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildTypePill('UDHAAR', 'Udhaar'),
                const SizedBox(width: 8),
                _buildTypePill('PAYMENT', 'Payment'),
                const SizedBox(width: 8),
                _buildTypePill('ADVANCE', 'Advance'),
              ],
            ),
            const SizedBox(height: 20),

            // Amount Input
            const Text(
              'Amount *',
              style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: Row(
                children: [
                  const Text('₹', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6B7280))),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _amountCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
                      decoration: const InputDecoration(border: InputBorder.none, hintText: '0'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Payment Mode Dropdown
            const Text(
              'Payment Mode',
              style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _paymentMode,
                  isExpanded: true,
                  dropdownColor: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  items: ['Cash', 'UPI', 'Bank Transfer', 'Other'].map((m) {
                    return DropdownMenuItem(value: m, child: Text(m, style: const TextStyle(color: Color(0xFF1E1E1E))));
                  }).toList(),
                  onChanged: (v) {
                    if (v != null) setState(() => _paymentMode = v);
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Date Picker
            const Text(
              'Date',
              style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13),
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
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_selectedDate.day} Sep ${_selectedDate.year}',
                      style: const TextStyle(color: Color(0xFF1E1E1E), fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                    const Icon(Icons.calendar_today, size: 18, color: Color(0xFF6B7280)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Note Input
            const Text(
              'Note',
              style: TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: TextField(
                controller: _noteCtrl,
                style: const TextStyle(color: Color(0xFF1E1E1E), fontSize: 14),
                decoration: const InputDecoration(border: InputBorder.none, hintText: 'Add a note...'),
              ),
            ),
            const SizedBox(height: 32),

            // Save Transaction Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDF7528),
                  foregroundColor: Colors.white,
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
    );
  }

  Widget _buildTypePill(String type, String label) {
    final isSelected = _selectedType == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedType = type),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFDF7528) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? const Color(0xFFDF7528) : const Color(0xFFE5E7EB)),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : const Color(0xFF4B5563),
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}
