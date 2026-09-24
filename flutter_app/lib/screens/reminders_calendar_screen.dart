import 'package:flutter/material.dart';
import '../models/models.dart';
import '../state/ledger_state.dart';
import '../theme/app_theme.dart';
import '../widgets/modals.dart';

class RemindersCalendarScreen extends StatefulWidget {
  final LedgerState state;
  final VoidCallback? onBack;

  const RemindersCalendarScreen({
    super.key,
    required this.state,
    this.onBack,
  });

  @override
  State<RemindersCalendarScreen> createState() => _RemindersCalendarScreenState();
}

class _RemindersCalendarScreenState extends State<RemindersCalendarScreen> {
  DateTime _selectedDate = DateTime.now();
  String _activeFilter = 'ALL'; // 'ALL', 'TODAY_OVERDUE', 'RECOVER_UDHAR', 'PAY_SUPPLIER', 'SETTLED'

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final p = state.activePalette;
    final allReminders = state.reminders;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);
    final titleColor = p.textPrimary;
    final subtitleColor = p.textSecondary;

    // Summary calculations
    double totalToRecover = 0;
    double totalToPay = 0;
    int overdueCount = 0;
    int dueTodayCount = 0;

    for (final r in allReminders) {
      if (!r.isSettled) {
        if (r.reminderType == 'RECOVER_UDHAR') {
          totalToRecover += r.amount;
        } else {
          totalToPay += r.amount;
        }

        final rDate = DateTime(r.dueDate.year, r.dueDate.month, r.dueDate.day);
        if (rDate.isBefore(today)) {
          overdueCount++;
        } else if (rDate.isAtSameMomentAs(today)) {
          dueTodayCount++;
        }
      }
    }

    // Filter reminders
    List<PaymentReminder> filtered = allReminders.where((r) {
      final rDate = DateTime(r.dueDate.year, r.dueDate.month, r.dueDate.day);
      if (_activeFilter == 'TODAY_OVERDUE') {
        return !r.isSettled && (rDate.isBefore(today) || rDate.isAtSameMomentAs(today));
      } else if (_activeFilter == 'RECOVER_UDHAR') {
        return !r.isSettled && r.reminderType == 'RECOVER_UDHAR';
      } else if (_activeFilter == 'PAY_SUPPLIER') {
        return !r.isSettled && r.reminderType == 'PAY_SUPPLIER';
      } else if (_activeFilter == 'SETTLED') {
        return r.isSettled;
      }
      return true;
    }).toList();

    filtered.sort((a, b) {
      if (a.isSettled != b.isSettled) {
        return a.isSettled ? 1 : -1;
      }
      return a.dueDate.compareTo(b.dueDate);
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: widget.onBack != null
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: titleColor),
                onPressed: widget.onBack,
              )
            : null,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: p.primaryAccent.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.calendar_month_rounded, color: p.primaryAccent, size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment & Bill Reminders',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: titleColor),
                  ),
                  Text(
                    'उधारी वसूली व बिल भुगतान कैलेंडर',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 11, color: subtitleColor),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.add_alert_rounded, color: p.primaryAccent),
            tooltip: 'Add Due Date Reminder',
            onPressed: () => Modals.showAddReminder(context, state),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Summary Cards
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
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
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: p.redBg,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.call_received, color: p.redUdhar, size: 16),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text('Recover Udhar', style: TextStyle(color: subtitleColor, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹ ${totalToRecover.toInt()}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: p.redUdhar),
                        ),
                        Text('ग्राहकों से लेना है', style: TextStyle(color: subtitleColor, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(14),
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
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: p.primaryAccent.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.call_made, color: p.primaryAccent, size: 16),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text('Pay Bills', style: TextStyle(color: subtitleColor, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹ ${totalToPay.toInt()}',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: p.primaryAccent),
                        ),
                        Text('सप्लायर को देना है', style: TextStyle(color: subtitleColor, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3 Alert Options Info Strip
            Container(
              padding: const EdgeInsets.all(14),
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
                      Icon(Icons.notifications_active_outlined, color: p.primaryAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'Smart 3-Tier Alert System',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: titleColor),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAlertBadge('⚡ 1. On Due Date', 'Same day 9 AM', p),
                      const SizedBox(width: 6),
                      _buildAlertBadge('🔔 2. 1 Day Prior', '24h advance alert', p),
                      const SizedBox(width: 6),
                      _buildAlertBadge('📅 3. 3 Days Prior', 'Heavy balance alert', p),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Horizontal Date Strip (Calendar Quick Selector)
            Text(
              'Select Calendar Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: titleColor),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 74,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 14,
                itemBuilder: (context, idx) {
                  final date = DateTime.now().subtract(const Duration(days: 2)).add(Duration(days: idx));
                  final isSelected = date.year == _selectedDate.year &&
                      date.month == _selectedDate.month &&
                      date.day == _selectedDate.day;
                  final isToday = date.year == today.year && date.month == today.month && date.day == today.day;
                  final dayReminders = state.getRemindersForDate(date);
                  final hasUdhar = dayReminders.any((r) => r.reminderType == 'RECOVER_UDHAR' && !r.isSettled);
                  final hasBill = dayReminders.any((r) => r.reminderType == 'PAY_SUPPLIER' && !r.isSettled);

                  const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                  final dayName = weekdays[date.weekday - 1];

                  return InkWell(
                    onTap: () => setState(() => _selectedDate = date),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      width: 58,
                      margin: const EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? p.primaryAccent
                            : (isToday ? p.primaryAccent.withValues(alpha: 0.15) : cardBg),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? p.primaryAccent
                              : (isToday ? p.primaryAccent.withValues(alpha: 0.5) : cardBorder),
                          width: isSelected || isToday ? 1.5 : 1.0,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            dayName,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: isSelected ? p.textDarkOnWhite : subtitleColor,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? p.textDarkOnWhite : titleColor,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (hasUdhar)
                                Container(
                                  width: 5,
                                  height: 5,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: p.redUdhar,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              if (hasBill)
                                Container(
                                  width: 5,
                                  height: 5,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isSelected ? p.textDarkOnWhite : p.primaryAccent,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),

            // Filter Tabs
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip('ALL', 'All (${allReminders.length})', p),
                  _buildFilterChip('TODAY_OVERDUE', '⚡ Due Today / Overdue (${dueTodayCount + overdueCount})', p),
                  _buildFilterChip('RECOVER_UDHAR', '💰 Recover Udhar', p),
                  _buildFilterChip('PAY_SUPPLIER', '📦 Supplier Bills', p),
                  _buildFilterChip('SETTLED', '✅ Settled', p),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Reminders List
            if (filtered.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 40),
                  child: Column(
                    children: [
                      Icon(Icons.event_available, size: 52, color: subtitleColor.withValues(alpha: 0.5)),
                      const SizedBox(height: 12),
                      Text(
                        'No Reminders Found',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: titleColor),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Tap "Set Reminder" to schedule payment recovery or bill alerts.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: subtitleColor),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: p.primaryAccent,
                          foregroundColor: p.textDarkOnWhite,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () => Modals.showAddReminder(context, state),
                        icon: const Icon(Icons.add_alarm_rounded, size: 18),
                        label: const Text('Add Due Date Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filtered.map((reminder) => _buildReminderCard(context, state, reminder, today, p)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: null,
        backgroundColor: p.primaryAccent,
        foregroundColor: p.textDarkOnWhite,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        onPressed: () => Modals.showAddReminder(context, state),
        icon: const Icon(Icons.add_alarm_rounded, size: 20),
        label: const Text('Set Reminder', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
      ),
    );
  }

  Widget _buildAlertBadge(String title, String desc, ThemePalette p) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: p.isDark ? AppColors.popupSurface.withValues(alpha: 0.8) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: p.isDark ? Colors.white12 : const Color(0xFFE5E7EB)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: p.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              desc,
              style: TextStyle(fontSize: 8, color: p.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, ThemePalette p) {
    final isSelected = _activeFilter == key;
    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _activeFilter = key),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? p.primaryAccent : cardBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? p.primaryAccent : cardBorder,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? p.textDarkOnWhite : p.textSecondary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReminderCard(
    BuildContext context,
    LedgerState state,
    PaymentReminder reminder,
    DateTime today,
    ThemePalette p,
  ) {
    final rDate = DateTime(reminder.dueDate.year, reminder.dueDate.month, reminder.dueDate.day);
    final daysDiff = rDate.difference(today).inDays;

    final cardBg = p.isDark ? AppColors.popupSurface : Colors.white;
    final cardBorder = p.isDark ? Colors.white12 : const Color(0xFFE5E7EB);

    String statusText;
    Color statusColor;
    Color statusBg;
    if (reminder.isSettled) {
      statusText = '✅ SETTLED / चुकता';
      statusColor = p.greenAdvance;
      statusBg = p.greenBg;
    } else if (daysDiff < 0) {
      statusText = '⚠️ OVERDUE (${-daysDiff}d ago)';
      statusColor = p.redUdhar;
      statusBg = p.redBg;
    } else if (daysDiff == 0) {
      statusText = '⚡ DUE TODAY (आज)';
      statusColor = p.orangeMedium;
      statusBg = p.orangeBg;
    } else if (daysDiff == 1) {
      statusText = '🔔 DUE TOMORROW (कल)';
      statusColor = p.primaryAccent;
      statusBg = p.primaryAccent.withValues(alpha: 0.18);
    } else {
      statusText = '📅 IN $daysDiff DAYS';
      statusColor = p.textSecondary;
      statusBg = p.isDark ? Colors.white10 : const Color(0xFFF3F4F6);
    }

    final isUdhar = reminder.reminderType == 'RECOVER_UDHAR';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
          // Header row: Status & Type
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: statusColor.withValues(alpha: 0.4)),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (isUdhar ? p.redUdhar : p.primaryAccent).withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isUdhar ? '💰 RECOVER UDHAR' : '📦 PAY SUPPLIER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isUdhar ? p.redUdhar : p.primaryAccent,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Main Info Row: Title & Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      reminder.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: p.textPrimary,
                        decoration: reminder.isSettled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (reminder.note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        reminder.note,
                        style: TextStyle(color: p.textSecondary, fontSize: 12),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '₹ ${reminder.amount.toInt()}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: reminder.isSettled
                      ? p.textSecondary
                      : (isUdhar ? p.redUdhar : p.primaryAccent),
                  decoration: reminder.isSettled ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Due Date & Alert Pill
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 14, color: p.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Due: ${reminder.dueDate.day.toString().padLeft(2, '0')}/${reminder.dueDate.month.toString().padLeft(2, '0')}/${reminder.dueDate.year}',
                style: TextStyle(fontSize: 12, color: p.textSecondary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: p.primaryAccent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: p.primaryAccent.withValues(alpha: 0.4)),
                ),
                child: Text(
                  state.getAlertOptionLabel(reminder.alertOption),
                  style: TextStyle(fontSize: 10, color: p.primaryAccent, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: cardBorder, height: 1),
          const SizedBox(height: 8),

          // Actions
          Row(
            children: [
              // WhatsApp 1-tap Send Reminder
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: const BorderSide(color: Color(0xFF25D366)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    final shopName = state.shopProfile.shopName;
                    final amt = reminder.amount.toInt();
                    final dueStr = '${reminder.dueDate.day}/${reminder.dueDate.month}/${reminder.dueDate.year}';
                    final msg = isUdhar
                        ? 'Namaste ${reminder.title} ji, this is a polite reminder from $shopName that your payment of Rs. $amt is due on $dueStr. Kindly settle it via UPI or cash. Dhanyawad!'
                        : 'Reminder: Supplier bill for ${reminder.title} of Rs. $amt is due on $dueStr.';

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('📲 WhatsApp alert ready: "$msg"'),
                        backgroundColor: const Color(0xFF25D366),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  icon: const Icon(Icons.send_rounded, color: Color(0xFF25D366), size: 16),
                  label: const Text(
                    'Send Alert',
                    style: TextStyle(color: Color(0xFF25D366), fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Toggle Settled Button
              IconButton.filledTonal(
                style: IconButton.styleFrom(
                  backgroundColor: reminder.isSettled
                      ? p.greenBg
                      : (p.isDark ? Colors.white10 : const Color(0xFFF3F4F6)),
                ),
                icon: Icon(
                  reminder.isSettled ? Icons.check_circle : Icons.check_circle_outline,
                  color: reminder.isSettled ? p.greenAdvance : p.textSecondary,
                  size: 20,
                ),
                tooltip: reminder.isSettled ? 'Mark Unsettled' : 'Mark Settled (चुकता)',
                onPressed: () {
                  state.toggleReminderSettled(reminder.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        reminder.isSettled ? 'Marked as Pending' : 'Marked as Settled / चुकता!',
                      ),
                    ),
                  );
                },
              ),

              // Delete Reminder
              IconButton(
                icon: Icon(Icons.delete_outline, color: p.textSecondary.withValues(alpha: 0.6), size: 20),
                tooltip: 'Delete Reminder',
                onPressed: () => state.deleteReminder(reminder.id),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
