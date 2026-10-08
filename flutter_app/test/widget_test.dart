import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:udhar_khata_flutter/data/repository/ledger_repository.dart';
import 'package:udhar_khata_flutter/screens/auth_screen.dart';
import 'package:udhar_khata_flutter/state/ledger_state.dart';

import 'fakes.dart';

void main() {
  testWidgets('shows the sign-in screen when signed out', (tester) async {
    final fakeAuth = FakeAuthService();
    final state = LedgerState(
      authService: fakeAuth,
      repository: LedgerRepository(authService: fakeAuth),
    );

    await tester.pumpWidget(MaterialApp(home: AuthScreen(state: state)));
    await tester.pump();

    expect(find.textContaining('Welcome to'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Continue with Google'), findsOneWidget);
  });
}
