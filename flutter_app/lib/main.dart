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
    final isDark = _ledgerState.themeMode == AppThemeMode.darkMode;

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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: navBgColor,
          border: Border(top: BorderSide(color: navBorderColor)),
        ),
        child: SafeArea(
          child: NavigationBar(
            height: 64,
            backgroundColor: navBgColor,
            elevation: 0,
            indicatorColor: isLightMode ? const Color(0xFFFED7AA) : const Color(0xFF374151),
            selectedIndex: _selectedIndex > 4 ? 0 : _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: Color(0xFF6B7280)),
                selectedIcon: Icon(Icons.home, color: Color(0xFFDF7528)),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline, color: Color(0xFF6B7280)),
                selectedIcon: Icon(Icons.people, color: Color(0xFFDF7528)),
                label: 'Customers',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined, color: Color(0xFF6B7280)),
                selectedIcon: Icon(Icons.shopping_bag, color: Color(0xFFDF7528)),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(Icons.assessment_outlined, color: Color(0xFF6B7280)),
                selectedIcon: Icon(Icons.assessment, color: Color(0xFFDF7528)),
                label: 'Reports',
              ),
              NavigationDestination(
                icon: Icon(Icons.more_horiz, color: Color(0xFF6B7280)),
                selectedIcon: Icon(Icons.more_horiz, color: Color(0xFFDF7528)),
                label: 'More',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
