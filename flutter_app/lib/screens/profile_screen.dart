import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  final LedgerState state;
  const ProfileScreen({super.key, required this.state});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController _shopNameCtrl;
  late TextEditingController _ownerNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _locationCtrl;
  late TextEditingController _upiCtrl;
  late TextEditingController _gstinCtrl;

  @override
  void initState() {
    super.initState();
    final p = widget.state.shopProfile;
    _shopNameCtrl = TextEditingController(text: p.shopName);
    _ownerNameCtrl = TextEditingController(text: p.ownerName);
    _phoneCtrl = TextEditingController(text: p.phone);
    _emailCtrl = TextEditingController(text: p.email);
    _locationCtrl = TextEditingController(text: p.location);
    _upiCtrl = TextEditingController(text: p.upiId);
    _gstinCtrl = TextEditingController(text: p.gstin);
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          const Text('Business Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
          const Text('Shop configuration and UPI billing settings', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
          const SizedBox(height: 16),

          // Avatar & Shop Header
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white38, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFDF8532).withValues(alpha: 0.3),
                        blurRadius: 10,
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
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_shopNameCtrl.text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: AppColors.textPrimary)),
                      Text(_ownerNameCtrl.text, style: const TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                      Text(_upiCtrl.text, style: const TextStyle(color: AppColors.primaryBlue, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Edit Form
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Store Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryBlue)),
                const SizedBox(height: 12),
                TextField(
                  controller: _shopNameCtrl,
                  decoration: const InputDecoration(labelText: 'Shop / Business Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ownerNameCtrl,
                  decoration: const InputDecoration(labelText: 'Owner Full Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Contact Phone Number', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(labelText: 'Email Address', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _locationCtrl,
                  decoration: const InputDecoration(labelText: 'Address & City', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 18),
                const Text('Payment & Tax Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primaryBlue)),
                const SizedBox(height: 12),
                TextField(
                  controller: _upiCtrl,
                  decoration: const InputDecoration(labelText: 'Business UPI ID (for QR codes & reminders)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _gstinCtrl,
                  decoration: const InputDecoration(labelText: 'GSTIN Number (Optional)', labelStyle: TextStyle(color: AppColors.textSecondary)),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: const Color(0xFF062622),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      final updated = state.shopProfile.copyWith(
                        shopName: _shopNameCtrl.text.trim(),
                        ownerName: _ownerNameCtrl.text.trim(),
                        phone: _phoneCtrl.text.trim(),
                        email: _emailCtrl.text.trim(),
                        location: _locationCtrl.text.trim(),
                        upiId: _upiCtrl.text.trim(),
                        gstin: _gstinCtrl.text.trim(),
                      );
                      state.updateProfile(updated);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Shop profile updated successfully!')),
                      );
                    },
                    child: const Text('Save Profile Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Logout Button
          GlassCard(
            radius: 18,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            onTap: () => state.logout(),
            child: const Row(
              children: [
                Icon(Icons.logout, color: AppColors.redUdhar, size: 20),
                SizedBox(width: 14),
                Expanded(
                  child: Text('Sign Out Account', style: TextStyle(color: AppColors.redUdhar, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Icon(Icons.chevron_right, color: AppColors.textSecondary, size: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
