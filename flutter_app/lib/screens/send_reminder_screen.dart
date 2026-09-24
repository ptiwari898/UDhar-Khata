import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class SendReminderScreen extends StatefulWidget {
  final LedgerState state;
  final Customer customer;
  final double amount;

  const SendReminderScreen({
    super.key,
    required this.state,
    required this.customer,
    required this.amount,
  });

  @override
  State<SendReminderScreen> createState() => _SendReminderScreenState();
}

class _SendReminderScreenState extends State<SendReminderScreen> {
  late TextEditingController _msgCtrl;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final profile = widget.state.shopProfile;
    final defaultMsg =
        'Namaste ${widget.customer.name} ji 🙏\n\n'
        'Aapke account mein ₹${widget.amount.toInt()} baki hai.\n\n'
        'Kripya suvidha anusar payment kar dein.\n\n'
        'Dhanyavaad,\n${profile.shopName}';
    _msgCtrl = TextEditingController(text: defaultMsg);
  }

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.state.activePalette;
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    final bubbleBg = p.isDark ? const Color(0xFF1E3A29) : const Color(0xFFE2F7CB);
    final bubbleBorder = p.isDark ? const Color(0xFF2D5A3F) : const Color(0xFFC7EBB0);
    final bubbleTextColor = p.isDark ? const Color(0xFFDCFCE7) : const Color(0xFF1E1E1E);

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
            'Send Reminder',
            style: TextStyle(color: titleColor, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: false,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // WhatsApp Chat Preview Bubble
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: bubbleBg,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                    bottomLeft: Radius.circular(4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: p.isDark ? 0.2 : 0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                  border: Border.all(color: bubbleBorder),
                ),
                child: _isEditing
                    ? TextField(
                        controller: _msgCtrl,
                        maxLines: 8,
                        style: TextStyle(color: bubbleTextColor, fontSize: 15, height: 1.5),
                        decoration: const InputDecoration(border: InputBorder.none),
                      )
                    : Text(
                        _msgCtrl.text,
                        style: TextStyle(
                          color: bubbleTextColor,
                          fontSize: 15,
                          height: 1.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              const SizedBox(height: 24),

              // Send via WhatsApp Button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF25D366),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    elevation: 2,
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('WhatsApp reminder sent to ${widget.customer.name} (${widget.customer.phone})!'),
                        backgroundColor: const Color(0xFF16A34A),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.chat, size: 22),
                  label: const Text('Send via WhatsApp', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 12),

              // Edit Message / Done Button
              TextButton(
                onPressed: () => setState(() => _isEditing = !_isEditing),
                child: Text(
                  _isEditing ? 'Done Editing' : 'Edit Message',
                  style: TextStyle(color: subtitleColor, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

