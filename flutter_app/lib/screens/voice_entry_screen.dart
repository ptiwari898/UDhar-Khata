import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class ParsedVoiceEntry {
  final String customerName;
  final double amount;
  final String type;
  final String note;
  final String paymentMethod;

  const ParsedVoiceEntry({
    required this.customerName,
    required this.amount,
    required this.type,
    required this.note,
    this.paymentMethod = 'Cash',
  });
}

class VoiceEntryScreen extends StatefulWidget {
  final LedgerState state;
  const VoiceEntryScreen({super.key, required this.state});

  @override
  State<VoiceEntryScreen> createState() => _VoiceEntryScreenState();
}

class _VoiceEntryScreenState extends State<VoiceEntryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  bool _isListening = false;
  String _selectedLang = 'Hindi';
  ParsedVoiceEntry? _parsedResult;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  ParsedVoiceEntry _parseSpokenPhrase(String text) {
    final lower = text.toLowerCase();
    String type = 'UDHAAR';
    if (lower.contains('payment') || lower.contains('mila') || lower.contains('jama') || lower.contains('received')) {
      type = 'PAYMENT';
    } else if (lower.contains('advance') || lower.contains('peshgi')) {
      type = 'ADVANCE';
    }

    double amount = 500;
    final numMatch = RegExp(r'(\d+)').firstMatch(text);
    if (numMatch != null) {
      amount = double.tryParse(numMatch.group(1)!) ?? 500;
    }

    String customerName = 'Ramesh Kumar';
    for (final c in widget.state.customers) {
      if (lower.contains(c.name.toLowerCase().split(' ').first)) {
        customerName = c.name;
        break;
      }
    }

    String note = 'Tel';
    if (lower.contains('tel')) {
      note = 'Tel (Oil)';
    } else if (lower.contains('rashan') || lower.contains('kirana')) {
      note = 'Kirana Items';
    } else if (lower.contains('cash')) {
      note = 'Cash Payment';
    }

    return ParsedVoiceEntry(
      customerName: customerName,
      amount: amount,
      type: type,
      note: note,
      paymentMethod: 'Cash',
    );
  }

  void _simulateVoiceInput(String phrase) {
    setState(() => _isListening = true);

    Future.delayed(const Duration(milliseconds: 1000), () {
      if (!mounted) return;
      final parsed = _parseSpokenPhrase(phrase);
      setState(() {
        _isListening = false;
        _parsedResult = parsed;
      });
    });
  }

  void _confirmAndSave() {
    if (_parsedResult == null) return;
    final r = _parsedResult!;

    Customer? matchedCust;
    for (final c in widget.state.customers) {
      if (c.name.toLowerCase().contains(r.customerName.toLowerCase()) ||
          r.customerName.toLowerCase().contains(c.name.toLowerCase())) {
        matchedCust = c;
        break;
      }
    }
    matchedCust ??= widget.state.customers.first;

    widget.state.addTransaction(
      customerId: matchedCust.id,
      amount: r.amount,
      type: r.type,
      note: r.note,
      paymentMethod: r.paymentMethod,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved ₹${r.amount.toInt()} ${r.type} for ${matchedCust.name}!'),
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

    if (_parsedResult != null) {
      return _buildConfirmTransactionScreen(p, cardBg, cardBorder, titleColor, subtitleColor);
    }

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
            'Voice Entry',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // Concentric Glowing Mic Button
              GestureDetector(
                onTap: () => _simulateVoiceInput('Ramesh ko 500 ka tel diya'),
                child: AnimatedBuilder(
                  animation: _animController,
                  builder: (context, child) {
                    final scale = 1.0 + (_isListening ? _animController.value * 0.15 : 0.05);
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          width: 220 * scale,
                          height: 220 * scale,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: p.primaryAccent.withValues(alpha: 0.12),
                          ),
                        ),
                        Container(
                          width: 170,
                          height: 170,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: p.primaryAccent.withValues(alpha: 0.22),
                          ),
                        ),
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [p.primaryAccent, p.primaryAccent.withValues(alpha: 0.8)],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: p.primaryAccent.withValues(alpha: 0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Icon(Icons.mic, size: 52, color: p.textDarkOnWhite),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),

              Text(
                _isListening ? 'Listening... बोलिए...' : 'Tap and speak',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: titleColor),
              ),
              const SizedBox(height: 28),

              _buildSampleVoiceCard('"Ramesh ko 500 ka tel diya"', p, cardBg, cardBorder, subtitleColor),
              const SizedBox(height: 10),
              _buildSampleVoiceCard('"Sanjay se 1000 cash mila"', p, cardBg, cardBorder, subtitleColor),
              const SizedBox(height: 10),
              _buildSampleVoiceCard('"Maa Traders ko 2000 udhaar"', p, cardBg, cardBorder, subtitleColor),
              const SizedBox(height: 36),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildLangChip('Hindi', p, cardBg, cardBorder, titleColor),
                  const SizedBox(width: 8),
                  _buildLangChip('Hinglish', p, cardBg, cardBorder, titleColor),
                  const SizedBox(width: 8),
                  _buildLangChip('English', p, cardBg, cardBorder, titleColor),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSampleVoiceCard(String text, ThemePalette p, Color cardBg, Color cardBorder, Color subtitleColor) {
    return GestureDetector(
      onTap: () => _simulateVoiceInput(text.replaceAll('"', '')),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cardBorder),
        ),
        child: Row(
          children: [
            Icon(Icons.record_voice_over, size: 18, color: p.primaryAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: TextStyle(color: subtitleColor, fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLangChip(String lang, ThemePalette p, Color cardBg, Color cardBorder, Color titleColor) {
    final isSelected = _selectedLang == lang;
    return GestureDetector(
      onTap: () => setState(() => _selectedLang = lang),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? p.primaryAccent : cardBg,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? p.primaryAccent : cardBorder),
        ),
        child: Text(
          lang,
          style: TextStyle(
            color: isSelected ? p.textDarkOnWhite : titleColor,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmTransactionScreen(ThemePalette p, Color cardBg, Color cardBorder, Color titleColor, Color subtitleColor) {
    final r = _parsedResult!;
    return AtmosphericBackdrop(
      palette: p,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: titleColor),
            onPressed: () => setState(() => _parsedResult = null),
          ),
          title: Text(
            'Confirm Transaction',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: cardBorder),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: p.isDark ? 0.2 : 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildParsedRow(Icons.person, p.greenAdvance, 'Customer', r.customerName, p, titleColor),
                    Divider(height: 24, color: cardBorder),
                    _buildParsedRow(Icons.currency_rupee, p.primaryAccent, 'Amount', '₹${r.amount.toInt()}', p, titleColor),
                    Divider(height: 24, color: cardBorder),
                    _buildParsedRow(Icons.swap_horiz, p.isDark ? const Color(0xFF60A5FA) : const Color(0xFF3B82F6), 'Type', r.type, p, titleColor),
                    Divider(height: 24, color: cardBorder),
                    _buildParsedRow(Icons.notes, const Color(0xFF8B5CF6), 'Item / Note', r.note.isNotEmpty ? r.note : 'General items', p, titleColor),
                    Divider(height: 24, color: cardBorder),
                    _buildParsedRow(Icons.calendar_today, subtitleColor, 'Date', '${DateTime.now().day} Sep ${DateTime.now().year}', p, titleColor),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: titleColor,
                          side: BorderSide(color: cardBorder),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        ),
                        onPressed: () => setState(() => _parsedResult = null),
                        child: const Text('Edit', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primaryAccent,
                          foregroundColor: p.textDarkOnWhite,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          elevation: 2,
                        ),
                        onPressed: _confirmAndSave,
                        child: const Text('Confirm & Save', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParsedRow(IconData icon, Color iconColor, String label, String value, ThemePalette p, Color titleColor) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withValues(alpha: 0.15),
          ),
          child: Icon(icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 12, color: p.textMuted)),
              const SizedBox(height: 2),
              Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: titleColor)),
            ],
          ),
        ),
      ],
    );
  }
}

