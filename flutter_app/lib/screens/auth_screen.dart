import 'package:flutter/material.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  final LedgerState state;
  const AuthScreen({super.key, required this.state});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _isLogin = true;
  final _emailCtrl = TextEditingController(text: 'merchant@udharkhata.com');
  final _passCtrl = TextEditingController(text: 'password123');
  final _nameCtrl = TextEditingController(text: 'Shivam Kirana Store');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundSlate,
      body: AtmosphericBackdrop(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: GlassCard(
              radius: 24,
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryBlue.withValues(alpha: 0.2),
                      border: Border.all(color: AppColors.primaryBlue, width: 2),
                    ),
                    child: const Icon(Icons.storefront, size: 36, color: AppColors.primaryBlue),
                  ),
                  const SizedBox(height: 12),
                  const Text('Udhar Khata', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                  const Text('Smart Digital Ledger & Credit Tracker', style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
                  const SizedBox(height: 24),

                  // Toggle Login / Register
                  Row(
                    children: [
                      Expanded(
                        child: BouncyWidget(
                          onTap: () => setState(() => _isLogin = true),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: _isLogin ? AppColors.primaryBlueBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: _isLogin ? AppColors.primaryBlue : Colors.white12),
                            ),
                            child: Text(
                              'Sign In',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, color: _isLogin ? AppColors.primaryBlue : AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: BouncyWidget(
                          onTap: () => setState(() => _isLogin = false),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: !_isLogin ? AppColors.primaryBlueBg : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: !_isLogin ? AppColors.primaryBlue : Colors.white12),
                            ),
                            child: Text(
                              'Register',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold, color: !_isLogin ? AppColors.primaryBlue : AppColors.textSecondary),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  if (!_isLogin) ...[
                    TextField(
                      controller: _nameCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: const InputDecoration(labelText: 'Shop / Owner Name', labelStyle: TextStyle(color: AppColors.textSecondary)),
                    ),
                    const SizedBox(height: 12),
                  ],

                  TextField(
                    controller: _emailCtrl,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(labelText: 'Email Address', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 12),

                  TextField(
                    controller: _passCtrl,
                    obscureText: true,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(labelText: 'Password', labelStyle: TextStyle(color: AppColors.textSecondary)),
                  ),
                  const SizedBox(height: 24),

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
                        widget.state.loginDemoUser(
                          _nameCtrl.text.trim().isNotEmpty ? _nameCtrl.text.trim() : 'Shivam Kirana Store',
                          _emailCtrl.text.trim(),
                          false,
                        );
                      },
                      child: Text(_isLogin ? 'Sign In to Account' : 'Create Merchant Account', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Google Sign In Demo
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: Colors.white24),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        widget.state.loginDemoUser('Google Merchant User', 'google.merchant@gmail.com', true);
                      },
                      icon: const Text('🌐', style: TextStyle(fontSize: 18)),
                      label: const Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Quick Demo Mode Button
                  TextButton(
                    onPressed: () {
                      widget.state.loginDemoUser('Demo Kirana Store', 'demo@udharkhata.com', false);
                    },
                    child: const Text('⚡ Quick Demo Login (Skip)', style: TextStyle(color: AppColors.primaryBlueLight, fontSize: 12)),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
