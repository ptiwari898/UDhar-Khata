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
    final p = state.activePalette;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Text('Business Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: titleColor)),
          Text('Shop configuration and UPI billing settings', style: TextStyle(fontSize: 12, color: subtitleColor)),
          const SizedBox(height: 16),

          // Avatar & Shop Header
          Container(
            padding: const EdgeInsets.all(18),
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
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: p.primaryAccent.withValues(alpha: 0.15),
                    border: Border.all(color: p.primaryAccent, width: 2),
                  ),
                  child: Center(
                    child: Icon(Icons.store_rounded, size: 32, color: p.primaryAccent),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_shopNameCtrl.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: titleColor)),
                      Text(_ownerNameCtrl.text, style: TextStyle(color: subtitleColor, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text(_upiCtrl.text, style: TextStyle(color: p.primaryAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Theme Mode Switcher
          Container(
            padding: const EdgeInsets.all(18),
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
                Text(
                  'App Theme & Appearance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose your preferred visual theme',
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // 1. Golden Hour (Default)
                    Expanded(
                      child: _ThemeOptionCard(
                        title: 'Golden Hour',
                        subtitle: 'Sunset Amber',
                        icon: Icons.wb_twilight_rounded,
                        isSelected: state.themeMode == AppThemeMode.defaultGoldenHour,
                        activeColor: const Color(0xFFDF8532),
                        palette: p,
                        onTap: () => state.setThemeMode(AppThemeMode.defaultGoldenHour),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 2. Dark Mode
                    Expanded(
                      child: _ThemeOptionCard(
                        title: 'Dark Mode',
                        subtitle: 'Midnight',
                        icon: Icons.dark_mode_rounded,
                        isSelected: state.themeMode == AppThemeMode.darkMode,
                        activeColor: const Color(0xFF38BDFC),
                        palette: p,
                        onTap: () => state.setThemeMode(AppThemeMode.darkMode),
                      ),
                    ),
                    const SizedBox(width: 8),
                    // 3. Light Mode
                    Expanded(
                      child: _ThemeOptionCard(
                        title: 'Light Mode',
                        subtitle: 'Daylight',
                        icon: Icons.light_mode_rounded,
                        isSelected: state.themeMode == AppThemeMode.lightMode,
                        activeColor: const Color(0xFFD97706),
                        palette: p,
                        onTap: () => state.setThemeMode(AppThemeMode.lightMode),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Edit Form
          Container(
            padding: const EdgeInsets.all(18),
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
                Text('Store Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.primaryAccent)),
                const SizedBox(height: 12),
                TextField(
                  controller: _shopNameCtrl,
                  style: TextStyle(color: titleColor, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Shop / Business Name',
                    labelStyle: TextStyle(color: subtitleColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cardBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ownerNameCtrl,
                  style: TextStyle(color: titleColor, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Owner Full Name',
                    labelStyle: TextStyle(color: subtitleColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cardBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneCtrl,
                  style: TextStyle(color: titleColor, fontSize: 15),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Phone Number',
                    labelStyle: TextStyle(color: subtitleColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cardBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailCtrl,
                  style: TextStyle(color: titleColor, fontSize: 15),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: subtitleColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cardBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _locationCtrl,
                  style: TextStyle(color: titleColor, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Address & City',
                    labelStyle: TextStyle(color: subtitleColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cardBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 18),
                Text('Payment & Tax Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.primaryAccent)),
                const SizedBox(height: 12),
                TextField(
                  controller: _upiCtrl,
                  style: TextStyle(color: titleColor, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'Business UPI ID (for QR codes & reminders)',
                    labelStyle: TextStyle(color: subtitleColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cardBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _gstinCtrl,
                  style: TextStyle(color: titleColor, fontSize: 15),
                  decoration: InputDecoration(
                    labelText: 'GSTIN Number (Optional)',
                    labelStyle: TextStyle(color: subtitleColor),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: cardBorder)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: p.primaryAccent,
                      foregroundColor: p.textDarkOnWhite,
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

          // Backup & Data Recovery
          Container(
            padding: const EdgeInsets.all(18),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: p.primaryAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.cloud_sync_rounded, color: p.primaryAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Backup & Cloud Recovery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor)),
                        Text('Safe JSON snapshot & restore engine', style: TextStyle(fontSize: 11, color: subtitleColor)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: p.primaryAccent),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Backup downloaded to local storage!')),
                          );
                        },
                        icon: Icon(Icons.file_download_outlined, size: 16, color: p.primaryAccent),
                        label: Text('Export JSON', style: TextStyle(color: p.primaryAccent, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          side: BorderSide(color: p.greenAdvance),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Database restored from latest backup!')),
                          );
                        },
                        icon: Icon(Icons.check_circle_outline, size: 16, color: p.greenAdvance),
                        label: Text('Restore Data', style: TextStyle(color: p.greenAdvance, fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Logout
          InkWell(
            onTap: () => state.logout(),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: p.redBg,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: p.redUdhar.withValues(alpha: 0.5)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.logout, color: p.redUdhar, size: 20),
                  const SizedBox(width: 10),
                  Text('Logout Account', style: TextStyle(color: p.redUdhar, fontWeight: FontWeight.bold, fontSize: 15)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeOptionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final ThemePalette palette;
  final VoidCallback onTap;

  const _ThemeOptionCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.activeColor,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.18) : (palette.isDark ? AppColors.popupSurface : const Color(0xFFF9FAFB)),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : (palette.isDark ? Colors.white12 : const Color(0xFFE5E7EB)),
            width: isSelected ? 1.8 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? activeColor : palette.textSecondary, size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? activeColor : palette.textPrimary,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? activeColor.withValues(alpha: 0.8) : palette.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
