import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';

class AddCustomerScreen extends StatefulWidget {
  final LedgerState state;
  const AddCustomerScreen({super.key, required this.state});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _creditLimitCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _creditLimitCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  void _saveCustomer() {
    final name = _nameCtrl.text.trim();
    final phone = _phoneCtrl.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter Customer Full Name')),
      );
      return;
    }

    final limit = double.tryParse(_creditLimitCtrl.text.trim()) ?? 15000.0;
    widget.state.addCustomer(
      name: name,
      phone: phone.isNotEmpty ? phone : '+91 98765 00000',
      location: _addressCtrl.text.trim().isNotEmpty ? _addressCtrl.text.trim() : 'Local Market',
      riskLevel: 'Low',
      creditLimit: limit,
      notes: _notesCtrl.text.trim(),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Customer "$name" added successfully!'),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Add Customer',
          style: TextStyle(color: Color(0xFF1E1E1E), fontWeight: FontWeight.bold, fontSize: 18),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Column(
          children: [
            // Add Photo Avatar Circle
            Center(
              child: Column(
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE5E7EB),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                    ),
                    child: const Icon(Icons.person, size: 44, color: Color(0xFF9CA3AF)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '+ Add Photo',
                    style: TextStyle(color: Color(0xFF6B7280), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Form Fields
            _buildInputField(
              label: 'Full Name *',
              controller: _nameCtrl,
              hint: 'e.g. Ramesh Kumar',
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Mobile Number *',
              controller: _phoneCtrl,
              hint: '+91 98765 43210',
              keyboardType: TextInputType.phone,
              suffixIcon: IconButton(
                icon: const Icon(Icons.perm_contact_calendar_outlined, color: Color(0xFF6B7280)),
                onPressed: () {
                  _phoneCtrl.text = '+91 98765 43210';
                },
              ),
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Address',
              controller: _addressCtrl,
              hint: 'Shop No. 12, Main Market',
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Credit Limit (Optional)',
              controller: _creditLimitCtrl,
              hint: '₹ 10,000',
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),

            _buildInputField(
              label: 'Notes',
              controller: _notesCtrl,
              hint: 'Regular customer',
              maxLines: 2,
            ),
            const SizedBox(height: 32),

            // Save Customer Button
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
                onPressed: _saveCustomer,
                child: const Text('Save Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Color(0xFF374151), fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: const TextStyle(color: Color(0xFF1E1E1E), fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF9CA3AF), fontSize: 14),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: InputBorder.none,
              suffixIcon: suffixIcon,
            ),
          ),
        ),
      ],
    );
  }
}
