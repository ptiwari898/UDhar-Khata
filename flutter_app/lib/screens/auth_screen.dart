import 'dart:async';
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
  // Step 0: Splash, Step 1: Mobile Login, Step 2: OTP Verification
  int _currentStep = 1;
  final _phoneCtrl = TextEditingController(text: '98765 43210');
  final List<TextEditingController> _otpControllers = List.generate(6, (i) => TextEditingController(text: '${i + 1}'));
  int _resendTimer = 30;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    _resendTimer = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _phoneCtrl.dispose();
    for (final c in _otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _handleContinue() {
    final phone = _phoneCtrl.text.trim();
    if (phone.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid mobile number')),
      );
      return;
    }
    _startTimer();
    setState(() => _currentStep = 2);
  }

  void _handleVerify() {
    widget.state.loginDemoUser('Shivam Kirana Store', 'merchant@udharkhata.com', false);
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.state.activePalette;
    if (_currentStep == 0) {
      return _buildSplashScreen(p);
    } else if (_currentStep == 2) {
      return _buildOtpScreen(p);
    }
    return _buildLoginScreen(p);
  }

  // Screen 1: Splash Screen
  Widget _buildSplashScreen(ThemePalette p) {
    return AtmosphericBackdrop(
      palette: p,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Book Logo
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      color: p.primaryAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: p.glassBorder.withValues(alpha: 0.4)),
                    ),
                    child: Center(
                      child: Icon(Icons.menu_book_rounded, size: 54, color: p.primaryAccent),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Udhar Khata',
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: p.textPrimary, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Digital Bahi-Khata\nfor Indian Businesses',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: p.textSecondary, height: 1.4),
                  ),
                  const SizedBox(height: 60),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: p.primaryAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    ),
                    onPressed: () => setState(() => _currentStep = 1),
                    child: const Text('Get Started', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 40,
              child: Column(
                children: [
                  Text(
                    'Simple Records',
                    style: TextStyle(color: p.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Stronger Relationships',
                    style: TextStyle(color: p.textMuted, fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Screen 2: Login / OTP
  Widget _buildLoginScreen(ThemePalette p) {
    return AtmosphericBackdrop(
      palette: p,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: p.textPrimary),
            onPressed: () => setState(() => _currentStep = 0),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome to\nUdhar Khata',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: p.textPrimary, height: 1.25),
                ),
                const SizedBox(height: 8),
                Text(
                  'Enter your mobile number to\ncontinue',
                  style: TextStyle(fontSize: 14, color: p.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 32),

                // Mobile Input Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: p.glassSurface,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: p.glassBorder),
                    boxShadow: [
                      BoxShadow(
                        color: p.cardShadow,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      Text(
                        '+91',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: p.textPrimary),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _phoneCtrl,
                          keyboardType: TextInputType.phone,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: p.textPrimary),
                          decoration: InputDecoration(
                            hintText: '98765 43210',
                            hintStyle: TextStyle(color: p.textMuted),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: p.primaryAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    onPressed: _handleContinue,
                    child: const Text('Continue', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 24),

                // Divider "or continue with"
                Row(
                  children: [
                    Expanded(child: Divider(color: p.glassBorder)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or continue with', style: TextStyle(color: p.textMuted, fontSize: 12)),
                    ),
                    Expanded(child: Divider(color: p.glassBorder)),
                  ],
                ),
                const SizedBox(height: 24),

                // Continue with Google Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: p.textPrimary,
                      backgroundColor: p.glassSurface,
                      side: BorderSide(color: p.glassBorder),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      widget.state.loginDemoUser('Google Merchant User', 'google.merchant@gmail.com', true);
                    },
                    icon: Container(
                      padding: const EdgeInsets.all(2),
                      child: const Text('G', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4285F4))),
                    ),
                    label: Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: p.textPrimary)),
                  ),
                ),
                const Spacer(),

                // Terms & Privacy Policy Footer
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      children: [
                        Text(
                          'By continuing, you agree to our',
                          style: TextStyle(color: p.textMuted, fontSize: 12),
                        ),
                        Text(
                          'Terms & Privacy Policy',
                          style: TextStyle(color: p.textPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Screen 3: OTP Verification
  Widget _buildOtpScreen(ThemePalette p) {
    return AtmosphericBackdrop(
      palette: p,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: p.textPrimary),
            onPressed: () => setState(() => _currentStep = 1),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify OTP',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: p.textPrimary),
                ),
                const SizedBox(height: 8),
                Text(
                  'We have sent a 6-digit code to\n+91 ${_phoneCtrl.text}',
                  style: TextStyle(fontSize: 14, color: p.textSecondary, height: 1.4),
                ),
                const SizedBox(height: 36),

                // 6 OTP Digit Boxes
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(6, (i) {
                    return Container(
                      width: 48,
                      height: 52,
                      decoration: BoxDecoration(
                        color: p.glassSurface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: p.glassBorder),
                        boxShadow: [
                          BoxShadow(
                            color: p.cardShadow,
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: TextField(
                          controller: _otpControllers[i],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: p.textPrimary),
                          decoration: const InputDecoration(counterText: '', border: InputBorder.none),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 24),

                // Resend OTP Timer
                Center(
                  child: Text(
                    _resendTimer > 0
                        ? 'Resend OTP in 00:${_resendTimer.toString().padLeft(2, '0')}'
                        : 'Didn\'t receive OTP? Resend Now',
                    style: TextStyle(
                      color: _resendTimer > 0 ? p.textMuted : p.primaryAccent,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 28),

                // Verify Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: p.primaryAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      elevation: 2,
                    ),
                    onPressed: _handleVerify,
                    child: const Text('Verify', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

