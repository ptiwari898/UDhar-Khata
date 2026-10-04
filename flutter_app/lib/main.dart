import 'dart:ui';
import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/customers_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/record_entry_screen.dart';
import 'screens/reminders_calendar_screen.dart';
import 'screens/reports_screen.dart';
import 'state/ledger_state.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const UdharKhataApp());
}

class UdharKhataApp extends StatefulWidget {
  const UdharKhataApp({super.key});

  @override
  State<UdharKhataApp> createState() => _UdharKhataAppState();
}

class _UdharKhataAppState extends State<UdharKhataApp> {
  final LedgerState _ledgerState = LedgerState();

  @override
  void initState() {
    super.initState();
    _ledgerState.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = _ledgerState.isDarkTheme;

    return MaterialApp(
      title: 'Udhar Khata',
      debugShowCheckedModeBanner: false,
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        primaryColor: const Color(0xFFDF7528),
        canvasColor: Colors.white,
        cardColor: Colors.white,
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFDF7528),
          surface: Colors.white,
          onSurface: Color(0xFF1E1E1E),
        ),
        popupMenuTheme: const PopupMenuThemeData(
          color: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        dropdownMenuTheme: const DropdownMenuThemeData(
          menuStyle: MenuStyle(
            backgroundColor: WidgetStatePropertyAll(Colors.white),
            surfaceTintColor: WidgetStatePropertyAll(Colors.transparent),
          ),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color(0xD8FFF5EB)),
          hintStyle: TextStyle(color: Color(0xAAFFF0DF)),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0x40FFFFFF))),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Color(0xFFFFB347))),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF11141A),
        primaryColor: const Color(0xFFDF7528),
        canvasColor: const Color(0xFF1E2430),
        cardColor: const Color(0xFF1E2430),
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFDF7528),
          surface: Color(0xFF1E2430),
          onSurface: Colors.white,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF1E2430),
          surfaceTintColor: Colors.transparent,
        ),
      ),
      home: _ledgerState.currentUser == null
          ? AuthScreen(state: _ledgerState)
          : LedgerMainScreen(state: _ledgerState),
    );
  }
}

class LedgerMainScreen extends StatefulWidget {
  final LedgerState state;
  const LedgerMainScreen({super.key, required this.state});

  @override
  State<LedgerMainScreen> createState() => _LedgerMainScreenState();
}

class _LedgerMainScreenState extends State<LedgerMainScreen> {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final profile = state.shopProfile;
    final palette = state.activePalette;

    final isLightMode = state.themeMode == AppThemeMode.lightMode;
    final navBgColor = isLightMode ? Colors.white : const Color(0xFF11141A);
    final navBorderColor = isLightMode ? const Color(0xFFE5E7EB) : const Color(0xFF1F2937);

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: isLightMode ? const Color(0xFFFAF7F2) : const Color(0xFF11141A),
      drawer: Drawer(
        backgroundColor: isLightMode ? Colors.white : const Color(0xFF1E2430),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: isLightMode ? const Color(0xFFFFF7ED) : const Color(0xFF181822),
                border: Border(bottom: BorderSide(color: navBorderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFDF7528).withValues(alpha: 0.15),
                      border: Border.all(color: const Color(0xFFDF7528), width: 1.5),
                    ),
                    child: const Center(
                      child: Icon(Icons.menu_book_rounded, size: 28, color: Color(0xFFDF7528)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.shopName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white,
                          ),
                        ),
                        Text(
                          profile.ownerName,
                          style: TextStyle(
                            color: isLightMode ? const Color(0xFF6B7280) : Colors.white60,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Color(0xFFDF7528)),
              title: Text('Home Dashboard', style: TextStyle(color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white)),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline, color: Color(0xFFDF7528)),
              title: Text('Customers', style: TextStyle(color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white)),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Color(0xFFDF7528)),
              title: Text('Record Entry', style: TextStyle(color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white)),
              selected: _selectedIndex == 5,
              onTap: () {
                setState(() => _selectedIndex = 5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFDF7528)),
              title: Text('Orders & Advances', style: TextStyle(color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white)),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment_outlined, color: Color(0xFFDF7528)),
              title: Text('Financial Reports', style: TextStyle(color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white)),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined, color: Color(0xFFDF7528)),
              title: Text('Due Date Calendar & Reminders', style: TextStyle(color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white)),
              selected: _selectedIndex == 6,
              onTap: () {
                setState(() => _selectedIndex = 6);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Color(0xFFDF7528)),
              title: Text('Shop Profile & Theme', style: TextStyle(color: isLightMode ? const Color(0xFF1E1E1E) : Colors.white)),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
              },
            ),
            Divider(color: navBorderColor),
            ListTile(
              leading: const Icon(Icons.logout, color: Color(0xFFDC2626)),
              title: const Text('Sign Out Account', style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                state.logout();
              },
            ),
          ],
        ),
      ),
      body: AtmosphericBackdrop(
        palette: palette,
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            DashboardScreen(
              state: state,
              onOpenDrawer: () => _scaffoldKey.currentState?.openDrawer(),
              onNavigateTab: (idx) => setState(() => _selectedIndex = idx),
            ),
            CustomersScreen(state: state),
            OrdersScreen(state: state),
            ReportsScreen(state: state),
            ProfileScreen(state: state),
            RecordEntryScreen(
              state: state,
              onBack: () => setState(() => _selectedIndex = 0),
            ),
            RemindersCalendarScreen(
              state: state,
              onBack: () => setState(() => _selectedIndex = 0),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  color: palette.glassSurface,
                  borderRadius: BorderRadius.circular(32),
                  border: Border.all(
                    color: palette.glassBorder,
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: palette.cardShadow,
                      blurRadius: 24,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home', palette),
                    _buildNavItem(1, Icons.people_rounded, Icons.people_outline_rounded, 'Customers', palette),
                    _buildNavItem(2, Icons.shopping_bag_rounded, Icons.shopping_bag_outlined, 'Orders', palette),
                    _buildNavItem(3, Icons.assessment_rounded, Icons.assessment_outlined, 'Reports', palette),
                    _buildNavItem(4, Icons.grid_view_rounded, Icons.grid_view_outlined, 'More', palette),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData activeIcon, IconData inactiveIcon, String label, ThemePalette palette) {
    final isSelected = (_selectedIndex > 4 ? 0 : _selectedIndex) == index;
    final activeColor = palette.primaryAccent;
    final inactiveColor = palette.textMuted;

    return GestureDetector(
      onTap: () => setState(() => _selectedIndex = index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor.withValues(alpha: 0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: isSelected ? Border.all(color: activeColor.withValues(alpha: 0.50), width: 1.2) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: AnimatedRotation(
                turns: isSelected ? 0.02 : 0.0,
                duration: const Duration(milliseconds: 250),
                child: Icon(
                  isSelected ? activeIcon : inactiveIcon,
                  size: 22,
                  color: isSelected ? activeColor : inactiveColor,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 6),
              AnimatedOpacity(
                opacity: isSelected ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: activeColor,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
