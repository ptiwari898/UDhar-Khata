import 'package:flutter_test/flutter_test.dart';
import 'package:udhar_khata_flutter/main.dart';

void main() {
  testWidgets('renders the ledger dashboard and customer page', (tester) async {
    await tester.pumpWidget(const UdharKhataApp());
    await tester.pump();

    expect(find.text('Total Outstanding'), findsOneWidget);
    expect(find.text('Due Date Reminders'), findsOneWidget);
  });
}
