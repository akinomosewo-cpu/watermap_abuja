// Smoke test: the app boots straight into the Water Map tab showing the
// district list and can navigate to the Orders tab.

import 'package:flutter_test/flutter_test.dart';

import 'package:watermap_abuja/main.dart';

void main() {
  testWidgets('App boots to the Water Map tab and can switch to Orders', (WidgetTester tester) async {
    await tester.pumpWidget(const WaterMapApp());
    await tester.pumpAndSettle();

    expect(find.text('Water Map'), findsWidgets);
    expect(find.text('Districts'), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();

    expect(find.text('No bookings yet'), findsOneWidget);
  });
}
