import 'package:flutter/material.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'env.dart';
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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(url: supabaseUrl, publishableKey: supabaseAnonKey);
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
    final state = _ledgerState;
    final theme = AppTheme.build(
      state.colorScheme,
      state.activePalette,
      glassEnabled: state.glassEffectEnabled,
      glassBlurSigma: state.glassBlurSigma,
    );

    return MaterialApp(
      title: 'Udhar Khata',
      debugShowCheckedModeBanner: false,
      // Android's stretch overscroll renders the list through an image filter,
      // which blanks out the glass backdrops (cards go empty or black). A
      // bounce just moves the content, which glass handles like any scroll.
      scrollBehavior: const MaterialScrollBehavior().copyWith(
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        overscroll: false,
      ),
      themeMode: state.isDarkTheme ? ThemeMode.dark : ThemeMode.light,
      theme: theme,
      darkTheme: theme,
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

    final scheme = Theme.of(context).colorScheme;
    final navBorderColor = scheme.outlineVariant;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: scheme.surface,
      drawer: Drawer(
        backgroundColor: scheme.surfaceContainerLow,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
              decoration: BoxDecoration(
                color: scheme.primaryContainer,
                border: Border(bottom: BorderSide(color: navBorderColor)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: scheme.primary.withValues(alpha: 0.15),
                      border: Border.all(color: scheme.primary, width: 1.5),
                    ),
                    child: Center(
                      child: Icon(Icons.menu_book_rounded, size: 28, color: scheme.primary),
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
                            color: scheme.onPrimaryContainer,
                          ),
                        ),
                        Text(
                          profile.ownerName,
                          style: TextStyle(
                            color: scheme.onPrimaryContainer.withValues(alpha: 0.7),
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
              leading: Icon(Icons.home_outlined, color: scheme.primary),
              title: Text('Home Dashboard', style: TextStyle(color: scheme.onSurface)),
              selected: _selectedIndex == 0,
              onTap: () {
                setState(() => _selectedIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.people_outline, color: scheme.primary),
              title: Text('Customers', style: TextStyle(color: scheme.onSurface)),
              selected: _selectedIndex == 1,
              onTap: () {
                setState(() => _selectedIndex = 1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.add_circle_outline, color: scheme.primary),
              title: Text('Record Entry', style: TextStyle(color: scheme.onSurface)),
              selected: _selectedIndex == 5,
              onTap: () {
                setState(() => _selectedIndex = 5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.shopping_bag_outlined, color: scheme.primary),
              title: Text('Orders & Advances', style: TextStyle(color: scheme.onSurface)),
              selected: _selectedIndex == 2,
              onTap: () {
                setState(() => _selectedIndex = 2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.assessment_outlined, color: scheme.primary),
              title: Text('Financial Reports', style: TextStyle(color: scheme.onSurface)),
              selected: _selectedIndex == 3,
              onTap: () {
                setState(() => _selectedIndex = 3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_month_outlined, color: scheme.primary),
              title: Text('Due Date Calendar & Reminders', style: TextStyle(color: scheme.onSurface)),
              selected: _selectedIndex == 6,
              onTap: () {
                setState(() => _selectedIndex = 6);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_outline, color: scheme.primary),
              title: Text('Shop Profile & Theme', style: TextStyle(color: scheme.onSurface)),
              selected: _selectedIndex == 4,
              onTap: () {
                setState(() => _selectedIndex = 4);
                Navigator.pop(context);
              },
            ),
            Divider(color: navBorderColor),
            ListTile(
              leading: Icon(Icons.logout, color: scheme.error),
              title: Text('Sign Out Account', style: TextStyle(color: scheme.error, fontWeight: FontWeight.bold)),
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
        // With extendBody, Scaffold only adds the nav bar height to
        // `padding`; nested screens' FABs position from `viewPadding`, so
        // mirror it there to keep them above the floating glass bar.
        child: Builder(
          builder: (context) {
            final mq = MediaQuery.of(context);
            return MediaQuery(
              data: mq.copyWith(
                viewPadding: mq.viewPadding.copyWith(bottom: mq.padding.bottom),
              ),
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
            );
          },
        ),
      ),
      extendBody: true,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          child: _buildNavBar(context, palette),
        ),
      ),
    );
  }

  static const double _navBarHeight = 60;

  Widget _buildNavBar(BuildContext context, ThemePalette palette) {
    final glass = GlassTheme.of(context);
    final items = Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNavItem(0, Icons.home_rounded, Icons.home_outlined, 'Home', palette),
        _buildNavItem(1, Icons.people_rounded, Icons.people_outline_rounded, 'Customers', palette),
        _buildNavItem(2, Icons.shopping_bag_rounded, Icons.shopping_bag_outlined, 'Orders', palette),
        _buildNavItem(3, Icons.assessment_rounded, Icons.assessment_outlined, 'Reports', palette),
        _buildNavItem(4, Icons.grid_view_rounded, Icons.grid_view_outlined, 'More', palette),
      ],
    );
    final content = DecoratedBox(
      decoration: ShapeDecoration(
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(_navBarHeight / 2),
          side: BorderSide(color: glass.border),
        ),
      ),
      child: SizedBox(
        height: _navBarHeight,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: items,
        ),
      ),
    );

    if (!glass.enabled) {
      return DecoratedBox(
        decoration: ShapeDecoration(
          color: glass.solidSurface,
          shape: RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(_navBarHeight / 2)),
          shadows: [BoxShadow(color: palette.cardShadow, blurRadius: 24, offset: const Offset(0, 10))],
        ),
        child: content,
      );
    }

    return LiquidGlass.withOwnLayer(
      settings: glass.pillSettings(height: _navBarHeight),
      shape: const LiquidRoundedSuperellipse(borderRadius: _navBarHeight / 2),
      child: content,
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
