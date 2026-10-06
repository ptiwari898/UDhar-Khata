import 'dart:async';
import 'dart:convert';

import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/auth/auth_service.dart';
import '../data/repository/ledger_repository.dart';
import '../data/storage_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'app_translations.dart';

class LedgerState extends ChangeNotifier {
  final AuthService authService;
  final LedgerRepository repository;
  final LocalStorageService _storageService = LocalStorageService();

  AppThemeMode _themeMode = AppThemeMode.lightMode;
  AppLanguage _language = AppLanguage.english;
  bool _glassEffectEnabled = true;
  double _glassBlurSigma = 22.0;
  bool _isDarkTheme = false;
  bool _useSystemColors = false;
  String _selectedThemeColor = 'BLUE';
  ColorScheme? _systemLightScheme;
  ColorScheme? _systemDarkScheme;

  AppThemeMode get themeMode => _themeMode;
  ThemePalette get activePalette => AppPalettes.getPalette(
        _themeMode,
        selectedPreset: _selectedThemeColor,
        isDarkOverride: _isDarkTheme,
        dynamicScheme: _dynamicScheme,
      );

  /// Whether the platform exposes Material You wallpaper colors
  /// (Android 12+, or an accent color on desktop).
  bool get systemColorsAvailable => _systemLightScheme != null;

  ColorScheme? get _dynamicScheme {
    if (!_useSystemColors) return null;
    return _isDarkTheme ? _systemDarkScheme : _systemLightScheme;
  }

  /// The Material 3 color scheme for the app: wallpaper-based dynamic colors
  /// when "Use System Colors" is on and available, otherwise seeded from the
  /// selected preset.
  ColorScheme get colorScheme {
    final dynamicScheme = _dynamicScheme;
    if (dynamicScheme != null) return dynamicScheme;
    final preset = WallvaultPresets.getPreset(_selectedThemeColor);
    return ColorScheme.fromSeed(
      seedColor: preset.primary,
      brightness: _isDarkTheme ? Brightness.dark : Brightness.light,
    );
  }

  Future<void> _loadSystemColors() async {
    try {
      final corePalette = await DynamicColorPlugin.getCorePalette();
      if (corePalette != null) {
        _systemLightScheme = corePalette.toColorScheme();
        _systemDarkScheme = corePalette.toColorScheme(brightness: Brightness.dark);
      } else {
        final accent = await DynamicColorPlugin.getAccentColor();
        if (accent == null) return;
        _systemLightScheme = ColorScheme.fromSeed(seedColor: accent);
        _systemDarkScheme = ColorScheme.fromSeed(seedColor: accent, brightness: Brightness.dark);
      }
      notifyListeners();
    } catch (_) {
      // Platform without dynamic color support; presets remain in use.
    }
  }

  AppLanguage get language => _language;
  bool get glassEffectEnabled => _glassEffectEnabled;
  double get glassBlurSigma => _glassBlurSigma;
  bool get isDarkTheme => _isDarkTheme;
  bool get useSystemColors => _useSystemColors;
  String get selectedThemeColor => _selectedThemeColor;

  void setLanguage(AppLanguage lang) {
    _language = lang;
    notifyListeners();
    _persistPrefs();
  }

  String tr(String key) => AppTranslations.getText(key, _language);

  void setThemeMode(AppThemeMode mode) {
    _themeMode = mode;
    notifyListeners();
    _persistPrefs();
  }

  void setDarkTheme(bool isDark) {
    _isDarkTheme = isDark;
    notifyListeners();
    _persistPrefs();
  }

  void setUseSystemColors(bool useSystem) {
    _useSystemColors = useSystem;
    notifyListeners();
    _persistPrefs();
  }

  void setSelectedThemeColor(String colorName) {
    _selectedThemeColor = colorName.toUpperCase();
    notifyListeners();
    _persistPrefs();
  }

  void setGlassEffectEnabled(bool enabled) {
    _glassEffectEnabled = enabled;
    notifyListeners();
    _persistPrefs();
  }

  void setGlassBlurSigma(double sigma) {
    _glassBlurSigma = sigma;
    notifyListeners();
    _persistPrefs();
  }

  void cycleThemeMode() {
    switch (_themeMode) {
      case AppThemeMode.udharGlass:
        _themeMode = AppThemeMode.lightMode;
        break;
      case AppThemeMode.lightMode:
        _themeMode = AppThemeMode.udharGlass;
        break;
    }
    notifyListeners();
    _persistPrefs();
  }

  factory LedgerState({AuthService? authService, LedgerRepository? repository}) {
    final auth = authService ?? AuthService();
    final repo = repository ?? LedgerRepository(authService: auth);
    return LedgerState._(auth, repo);
  }

  LedgerState._(this.authService, this.repository) {
    _loadPrefs();
    _loadSystemColors();
    repository.onChanged.listen((_) => notifyListeners());
    authService.onAuthStateChange.listen((state) {
      if (state.session != null) {
        unawaited(repository.bootstrap());
      } else {
        unawaited(repository.reset());
      }
      notifyListeners();
    });
    if (authService.currentSession != null) {
      unawaited(repository.bootstrap());
    }
  }

  // Per-device UI preferences (theme/language/glass effect) are not ledger
  // data, so they're kept out of the Supabase sync path entirely and just
  // persisted locally via shared_preferences.
  Future<void> _loadPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeIndex = prefs.getInt('themeMode');
      if (themeIndex != null && themeIndex < AppThemeMode.values.length) {
        _themeMode = AppThemeMode.values[themeIndex];
      }
      final langIndex = prefs.getInt('language');
      if (langIndex != null && langIndex < AppLanguage.values.length) {
        _language = AppLanguage.values[langIndex];
      }
      _glassEffectEnabled = prefs.getBool('glassEffectEnabled') ?? _glassEffectEnabled;
      _glassBlurSigma = prefs.getDouble('glassBlurSigma') ?? _glassBlurSigma;
      _isDarkTheme = prefs.getBool('isDarkTheme') ?? _isDarkTheme;
      _useSystemColors = prefs.getBool('useSystemColors') ?? _useSystemColors;
      _selectedThemeColor = prefs.getString('selectedThemeColor') ?? _selectedThemeColor;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _persistPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('themeMode', _themeMode.index);
      await prefs.setInt('language', _language.index);
      await prefs.setBool('glassEffectEnabled', _glassEffectEnabled);
      await prefs.setDouble('glassBlurSigma', _glassBlurSigma);
      await prefs.setBool('isDarkTheme', _isDarkTheme);
      await prefs.setBool('useSystemColors', _useSystemColors);
      await prefs.setString('selectedThemeColor', _selectedThemeColor);
    } catch (_) {}
  }

  // ---- Auth ----

  /// A signed-in user, derived from the live Supabase session rather than
  /// a locally-fabricated profile. Null when signed out.
  UserAuthProfile? get currentUser {
    final user = authService.currentSession?.user;
    if (user == null) return null;
    final provider = user.appMetadata['provider'] as String?;
    final profileName = repository.shopProfile.ownerName;
    final fallbackName = user.userMetadata?['full_name'] as String? ?? user.userMetadata?['name'] as String?;
    return UserAuthProfile(
      uid: user.id,
      name: profileName.isNotEmpty ? profileName : (fallbackName ?? user.email ?? user.phone ?? 'User'),
      email: user.email ?? '',
      isGoogleUser: provider == 'google',
    );
  }

  Future<void> sendPhoneOtp(String e164Phone) => authService.sendPhoneOtp(e164Phone);

  Future<void> verifyPhoneOtp(String e164Phone, String token) async {
    await authService.verifyPhoneOtp(e164Phone, token);
    await repository.bootstrap();
    notifyListeners();
  }

  Future<void> signInWithGoogle() async {
    await authService.signInWithGoogle();
    await repository.bootstrap();
    notifyListeners();
  }

  Future<void> logout() async {
    await repository.reset();
    await authService.signOut();
    notifyListeners();
  }

  // ---- Profile ----

  ShopProfile get shopProfile => repository.shopProfile;

  Future<void> updateProfile(ShopProfile updated) => repository.updateProfile(updated);

  // ---- Customers ----

  List<Customer> get customers => List.unmodifiable(repository.customers);

  bool isPhoneDuplicate(String phone, {String? excludeCustomerId}) {
    final clean = phone.replaceAll(RegExp(r'\s+'), '');
    return repository.customers.any((c) =>
        c.id != excludeCustomerId &&
        c.phone.replaceAll(RegExp(r'\s+'), '') == clean &&
        clean.isNotEmpty);
  }

  bool isOverCreditLimit(Customer customer) {
    final summary = getCustomerSummary(customer);
    return summary.currentOutstanding > customer.creditLimit && customer.creditLimit > 0;
  }

  Future<Customer> addCustomer({
    required String name,
    required String phone,
    required String location,
    String riskLevel = 'Low',
    double creditLimit = 15000.0,
    String notes = '',
  }) {
    return repository.addCustomer(
      name: name,
      phone: phone,
      location: location,
      riskLevel: riskLevel,
      creditLimit: creditLimit,
      notes: notes,
    );
  }

  Future<void> updateCustomer(Customer updated) => repository.updateCustomer(updated);

  Future<void> deleteCustomer(String customerId) => repository.deleteCustomer(customerId);

  // ---- Transactions ----

  List<LedgerTransaction> get transactions => List.unmodifiable(repository.transactions);

  List<LedgerTransaction> getCustomerTransactions(String customerId) {
    return repository.transactions.where((t) => t.customerId == customerId).toList();
  }

  Future<LedgerTransaction> addTransaction({
    required String customerId,
    required String type,
    required double amount,
    String note = '',
    String paymentMethod = 'Cash',
    String reference = '',
    DateTime? date,
  }) {
    return repository.addTransaction(
      customerId: customerId,
      type: type,
      amount: amount,
      note: note,
      paymentMethod: paymentMethod,
      reference: reference,
      date: date,
    );
  }

  // ---- Orders ----

  List<CustomerOrder> get orders => List.unmodifiable(repository.orders);

  Future<CustomerOrder> addOrder({
    required String customerId,
    required String itemsSummary,
    required double totalAmount,
    required double advancePaid,
  }) {
    return repository.addOrder(
      customerId: customerId,
      itemsSummary: itemsSummary,
      totalAmount: totalAmount,
      advancePaid: advancePaid,
    );
  }

  Future<void> updateOrderStatus(String orderId, String status) =>
      repository.updateOrderStatus(orderId, status);

  // ---- Chat ----

  List<ChatMessage> get chatMessages => List.unmodifiable(repository.chatMessages);

  Future<void> sendChatMessage(String customerId, String text) =>
      repository.sendChatMessage(customerId, text);

  // ---- Reminders ----

  List<PaymentReminder> get reminders => List.unmodifiable(repository.reminders);

  List<PaymentReminder> get upcomingReminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return repository.reminders.where((r) => !r.isSettled && !r.dueDate.isBefore(today)).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<PaymentReminder> get overdueReminders {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return repository.reminders.where((r) => !r.isSettled && r.dueDate.isBefore(today)).toList()
      ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
  }

  List<PaymentReminder> getRemindersForDate(DateTime date) {
    return repository.reminders
        .where((r) => r.dueDate.year == date.year && r.dueDate.month == date.month && r.dueDate.day == date.day)
        .toList();
  }

  String getAlertOptionLabel(AlertOption option) {
    switch (option) {
      case AlertOption.sameDay:
        return '⚡ On Due Date (आज)';
      case AlertOption.oneDayBefore:
        return '🔔 1 Day Before (1 दिन पहले)';
      case AlertOption.threeDaysBefore:
        return '📅 3 Days Before (3 दिन पहले)';
    }
  }

  Future<PaymentReminder> addReminder({
    required String customerId,
    required String title,
    required double amount,
    required DateTime dueDate,
    String reminderType = 'RECOVER_UDHAR',
    AlertOption alertOption = AlertOption.sameDay,
    String note = '',
  }) {
    return repository.addReminder(
      customerId: customerId,
      title: title,
      amount: amount,
      dueDate: dueDate,
      reminderType: reminderType,
      alertOption: alertOption,
      note: note,
    );
  }

  Future<void> toggleReminderSettled(String id) => repository.toggleReminderSettled(id);

  Future<void> deleteReminder(String id) => repository.deleteReminder(id);

  // ---- Backup / restore (local JSON export; not wired to Supabase sync) ----

  String exportBackupData() {
    return _storageService.exportBackupJson(
      shopProfile: repository.shopProfile,
      customers: repository.customers,
      transactions: repository.transactions,
      orders: repository.orders,
      reminders: repository.reminders,
    );
  }

  bool importBackupData(String jsonString) {
    try {
      final data = jsonDecode(jsonString) as Map<String, dynamic>;
      unawaited(repository.restoreFromBackup(data));
      return true;
    } catch (_) {
      return false;
    }
  }

  // ---- Ledger math (Balance = Udhar - Payments - Advances + Refunds +/- Adjustments) ----

  CustomerSummary getCustomerSummary(Customer customer) {
    final custTxns = repository.transactions.where((t) => t.customerId == customer.id);
    double totalUdhar = 0;
    double totalPaid = 0;
    double totalAdvance = 0;
    double totalRefund = 0;
    double totalAdjustment = 0;

    for (final t in custTxns) {
      switch (t.type.toUpperCase()) {
        case 'UDHAAR':
          totalUdhar += t.amount;
          break;
        case 'PAYMENT':
          totalPaid += t.amount;
          break;
        case 'ADVANCE':
          totalAdvance += t.amount;
          break;
        case 'REFUND':
          totalRefund += t.amount;
          break;
        case 'ADJUSTMENT':
          totalAdjustment += t.amount;
          break;
      }
    }

    final outstanding = (totalUdhar + totalRefund + totalAdjustment) - (totalPaid + totalAdvance);

    return CustomerSummary(
      customer: customer,
      totalUdhar: totalUdhar,
      totalPaid: totalPaid,
      totalAdvance: totalAdvance,
      totalRefund: totalRefund,
      totalAdjustment: totalAdjustment,
      currentOutstanding: outstanding,
    );
  }

  OverallShopSummary getSummary() {
    final breakdowns = repository.customers.map(getCustomerSummary).toList();
    double totalUdhar = 0;
    double totalPaid = 0;
    double totalAdvance = 0;
    double currentOutstanding = 0;

    for (final b in breakdowns) {
      totalUdhar += b.totalUdhar;
      totalPaid += b.totalPaid;
      totalAdvance += b.totalAdvance;
      if (b.currentOutstanding > 0) {
        currentOutstanding += b.currentOutstanding;
      }
    }

    return OverallShopSummary(
      currentOutstandingUdhar: currentOutstanding,
      totalLoanedTillDate: totalUdhar,
      totalRepaid: totalPaid,
      advanceBalance: totalAdvance,
      customerBreakdown: breakdowns,
    );
  }

  // ---- Natural language voice parser ----

  Map<String, dynamic> parseVoiceText(String spokenText) {
    final clean = spokenText.trim();
    final lower = clean.toLowerCase();
    Customer? matchedCust;

    for (final c in repository.customers) {
      final tokens = c.name.toLowerCase().split(RegExp(r'\s+'));
      for (final tok in tokens) {
        if (tok.length > 2 && lower.contains(tok)) {
          matchedCust = c;
          break;
        }
      }
      if (matchedCust != null) break;
    }

    String type = 'UDHAAR';
    if (lower.contains('advance') || lower.contains('deposit') || lower.contains('peshgi')) {
      type = 'ADVANCE';
    } else if (lower.contains('payment') ||
        lower.contains('mila') ||
        lower.contains('diye') ||
        lower.contains('jama') ||
        lower.contains('received') ||
        lower.contains('cash') ||
        lower.contains('pay') ||
        lower.contains('chuka')) {
      type = 'PAYMENT';
    } else {
      type = 'UDHAAR';
    }

    double amount = 500.0;
    final numMatch = RegExp(r'(\d+(?:[.,]\d+)?)').firstMatch(lower.replaceAll(',', ''));
    if (numMatch != null) {
      amount = double.tryParse(numMatch.group(1) ?? '500') ?? 500.0;
      if (lower.contains('hazaar') || lower.contains('thousand') || RegExp(r'\b\d+k\b').hasMatch(lower)) {
        if (amount < 100) amount *= 1000;
      } else if (lower.contains('lakh') || lower.contains('lac')) {
        if (amount < 100) amount *= 100000;
      }
    }

    String customerName = matchedCust?.name ?? '';
    if (customerName.isEmpty) {
      final words = clean.split(RegExp(r'\s+'));
      if (words.isNotEmpty && !words.first.toLowerCase().contains(RegExp(r'\d'))) {
        customerName = words.first;
      } else {
        customerName = 'Customer';
      }
    }

    return {
      'customerName': customerName,
      'customerId': matchedCust?.id,
      'type': type,
      'amount': amount,
      'note': clean.isNotEmpty ? clean : 'Voice entry',
    };
  }
}
