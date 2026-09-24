import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

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
    final p = widget.state.activePalette;
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
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            'Add Customer',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
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
                        color: cardBg,
                        border: Border.all(color: cardBorder),
                      ),
                      child: Icon(Icons.person, size: 44, color: p.textMuted),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      '+ Add Photo',
                      style: TextStyle(color: subtitleColor, fontSize: 12, fontWeight: FontWeight.bold),
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
                p: p,
                cardBg: cardBg,
                cardBorder: cardBorder,
                titleColor: titleColor,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Mobile Number *',
                controller: _phoneCtrl,
                hint: '+91 98765 43210',
                keyboardType: TextInputType.phone,
                p: p,
                cardBg: cardBg,
                cardBorder: cardBorder,
                titleColor: titleColor,
                suffixIcon: IconButton(
                  icon: Icon(Icons.perm_contact_calendar_outlined, color: subtitleColor),
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
                p: p,
                cardBg: cardBg,
                cardBorder: cardBorder,
                titleColor: titleColor,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Credit Limit (Optional)',
                controller: _creditLimitCtrl,
                hint: '₹ 10,000',
                keyboardType: TextInputType.number,
                p: p,
                cardBg: cardBg,
                cardBorder: cardBorder,
                titleColor: titleColor,
              ),
              const SizedBox(height: 16),

              _buildInputField(
                label: 'Notes',
                controller: _notesCtrl,
                hint: 'Regular customer',
                maxLines: 2,
                p: p,
                cardBg: cardBg,
                cardBorder: cardBorder,
                titleColor: titleColor,
              ),
              const SizedBox(height: 32),

              // Save Customer Button
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
                  onPressed: _saveCustomer,
                  child: const Text('Save Customer', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required ThemePalette p,
    required Color cardBg,
    required Color cardBorder,
    required Color titleColor,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: cardBorder),
          ),
          child: TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            style: TextStyle(color: titleColor, fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(color: p.textMuted, fontSize: 14),
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

