import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class UpiPaymentScreen extends StatelessWidget {
  final LedgerState state;
  final Customer customer;
  final double amount;

  const UpiPaymentScreen({
    super.key,
    required this.state,
    required this.customer,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    final profile = state.shopProfile;
    final upiId = profile.upiId.isNotEmpty ? profile.upiId : 'shivamstore@oksbi';
    final p = state.activePalette;

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
            'UPI Payment',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Text(
                customer.name,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: titleColor),
              ),
              const SizedBox(height: 4),
              Text(
                'Pay ₹${amount.toInt()}',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: titleColor),
              ),
              const SizedBox(height: 20),

              // Crisp QR Code Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white, // Keep QR background white for scanners to read
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: p.isDark ? 0.3 : 0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: cardBorder),
                ),
                child: Column(
                  children: [
                    CustomPaint(
                      size: const Size(200, 200),
                      painter: _QrPatternPainter(),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF4EFEA),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'UPI ID: $upiId',
                            style: const TextStyle(color: Color(0xFF4B5563), fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              Clipboard.setData(ClipboardData(text: upiId));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('UPI ID copied to clipboard!'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                            child: Icon(Icons.copy, size: 16, color: p.primaryAccent),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Share QR Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: p.primaryAccent,
                    foregroundColor: p.textDarkOnWhite,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('UPI QR Code shared with ${customer.name}!'),
                        backgroundColor: const Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: const Icon(Icons.share, size: 20),
                  label: const Text('Share QR', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 12),

              // Open in UPI App
              SizedBox(
                width: double.infinity,
                height: 50,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: titleColor,
                    backgroundColor: cardBg,
                    side: BorderSide(color: cardBorder),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Launching installed UPI App (GPay / PhonePe / Paytm)...'),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  icon: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4285F4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: const Text('GPay', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  label: const Text('Open in UPI App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ),
              const SizedBox(height: 16),

              // Note
              Text(
                'After payment, manually confirm in the app.',
                style: TextStyle(color: subtitleColor, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QrPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paintDark = Paint()..color = const Color(0xFF1E1E1E);
    final paintLight = Paint()..color = Colors.white;

    // Corner Finder Patterns
    void drawFinderPattern(double x, double y) {
      // Outer black square 42x42
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x, y, 46, 46), const Radius.circular(8)), paintDark);
      // Inner white square 30x30
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 6, y + 6, 34, 34), const Radius.circular(4)), paintLight);
      // Center black square 18x18
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x + 13, y + 13, 20, 20), const Radius.circular(3)), paintDark);
    }

    drawFinderPattern(10, 10);
    drawFinderPattern(size.width - 56, 10);
    drawFinderPattern(10, size.height - 56);

    // Decorative grid blocks simulating UPI payload
    final randomGrid = [
      [0, 1, 0, 1, 1, 0, 1, 0],
      [1, 0, 1, 0, 0, 1, 0, 1],
      [0, 1, 1, 0, 1, 1, 0, 0],
      [1, 1, 0, 1, 0, 0, 1, 1],
      [0, 0, 1, 1, 1, 0, 1, 0],
      [1, 0, 0, 1, 0, 1, 1, 1],
      [0, 1, 1, 0, 1, 0, 0, 1],
      [1, 0, 1, 1, 0, 1, 1, 0],
    ];

    final blockW = (size.width - 40) / 16;
    for (int r = 0; r < 8; r++) {
      for (int c = 0; c < 8; c++) {
        if (randomGrid[r][c] == 1) {
          canvas.drawRRect(
            RRect.fromRectAndRadius(
              Rect.fromLTWH(65 + (c * blockW), 65 + (r * blockW), blockW - 2, blockW - 2),
              const Radius.circular(1.5),
            ),
            paintDark,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

