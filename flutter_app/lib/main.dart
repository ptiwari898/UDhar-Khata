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
    return MaterialApp(
      title: 'Udhar Khata',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFFAF7F2),
        primaryColor: const Color(0xFFDF7528),
        canvasColor: Colors.white,
        cardColor: Colors.white,
        dialogBackgroundColor: Colors.white,
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

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFFAF7F2),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: const BoxDecoration(
                color: Color(0xFFFFF7ED),
                border: Border(bottom: BorderSide(color: Color(0xFFE5E7EB))),
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
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E1E1E)),
                        ),
                        Text(
                          profile.ownerName,
                          style: const TextStyle(color: Color(0xFF6B7280), fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: Color(0xFFDF7528)),
              title: const Text('Home Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline, color: Color(0xFFDF7528)),
              title: const Text('Customers'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: Color(0xFFDF7528)),
              title: const Text('Record Entry'),
              selected: _selectedIndex == 5,
              onTap: () {
                setState(() => _selectedIndex = 5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: Color(0xFFDF7528)),
              title: const Text('Orders & Advances'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment_outlined, color: Color(0xFFDF7528)),
              title: const Text('Financial Reports'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_month_outlined, color: Color(0xFFDF7528)),
              title: const Text('Due Date Calendar & Reminders'),
              selected: _selectedIndex == 6,
              onTap: () {
                setState(() => _selectedIndex = 6);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: Color(0xFFDF7528)),
              title: const Text('Shop Profile & More'),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
              },
            ),
            const Divider(color: Color(0xFFE5E7EB)),
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
      body: IndexedStack(
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
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: Color(0xFFE5E7EB))),
        ),
        child: SafeArea(
          child: NavigationBar(
            height: 64,
            backgroundColor: Colors.white,
            elevation: 0,
            indicatorColor: const Color(0xFFFED7AA),
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
