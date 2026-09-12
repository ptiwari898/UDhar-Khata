import 'package:flutter_test/flutter_test.dart';

import 'package:udhar_khata_flutter/main.dart';

void main() {
  testWidgets('renders the ledger dashboard and customer page', (tester) async {
    await tester.pumpWidget(const UdharKhataApp());

    expect(find.text('Shivam Kirana Store'), findsOneWidget);
    expect(find.text('TOTAL TO COLLECT'), findsOneWidget);

    await tester.tap(find.text('Customers'));
    await tester.pumpAndSettle();

    expect(find.text('Outstanding balances and follow-ups'), findsOneWidget);
    expect(find.text('Ramesh General Store'), findsOneWidget);
  });
}
