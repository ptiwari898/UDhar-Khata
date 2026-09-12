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
    final messages = state.chatMessages.where((m) => m.customerId == widget.customer.id).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundSlate,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.customer.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(widget.customer.phone, style: const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
          ],
        ),
      ),
      body: AtmosphericBackdrop(
        child: Column(
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
                        color: isMe ? AppColors.primaryBlueBg.withValues(alpha: 0.85) : AppColors.cardSurface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isMe ? AppColors.primaryBlue.withValues(alpha: 0.35) : Colors.white12,
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
                                color: msg.messageType == 'BILL' ? AppColors.redBg : AppColors.greenBg,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                msg.messageType,
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold,
                                  color: msg.messageType == 'BILL' ? AppColors.redUdhar : AppColors.greenAdvance,
                                ),
                              ),
                            ),
                          Text(msg.message, style: const TextStyle(color: AppColors.textPrimary, fontSize: 13)),
                          const SizedBox(height: 4),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${msg.timestamp.hour}:${msg.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(fontSize: 9, color: AppColors.textMuted),
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
                color: AppColors.backgroundSlate,
                border: Border(top: BorderSide(color: Colors.white.withValues(alpha: 0.1))),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      style: const TextStyle(color: AppColors.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Type a message or note...',
                        hintStyle: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                        filled: true,
                        fillColor: Colors.white.withValues(alpha: 0.06),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  CircleAvatar(
                    backgroundColor: AppColors.primaryBlue,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Color(0xFF062622), size: 18),
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
