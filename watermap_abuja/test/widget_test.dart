// Smoke test: a returning (already logged-in) user is taken through the
// splash screen straight to the Water Map tab and can switch to Orders.

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

import 'package:watermap_abuja/domain/services/auth_service.dart';
import 'package:watermap_abuja/main.dart';

void main() {
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('watermap_widget_test');
    Hive.init(tempDir.path);
    await AuthService.instance.init();
    // Seed a logged-in local account so the splash screen routes straight
    // to the home screen, as it would for a returning user.
    await AuthService.instance.signUp(
      name: 'Test User',
      phone: '08000000000',
      email: 'test@example.com',
      password: 'password1',
    );
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    await tempDir.delete(recursive: true);
  });

  testWidgets('Returning user boots to the Water Map tab and can switch to Orders',
      (WidgetTester tester) async {
    await tester.pumpWidget(const WaterMapApp());
    // Advance past the splash screen's brand animation and its delayed
    // hand-off to the home screen.
    await tester.pump(const Duration(milliseconds: 950));
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();

    expect(find.text('Water Map'), findsWidgets);
    expect(find.text('Districts'), findsOneWidget);

    await tester.tap(find.text('Orders'));
    await tester.pumpAndSettle();

    expect(find.text('No bookings yet'), findsOneWidget);
  });
}
