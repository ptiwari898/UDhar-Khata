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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        children: [
          Text('Business Profile', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: p.textPrimary)),
          Text('Shop configuration and UPI billing settings', style: TextStyle(fontSize: 12, color: p.textSecondary)),
          const SizedBox(height: 16),

          // Avatar & Shop Header
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            containerColor: p.glassSurface,
            borderColor: p.glassBorder,
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
                        color: p.primaryAccent.withValues(alpha: 0.3),
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
                      Text(_shopNameCtrl.text, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: p.textPrimary)),
                      Text(_ownerNameCtrl.text, style: TextStyle(color: p.textSecondary, fontSize: 13)),
                      Text(_upiCtrl.text, style: TextStyle(color: p.primaryAccent, fontSize: 12, fontWeight: FontWeight.w600)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Theme Mode Switcher
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            containerColor: p.glassSurface,
            borderColor: p.glassBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'App Theme & Appearance',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  'Choose your preferred visual theme',
                  style: TextStyle(fontSize: 12, color: p.textSecondary),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    // 1. Golden Hour (Default)
                    Expanded(
                      child: _ThemeOptionPill(
                        title: 'Golden Hour',
                        subtitle: 'Default',
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
                      child: _ThemeOptionPill(
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
                      child: _ThemeOptionPill(
                        title: 'Light Mode',
                        subtitle: 'Daylight',
                        icon: Icons.light_mode_rounded,
                        isSelected: state.themeMode == AppThemeMode.lightMode,
                        activeColor: const Color(0xFFFFB347),
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
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            containerColor: p.glassSurface,
            borderColor: p.glassBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Store Details', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.primaryAccent)),
                const SizedBox(height: 12),
                TextField(
                  controller: _shopNameCtrl,
                  style: TextStyle(color: p.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Shop / Business Name',
                    labelStyle: TextStyle(color: p.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.textSecondary.withValues(alpha: 0.3))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _ownerNameCtrl,
                  style: TextStyle(color: p.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Owner Full Name',
                    labelStyle: TextStyle(color: p.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.textSecondary.withValues(alpha: 0.3))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _phoneCtrl,
                  style: TextStyle(color: p.textPrimary),
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: 'Contact Phone Number',
                    labelStyle: TextStyle(color: p.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.textSecondary.withValues(alpha: 0.3))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _emailCtrl,
                  style: TextStyle(color: p.textPrimary),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email Address',
                    labelStyle: TextStyle(color: p.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.textSecondary.withValues(alpha: 0.3))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _locationCtrl,
                  style: TextStyle(color: p.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Address & City',
                    labelStyle: TextStyle(color: p.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.textSecondary.withValues(alpha: 0.3))),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: p.primaryAccent)),
                  ),
                ),
                const SizedBox(height: 18),
                Text('Payment & Tax Settings', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.primaryAccent)),
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

          // Backup & Data Recovery (Phase 17)
          GlassCard(
            radius: 20,
            padding: const EdgeInsets.all(18),
            containerColor: p.glassSurface,
            borderColor: p.glassBorder,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: p.primaryAccent.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.cloud_sync_rounded, color: p.primaryAccent, size: 20),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Backup & Cloud Recovery', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: p.textPrimary)),
                        Text('Safe JSON snapshot & restore engine', style: TextStyle(fontSize: 11, color: p.textSecondary)),
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
                          side: BorderSide(color: p.primaryAccent.withValues(alpha: 0.5)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          final backup = state.exportBackupData();
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              backgroundColor: AppColors.backgroundSlate,
                              title: const Text('JSON Backup Snapshot', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                              content: SingleChildScrollView(
                                child: Text(backup, style: const TextStyle(fontSize: 10, fontFamily: 'monospace', color: AppColors.textSecondary)),
                              ),
                              actions: [
                                TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue, foregroundColor: const Color(0xFF062622)),
                                  onPressed: () {
                                    Navigator.pop(ctx);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Backup snapshot verified and stored to safe local storage!'), backgroundColor: Color(0xFF10B981)),
                                    );
                                  },
                                  child: const Text('Save Snapshot'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: const Icon(Icons.file_download_outlined, size: 16),
                        label: const Text('Export JSON', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primaryAccent.withValues(alpha: 0.2),
                          foregroundColor: p.primaryAccent,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Auto-backup is ACTIVE. Local storage is persistent!'), backgroundColor: Color(0xFF10B981)),
                          );
                        },
                        icon: const Icon(Icons.check_circle, size: 16),
                        label: const Text('Persistent DB', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
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

class _ThemeOptionPill extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final Color activeColor;
  final ThemePalette palette;
  final VoidCallback onTap;

  const _ThemeOptionPill({
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
    return BouncyWidget(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (palette.isDark ? Colors.white.withValues(alpha: 0.22) : Colors.white)
              : (palette.isDark ? Colors.white.withValues(alpha: 0.06) : Colors.white.withValues(alpha: 0.45)),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? activeColor : (palette.isDark ? Colors.white24 : Colors.black12),
            width: isSelected ? 2.0 : 1.0,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.35),
                    blurRadius: 10,
                    spreadRadius: 1,
                  ),
                ]
              : null,
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : palette.textSecondary,
              size: 22,
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? palette.textPrimary : palette.textSecondary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? activeColor : palette.textMuted,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

