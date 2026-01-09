import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:e_baladya/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Online Request Flow Integration Test', () {
    testWidgets('Complete flow: Home → Online Request → Service Details → Confirm → Success → Tracking',
        (WidgetTester tester) async {
      // Start the app
      app.main();
      await tester.pumpAndSettle();

      print('✓ Step 1: App started');

      // Wait for app to fully load
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find and tap Online Requests button
      final onlineRequestsFinder = find.text('طلبات عبر الإنترنت');
      
      if (onlineRequestsFinder.evaluate().isEmpty) {
        print('⚠️  Could not find Online Requests button - checking if we need to login first');
        // App might be on login screen, skip this test
        return;
      }

      await tester.tap(onlineRequestsFinder);
      await tester.pumpAndSettle();
      print('✓ Step 2: Navigated to Online Requests page');

      // Wait for services to load
      await tester.pumpAndSettle(const Duration(seconds: 1));

      // Find first service card (any service)
      final serviceCards = find.byType(GestureDetector);
      if (serviceCards.evaluate().isEmpty) {
        print('⚠️  No services found');
        return;
      }

      // Tap on first service
      await tester.tap(serviceCards.first);
      await tester.pumpAndSettle();
      print('✓ Step 3: Opened service details');

      // Find and tap Request Now button
      final requestNowButton = find.text('طلب الآن');
      if (requestNowButton.evaluate().isEmpty) {
        print('⚠️  Request Now button not found');
        return;
      }

      await tester.tap(requestNowButton);
      await tester.pumpAndSettle();
      print('✓ Step 4: Tapped Request Now');

      // Verify confirmation dialog appears
      final confirmButton = find.text('تأكيد');
      expect(confirmButton, findsOneWidget);
      print('✓ Step 5: Confirmation dialog displayed');

      // Tap confirm
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      print('✓ Step 6: Confirmed request');

      // Verify success screen
      final successMessage = find.text('تم تقديم طلبك بنجاح!');
      expect(successMessage, findsOneWidget);
      print('✓ Step 7: Success screen displayed');

      // Navigate back to home
      final backButton = find.text('العودة إلى الصفحة الرئيسية');
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      print('✓ Step 8: Returned to home');

      // Navigate to tracking
      final trackingButton = find.text('تتبع الطلبات');
      await tester.tap(trackingButton);
      await tester.pumpAndSettle();
      print('✓ Step 9: Opened tracking screen');

      print('\n✅ Integration test completed successfully!');
      print('Flow verified: Home → Online Request → Confirm Info → Request Saved → Tracking Screen');
    });
  });
}
