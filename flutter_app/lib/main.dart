import 'package:flutter/material.dart';
import 'screens/auth_screen.dart';
import 'screens/customers_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/record_entry_screen.dart';
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
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.backgroundSlate,
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorScheme: const ColorScheme.dark(
          primary: AppColors.primaryBlue,
          surface: AppColors.cardSurface,
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
      extendBody: true,
      drawer: Drawer(
        backgroundColor: AppColors.backgroundSlate,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withValues(alpha: 0.15),
                border: const Border(bottom: BorderSide(color: Colors.white12)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white30, width: 1.5),
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          profile.shopName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.textPrimary),
                        ),
                        Text(
                          profile.ownerName,
                          style: const TextStyle(color: AppColors.textSecondary, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined, color: AppColors.primaryBlue),
              title: const Text('Home Dashboard'),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.people_outline, color: AppColors.primaryBlue),
              title: const Text('Customers'),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.add_circle_outline, color: AppColors.primaryBlue),
              title: const Text('Record Entry'),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag_outlined, color: AppColors.primaryBlue),
              title: const Text('Orders & Advances'),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.assessment_outlined, color: AppColors.primaryBlue),
              title: const Text('Financial Reports'),
              selected: _selectedIndex == 5,
              onTap: () {
                setState(() => _selectedIndex = 5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline, color: AppColors.primaryBlue),
              title: const Text('Shop Profile'),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            const Divider(color: Colors.white12),
            ListTile(
              leading: const Icon(Icons.logout, color: AppColors.redUdhar),
              title: const Text('Sign Out Account', style: TextStyle(color: AppColors.redUdhar, fontWeight: FontWeight.bold)),
              onTap: () {
                Navigator.pop(context);
                state.logout();
              },
            ),
          ],
        ),
      ),
      body: AtmosphericBackdrop(
        child: SafeArea(
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
              ProfileScreen(state: state),
              RecordEntryScreen(
                state: state,
                onBack: () => setState(() => _selectedIndex = 0),
              ),
              ReportsScreen(state: state),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
        child: GlassCard(
          radius: 24,
          padding: EdgeInsets.zero,
          child: NavigationBar(
            height: 64,
            backgroundColor: Colors.transparent,
            indicatorColor: AppColors.primaryBlueBg,
            selectedIndex: _selectedIndex > 3 ? 0 : _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: AppColors.textSecondary),
                selectedIcon: Icon(Icons.home, color: AppColors.primaryBlue),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.people_outline, color: AppColors.textSecondary),
                selectedIcon: Icon(Icons.people, color: AppColors.primaryBlue),
                label: 'Customers',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_bag_outlined, color: AppColors.textSecondary),
                selectedIcon: Icon(Icons.shopping_bag, color: AppColors.primaryBlue),
                label: 'Orders',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: AppColors.textSecondary),
                selectedIcon: Icon(Icons.person, color: AppColors.primaryBlue),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
