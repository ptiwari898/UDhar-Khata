import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';

class CustomerChatScreen extends StatefulWidget {
  final Customer customer;
  final LedgerState state;

  const CustomerChatScreen({
    super.key,
    required this.customer,
    required this.state,
  });

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final _msgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final p = state.activePalette;
    final messages = state.chatMessages.where((m) => m.customerId == widget.customer.id).toList();

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
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.customer.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor)),
              Text(widget.customer.phone, style: TextStyle(fontSize: 11, color: subtitleColor)),
            ],
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: messages.length,
                itemBuilder: (ctx, i) {
                  final msg = messages[i];
                  final isMe = msg.sender == 'SHOP';
                  return Align(
                    alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      padding: const EdgeInsets.all(12),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      decoration: BoxDecoration(
                        color: isMe ? p.primaryAccent.withValues(alpha: 0.85) : cardBg,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isMe ? p.primaryAccent : cardBorder,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (msg.messageType != 'TEXT')
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: msg.messageType == 'BILL' ? p.redBg : p.greenBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                msg.messageType,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: msg.messageType == 'BILL' ? p.redUdhar : p.greenAdvance,
                                ),
                              ),
                            ),
                          Text(msg.message, style: TextStyle(color: isMe ? p.textDarkOnWhite : titleColor, fontSize: 13)),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                              style: TextStyle(fontSize: 9, color: isMe ? p.textDarkOnWhite.withValues(alpha: 0.7) : p.textMuted),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: cardBg,
                border: Border(top: BorderSide(color: cardBorder)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      style: TextStyle(color: titleColor),
                      decoration: InputDecoration(
                        hintText: 'Type a message or note...',
                        hintStyle: TextStyle(color: p.textMuted, fontSize: 13),
                        filled: true,
                        fillColor: cardBg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: cardBorder)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide(color: cardBorder)),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: p.primaryAccent,
                    child: IconButton(
                      icon: Icon(Icons.send, color: p.textDarkOnWhite, size: 18),
                      onPressed: () {
                        final text = _msgCtrl.text.trim();
                        if (text.isNotEmpty) {
                          state.sendChatMessage(widget.customer.id, text);
                          _msgCtrl.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

