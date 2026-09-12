import 'dart:async';
import 'package:flutter/material.dart';
import '../state/ledger_state.dart';

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
    if (_currentStep == 0) {
      return _buildSplashScreen();
    } else if (_currentStep == 2) {
      return _buildOtpScreen();
    }
    return _buildLoginScreen();
  }

  // Screen 1: Splash Screen
  Widget _buildSplashScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background ambient wave
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 260,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00FAF7F2), Color(0x33DF7528)],
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Book Logo
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDF7528).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(
                    child: Icon(Icons.menu_book_rounded, size: 54, color: Color(0xFFDF7528)),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Udhar Khata',
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E), letterSpacing: 0.5),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Digital Bahi-Khata\nfor Indian Businesses',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.4),
                ),
                const SizedBox(height: 60),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFDF7528),
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
          const Positioned(
            bottom: 40,
            child: Column(
              children: [
                Text(
                  'Simple Records',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.w600),
                ),
                Text(
                  'Stronger Relationships',
                  style: TextStyle(color: Color(0xFF9CA3AF), fontSize: 13, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Screen 2: Login / OTP
  Widget _buildLoginScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => setState(() => _currentStep = 0),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome to\nUdhar Khata',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E), height: 1.25),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your mobile number to\ncontinue',
                style: TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.4),
              ),
              const SizedBox(height: 32),

              // Mobile Input Box
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE5E7EB)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    const Text('🇮🇳', style: TextStyle(fontSize: 20)),
                    const SizedBox(width: 8),
                    const Text(
                      '+91',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF1E1E1E)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: TextField(
                        controller: _phoneCtrl,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E1E1E)),
                        decoration: const InputDecoration(
                          hintText: '98765 43210',
                          hintStyle: TextStyle(color: Color(0xFF9CA3AF)),
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
                    backgroundColor: const Color(0xFFDF7528),
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
                  const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text('or continue with', style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                  ),
                  const Expanded(child: Divider(color: Color(0xFFE5E7EB))),
                ],
              ),
              const SizedBox(height: 24),

              // Continue with Google Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1E1E1E),
                    backgroundColor: Colors.white,
                    side: const BorderSide(color: Color(0xFFE5E7EB)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    widget.state.loginDemoUser('Google Merchant User', 'google.merchant@gmail.com', true);
                  },
                  icon: Container(
                    padding: const EdgeInsets.all(2),
                    child: const Text('G', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF4285F4))),
                  ),
                  label: const Text('Continue with Google', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
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
                        style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                      ),
                      const Text(
                        'Terms & Privacy Policy',
                        style: TextStyle(color: Color(0xFF1E1E1E), fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Screen 3: OTP Verification
  Widget _buildOtpScreen() {
    return Scaffold(
      backgroundColor: const Color(0xFFFAF7F2),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E1E1E)),
          onPressed: () => setState(() => _currentStep = 1),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Verify OTP',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
              ),
              const SizedBox(height: 8),
              Text(
                'We have sent a 6-digit code to\n+91 ${_phoneCtrl.text}',
                style: const TextStyle(fontSize: 14, color: Color(0xFF6B7280), height: 1.4),
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFD1D5DB)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
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
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E1E1E)),
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
                    color: _resendTimer > 0 ? const Color(0xFF9CA3AF) : const Color(0xFFDF7528),
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
                    backgroundColor: const Color(0xFFDF7528),
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
    );
  }
}
