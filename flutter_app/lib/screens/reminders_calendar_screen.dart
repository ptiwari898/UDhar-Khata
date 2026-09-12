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
    final allReminders = state.reminders;
    final today = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

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
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: widget.onBack,
              )
            : null,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.calendar_month_rounded, color: AppColors.primaryBlue, size: 20),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Payment & Bill Reminders',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                ),
                Text(
                  'उधारी वसूली व बिल भुगतान कैलेंडर',
                  style: TextStyle(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_alert_rounded, color: AppColors.primaryBlue),
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
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.redUdhar.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.call_received, color: AppColors.redUdhar, size: 16),
                            ),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text('Recover Udhar', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹ ${totalToRecover.toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.redUdhar),
                        ),
                        const Text('ग्राहकों से लेना है', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GlassCard(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.call_made, color: AppColors.primaryBlue, size: 16),
                            ),
                            const SizedBox(width: 6),
                            const Expanded(
                              child: Text('Pay Bills', style: TextStyle(color: AppColors.textSecondary, fontSize: 11)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹ ${totalToPay.toInt()}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryBlue),
                        ),
                        const Text('सप्लायर को देना है', style: TextStyle(color: AppColors.textSecondary, fontSize: 10)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // 3 Alert Options Info Strip
            GlassCard(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.notifications_active_outlined, color: AppColors.primaryBlue, size: 18),
                      SizedBox(width: 8),
                      Text(
                        'Smart 3-Tier Alert System',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildAlertBadge('⚡ 1. On Due Date', 'Same day 9 AM'),
                      const SizedBox(width: 6),
                      _buildAlertBadge('🔔 2. 1 Day Prior', '24h advance alert'),
                      const SizedBox(width: 6),
                      _buildAlertBadge('📅 3. 3 Days Prior', 'Heavy balance alert'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Horizontal Date Strip (Calendar Quick Selector)
            const Text(
              'Select Calendar Date',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.textPrimary),
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
                            ? AppColors.primaryBlue
                            : (isToday ? AppColors.primaryBlue.withValues(alpha: 0.15) : AppColors.cardSurface),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryBlue
                              : (isToday ? AppColors.primaryBlue.withValues(alpha: 0.4) : Colors.white10),
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
                              color: isSelected ? const Color(0xFF062622) : AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${date.day}',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isSelected ? const Color(0xFF062622) : AppColors.textPrimary,
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
                                  decoration: const BoxDecoration(
                                    color: AppColors.redUdhar,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              if (hasBill)
                                Container(
                                  width: 5,
                                  height: 5,
                                  margin: const EdgeInsets.symmetric(horizontal: 1),
                                  decoration: BoxDecoration(
                                    color: isSelected ? const Color(0xFF062622) : AppColors.primaryBlue,
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
                  _buildFilterChip('ALL', 'All (${allReminders.length})'),
                  _buildFilterChip('TODAY_OVERDUE', '⚡ Due Today / Overdue (${dueTodayCount + overdueCount})'),
                  _buildFilterChip('RECOVER_UDHAR', '💰 Recover Udhar'),
                  _buildFilterChip('PAY_SUPPLIER', '📦 Supplier Bills'),
                  _buildFilterChip('SETTLED', '✅ Settled'),
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
                      const Icon(Icons.event_available, size: 52, color: Colors.white24),
                      const SizedBox(height: 12),
                      const Text(
                        'No Reminders Found',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap "Set Reminder" to schedule payment recovery or bill alerts.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.white38),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: const Color(0xFF062622),
                        ),
                        onPressed: () => Modals.showAddReminder(context, state),
                        icon: const Icon(Icons.add_alarm_rounded),
                        label: const Text('Add Due Date Reminder'),
                      ),
                    ],
                  ),
                ),
              )
            else
              ...filtered.map((reminder) => _buildReminderCard(context, state, reminder, today)),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: const Color(0xFF062622),
        onPressed: () => Modals.showAddReminder(context, state),
        icon: const Icon(Icons.add_alarm_rounded),
        label: const Text('Set Reminder', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildAlertBadge(String title, String desc) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.backgroundSlate.withValues(alpha: 0.6),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              desc,
              style: const TextStyle(fontSize: 8, color: AppColors.textSecondary),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label) {
    final isSelected = _activeFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => setState(() => _activeFilter = key),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryBlue : AppColors.cardSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: isSelected ? AppColors.primaryBlue : Colors.white12),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? const Color(0xFF062622) : AppColors.textSecondary,
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
  ) {
    final rDate = DateTime(reminder.dueDate.year, reminder.dueDate.month, reminder.dueDate.day);
    final daysDiff = rDate.difference(today).inDays;

    String statusText;
    Color statusColor;
    if (reminder.isSettled) {
      statusText = '✅ SETTLED / चुकता';
      statusColor = AppColors.greenAdvance;
    } else if (daysDiff < 0) {
      statusText = '⚠️ OVERDUE (${-daysDiff}d ago)';
      statusColor = AppColors.redUdhar;
    } else if (daysDiff == 0) {
      statusText = '⚡ DUE TODAY (आज)';
      statusColor = const Color(0xFFFFA726);
    } else if (daysDiff == 1) {
      statusText = '🔔 DUE TOMORROW (कल)';
      statusColor = AppColors.primaryBlue;
    } else {
      statusText = '📅 IN $daysDiff DAYS';
      statusColor = AppColors.textSecondary;
    }

    final isUdhar = reminder.reminderType == 'RECOVER_UDHAR';

    return GlassCard(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
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
                  color: statusColor.withValues(alpha: 0.15),
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
                  color: (isUdhar ? AppColors.redUdhar : AppColors.primaryBlue).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isUdhar ? '💰 RECOVER UDHAR' : '📦 PAY SUPPLIER',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isUdhar ? AppColors.redUdhar : AppColors.primaryBlue,
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
                        color: AppColors.textPrimary,
                        decoration: reminder.isSettled ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (reminder.note.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        reminder.note,
                        style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
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
                      ? AppColors.textSecondary
                      : (isUdhar ? AppColors.redUdhar : AppColors.primaryBlue),
                  decoration: reminder.isSettled ? TextDecoration.lineThrough : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Due Date & Alert Pill
          Row(
            children: [
              const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(
                'Due: ${reminder.dueDate.day.toString().padLeft(2, '0')}/${reminder.dueDate.month.toString().padLeft(2, '0')}/${reminder.dueDate.year}',
                style: const TextStyle(fontSize: 12, color: AppColors.textSecondary),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.cardSurface,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white12),
                ),
                child: Text(
                  state.getAlertOptionLabel(reminder.alertOption),
                  style: const TextStyle(fontSize: 10, color: AppColors.primaryBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white10, height: 1),
          const SizedBox(height: 8),

          // Actions
          Row(
            children: [
              // WhatsApp 1-tap Send Reminder
              Expanded(
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    side: BorderSide(color: const Color(0xFF25D366).withValues(alpha: 0.6)),
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
                      ? AppColors.greenAdvance.withValues(alpha: 0.2)
                      : AppColors.cardSurface,
                ),
                icon: Icon(
                  reminder.isSettled ? Icons.check_circle : Icons.check_circle_outline,
                  color: reminder.isSettled ? AppColors.greenAdvance : AppColors.textSecondary,
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
                icon: const Icon(Icons.delete_outline, color: Colors.white38, size: 20),
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
