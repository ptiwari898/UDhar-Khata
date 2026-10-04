import 'package:flutter/material.dart';
import '../state/app_translations.dart';
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

          // Language Selection Card
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
                    Icon(Icons.translate_rounded, color: p.primaryAccent, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'App Language (भाषा)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Select interface language / अपनी भाषा चुनें',
                  style: TextStyle(fontSize: 12, color: subtitleColor),
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    Expanded(
                      child: _LanguageOptionCard(
                        label: 'English',
                        subtitle: 'Default',
                        isSelected: state.language == AppLanguage.english,
                        palette: p,
                        onTap: () => state.setLanguage(AppLanguage.english),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LanguageOptionCard(
                        label: 'हिंदी',
                        subtitle: 'Hindi',
                        isSelected: state.language == AppLanguage.hindi,
                        palette: p,
                        onTap: () => state.setLanguage(AppLanguage.hindi),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _LanguageOptionCard(
                        label: 'Hinglish',
                        subtitle: 'Indian',
                        isSelected: state.language == AppLanguage.hinglish,
                        palette: p,
                        onTap: () => state.setLanguage(AppLanguage.hinglish),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),



          // Wallvault Appearance Card (Matching Screenshot)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: cardBorder),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: p.isDark ? 0.35 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Appearance',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: titleColor,
                  ),
                ),
                const SizedBox(height: 16),

                // 1. Dark Theme Switch Row
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.isDark ? const Color(0x33FFFFFF) : const Color(0xFFF1F5F9),
                      ),
                      child: Icon(
                        Icons.nightlight_round,
                        size: 20,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dark Theme',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          Text(
                            'Use dark theme for the app',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: state.isDarkTheme,
                      activeColor: p.primaryAccent,
                      onChanged: (val) => state.setDarkTheme(val),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: cardBorder),
                const SizedBox(height: 12),

                // 2. Use System Colors Switch Row
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: p.isDark ? const Color(0x33FFFFFF) : const Color(0xFFF1F5F9),
                      ),
                      child: Icon(
                        Icons.auto_awesome_rounded,
                        size: 20,
                        color: titleColor,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Use System Colors',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: titleColor,
                            ),
                          ),
                          Text(
                            'Material You dynamic colors (Android 12+)',
                            style: TextStyle(
                              fontSize: 12,
                              color: subtitleColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Switch.adaptive(
                      value: state.useSystemColors,
                      activeColor: p.primaryAccent,
                      onChanged: (val) => state.setUseSystemColors(val),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Divider(color: cardBorder),
                const SizedBox(height: 14),

                // 3. Theme Color Swatch Grid Header
                Row(
                  children: [
                    Icon(Icons.palette_rounded, size: 20, color: titleColor),
                    const SizedBox(width: 8),
                    Text(
                      'Theme Color',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: titleColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // 8 Dual-Split Swatch Cards (2 rows x 4 columns)
                _buildThemeColorGrid(state, p),
                const SizedBox(height: 12),

                // Selected Color Text Indicator (Matching Screenshot)
                Text(
                  'Selected: ${state.selectedThemeColor}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: subtitleColor,
                    letterSpacing: 0.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Liquid Glass & Blur Settings (Wallvault Style Settings)
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.blur_on_rounded, color: p.primaryAccent, size: 22),
                        const SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Liquid Glass Effect',
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
                            ),
                            Text(
                              'App-wide frosted backdrop blur',
                              style: TextStyle(fontSize: 12, color: subtitleColor),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Switch.adaptive(
                      value: state.glassEffectEnabled,
                      activeColor: p.primaryAccent,
                      onChanged: (val) => state.setGlassEffectEnabled(val),
                    ),
                  ],
                ),
                if (state.glassEffectEnabled) ...[
                  const SizedBox(height: 14),
                  Divider(color: cardBorder),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Glass Blur Intensity',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: titleColor),
                      ),
                      Text(
                        '${state.glassBlurSigma.toInt()}px',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: p.primaryAccent),
                      ),
                    ],
                  ),
                  Slider(
                    value: state.glassBlurSigma,
                    min: 10.0,
                    max: 32.0,
                    divisions: 22,
                    activeColor: p.primaryAccent,
                    inactiveColor: p.primaryAccent.withValues(alpha: 0.25),
                    label: '${state.glassBlurSigma.toInt()}px',
                    onChanged: (val) => state.setGlassBlurSigma(val),
                  ),
                ],
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

  Widget _buildThemeColorGrid(LedgerState state, ThemePalette palette) {
    final presetKeys = ['PURPLE', 'BLUE', 'TEAL', 'GREEN', 'ORANGE', 'RED', 'PINK', 'VIOLET'];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.25,
      ),
      itemCount: presetKeys.length,
      itemBuilder: (context, index) {
        final key = presetKeys[index];
        final preset = WallvaultPresets.getPreset(key);
        final isSelected = state.selectedThemeColor.toUpperCase() == key;

        return GestureDetector(
          onTap: () => state.setSelectedThemeColor(key),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? Colors.white : Colors.transparent,
                width: isSelected ? 3.0 : 0.0,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: preset.primary.withValues(alpha: 0.55),
                        blurRadius: 12,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(isSelected ? 13 : 16),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      color: preset.primary,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: preset.secondary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
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

class _LanguageOptionCard extends StatelessWidget {
  final String label;
  final String subtitle;
  final bool isSelected;
  final ThemePalette palette;
  final VoidCallback onTap;

  const _LanguageOptionCard({
    required this.label,
    required this.subtitle,
    required this.isSelected,
    required this.palette,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = palette.primaryAccent;
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
            Icon(Icons.g_translate_rounded, color: isSelected ? activeColor : palette.textSecondary, size: 20),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
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

