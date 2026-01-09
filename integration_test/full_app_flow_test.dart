import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:e_baladya/main.dart' as app;
import 'package:e_baladya/views/widgets/custom_app_bar.dart';

import 'package:e_baladya/data/repo/user_repository.dart';
import 'package:e_baladya/data/models/user_model.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // Create test user function
  Future<void> seedUser() async {
     final userRepo = UserRepository();
     // Check if user exists first to avoid duplicates or errors
     final existing = await userRepo.getUserByEmail('loubnabensaoula@gmail.com');
     if (existing == null) {
       final user = UserModel(
         fullName: 'Loubna Test',
         email: 'loubnabensaoula@gmail.com',
         phone: '0612345678', // Valid phone format
         nationalId: '123456789012345678', // Valid 18-digit ID
         password: '000000',
         createdAt: DateTime.now().toIso8601String(),
       );
       await userRepo.createUser(user);
       print('Test User Seeded Successfully');
     } else {
       print('Test User already exists');
     }
  }

  group('Online Request Flow Integration Test', () {
    testWidgets('Complete flow: Login (if needed) -> Online Request -> Tracking -> Digital Documents',
        (WidgetTester tester) async {
      // Start the app and wait for initialization (Skip FCM to avoid dialogs)
      await app.main(isTest: true);
      
      // Seed Database with User
      await seedUser();

      await tester.pumpAndSettle();

      print('Step 1: App started');

      // Wait for app initialization (Firebase, SharedPreferences, etc.)
      await tester.pumpAndSettle(const Duration(seconds: 6));

      // Check if we are in French (Entering Page shows 'AR' to switch to Arabic)
      final arToggle = find.text('AR');
      if (arToggle.evaluate().isNotEmpty) {
         print('App seems to be in French. Switching to Arabic...');
         await tester.tap(arToggle);
         await tester.pumpAndSettle();
      }

      // Check current state: Home Page or Login Page
      // We look for the "Online Requests" button which is present on the Home Page.
      var onlineRequestsFinder = find.text('طلبات عبر الإنترنت');
      
      // If Home Page is not immediately found, we check if we need to log in.
      if (onlineRequestsFinder.evaluate().isEmpty) {
        print('Home page not found. Checking for Login screen...');
        
        // Check for "Citizen Login" button on the initial Entering Page
        // Note: The app defaults to Arabic, so we look for Arabic text.
        final citizenLoginBtn = find.text('تسجيل الدخول كمواطن');
        
        if (citizenLoginBtn.evaluate().isNotEmpty) {
          print('Found Entering Page. Tapping Citizen Login...');
          await tester.tap(citizenLoginBtn);
          await tester.pumpAndSettle();
        } else {
           // Maybe we are still loading? Or strict mismatch?
           // Let's check for 'Connexion Citoyen' just in case language switching failed
           final frLogin = find.text('Connexion Citoyen');
           if (frLogin.evaluate().isNotEmpty) {
               print('Found Entering Page (French). Tapping Connexion Citoyen...');
               await tester.tap(frLogin);
               await tester.pumpAndSettle();
               // Note: If we enter here, subsequent finds (arabic) will fail unless we switch lang inside app?
               // But we only proceed if we login.
           }
        }

        // After tapping Citizen Login, we expect the SignUp/Login page.
        // We look for the Email field by its hint text.
        // Try Arabic first
        var emailField = find.widgetWithText(TextFormField, 'أدخل بريدك الإلكتروني');
        
        if (emailField.evaluate().isNotEmpty) {
           print('Found Login Form (Arabic). Entering credentials...');
        } else {
           // Try French
           final emailFieldFr = find.widgetWithText(TextFormField, 'Entrez votre e-mail');
           if (emailFieldFr.evaluate().isNotEmpty) {
               print('Found Login Form (French). Entering credentials...');
               emailField = emailFieldFr;
           }
        }
        
        if (emailField.evaluate().isNotEmpty) {
           
           // Enter Email: loubna@gmail.com
           await tester.enterText(emailField, 'loubnabensaoula@gmail.com');
           await tester.pump();
           
           // Enter Password: 77777777
           var passField = find.widgetWithText(TextFormField, 'أدخل كلمة المرور');
           if (passField.evaluate().isEmpty) {
               passField = find.widgetWithText(TextFormField, 'Entrez votre mot de passe');
           }
           await tester.enterText(passField, '000000');
           await tester.pump();
           
           // Dismiss keyboard
           await tester.testTextInput.receiveAction(TextInputAction.done);
           await tester.pump();

           // Tap the Login button
           var loginBtn = find.widgetWithText(ElevatedButton, 'تسجيل الدخول');
           if (loginBtn.evaluate().isEmpty) {
               loginBtn = find.widgetWithText(ElevatedButton, 'Se Connecter');
           }
           await tester.tap(loginBtn);
           await tester.pumpAndSettle();
           
           // Wait for authentication to complete
           await tester.pumpAndSettle(const Duration(seconds: 2));
           
           // Check for error message
           if (find.textContaining('بيانات الدخول غير صحيحة').evaluate().isNotEmpty || 
               find.textContaining('Identifiants invalides').evaluate().isNotEmpty) {
                fail('Authentication Failed: Invalid credentials provided.');
           }

           // Wait remaining time for Home Page to load
           await tester.pumpAndSettle(const Duration(seconds: 6));
           
           // Re-verify that we are now on the Home Page
           onlineRequestsFinder = find.text('طلبات عبر الإنترنت');
           if (onlineRequestsFinder.evaluate().isEmpty) {
               onlineRequestsFinder = find.text('Demandes en Ligne');
           }
           
           if (onlineRequestsFinder.evaluate().isNotEmpty) {
             print('Login Successful. Navigated to Home.');
           } else {
             debugDumpApp();
             fail('Login failed or did not navigate to Home Page. Check logs/screenshot.');
           }
        } else {
           // If we are not on Home and didn't find the login fields, checking again
           if (onlineRequestsFinder.evaluate().isEmpty) {
              await tester.pumpAndSettle(const Duration(seconds: 3));
              onlineRequestsFinder = find.text('طلبات عبر الإنترنت');
              if (onlineRequestsFinder.evaluate().isEmpty) {
                  onlineRequestsFinder = find.text('Demandes en Ligne');
              }
           }
        }
      }

      if (onlineRequestsFinder.evaluate().isEmpty) {
        debugDumpApp();
        print('CRITICAL FAILURE: Neither Home Page nor Login Page found.');
        fail('Could not reach Home Page to start the test. Ensure the app starts in Arabic or is logged in.');
      }

      // --- ONLINE REQUEST FLOW ---
      
      // --- ONLINE REQUEST FLOW ---
      
      // Tap "Online Requests"
      await tester.tap(onlineRequestsFinder);
      await tester.pumpAndSettle();
      print('Step 2: Navigated to Online Requests page');

      // Wait for service list to load
      await tester.pumpAndSettle(const Duration(seconds: 4));

      // Attempt to find a service card to tap using Key or Type
      // We look for any key starting with 'service_card_'
      // Since we don't know the exact ID, we find by Type and filter, OR simply find by Type Container with GestureDetector child?
      // Actually, we added Keys 'service_card_ID'. IDs are usually 1, 2, 3...
      // Let's try to find Key('service_card_1') or use a Finder that matches the Key pattern.
      // Easiest reliable way: Find the FIRST GestureDetector that has a Key starting with 'service_card_'.
      // But Matcher for Key string is hard.
      // Simple fallback: Find by Type GestureDetector inside the Column/SingleChildScrollView
      
      // Attempt to find a service card to tap using Key, Text, or Type
      final scrollable = find.byType(SingleChildScrollView);
      Finder? serviceTarget;
      
      // Strategy 1: Find by Key (e.g., service_card_1)
      final keyFinder = find.byKey(const Key('service_card_1'));
      if (keyFinder.evaluate().isNotEmpty) {
         print('Found Service Card by Key');
         serviceTarget = keyFinder;
      } 
      // Strategy 2: Find by Text (e.g., "Certificate")
      else if (find.textContaining('شهادة').evaluate().isNotEmpty) {
          print('Found Service Card by Text "شهادة"');
          serviceTarget = find.textContaining('شهادة').first;
      }
      // Strategy 3: Find first GestureDetector inside ScrollView
      else {
         final detectors = find.descendant(of: scrollable, matching: find.byType(GestureDetector));
         if (detectors.evaluate().isNotEmpty) {
            print('Found Service Card by Type GestureDetector');
            serviceTarget = detectors.first;
         }
      }

      if (serviceTarget != null) {
         await tester.ensureVisible(serviceTarget);
         await tester.tap(serviceTarget);
      } else {
         debugDumpApp(); // Print app tree to console if failing
         fail('No service cards found in Online Requests page.');
      }
      
      await tester.pumpAndSettle();
      print('Step 3: Opened service details');

      // Find and tap "Request Now" button
      final requestNowButton = find.text('طلب الآن');
      if (requestNowButton.evaluate().isEmpty) {
        fail('Request Now button not found.');
      }

      await tester.tap(requestNowButton);
      await tester.pumpAndSettle();
      print('Step 4: Tapped Request Now');

      // Verify "Confirm" dialog appears
      final confirmButton = find.text('تأكيد');
      expect(confirmButton, findsOneWidget);
      print('Step 5: Confirmation dialog displayed');

      // Tap Confirm
      await tester.tap(confirmButton);
      await tester.pumpAndSettle();
      print('Step 6: Confirmed request');

      // Verify Success Message
      final successMessage = find.text('تم تقديم طلبك بنجاح!');
      expect(successMessage, findsOneWidget);
      print('Step 7: Success screen displayed');

      // Navigate back to Home
      final backButton = find.text('العودة إلى الصفحة الرئيسية');
      await tester.tap(backButton);
      await tester.pumpAndSettle();
      print('Step 8: Returned to home');

      // Navigate to Tracking
      final trackingButton = find.text('تتبع الطلبات');
      await tester.scrollUntilVisible(trackingButton, 100.0, scrollable: find.byType(Scrollable).first);
      await tester.tap(trackingButton);
      await tester.pumpAndSettle();
      print('Step 9: Opened tracking screen');
      
      // --- DIGITAL DOCUMENTS FLOW ---
      
      // Navigate back to Home from Tracking screen
      print('Step 10: Returning to Home from Tracking...');
      
      // Use CustomAppBar Arrow with logic: Key -> Asset -> Type
      Finder? backBtnTarget;
      
      final backKey = find.byKey(const Key('app_bar_back_button'));
      if (backKey.evaluate().isNotEmpty) {
         backBtnTarget = backKey;
      } else {
         print('Warning: Custom Back Button Key not found. Trying fallback...');
         // Find CustomAppBar first
         final customAppBar = find.byType(CustomAppBar);
         if (customAppBar.evaluate().isNotEmpty) {
             // Find last InkWell (usually the right-most or last defined in stack/row)
             // In CustomAppBar code: Arrow is the last child in the main Row's children list (Right Side Row).
             final inkWells = find.descendant(of: customAppBar, matching: find.byType(InkWell));
             if (inkWells.evaluate().isNotEmpty) {
                backBtnTarget = inkWells.last;
             }
         }
      }

      if (backBtnTarget != null) {
         await tester.tap(backBtnTarget);
      } else {
         print('Critical Warning: Custom Back Button not found via finders. Attempting tester.pageBack()...');
         await tester.pageBack();
      }

      await tester.pumpAndSettle();
      
      // Verify we are back on Home by finding the "Digital Documents" button
      final digitalDocsBtn = find.text('الوثائق الرقمية');
      
      // Ensure visibility before tapping
      await tester.scrollUntilVisible(digitalDocsBtn, 100.0, scrollable: find.byType(Scrollable).first);
      expect(digitalDocsBtn, findsOneWidget); 
      
      print('Step 11: Navigating to Digital Documents...');
      await tester.tap(digitalDocsBtn);
      await tester.pumpAndSettle();
      
      // Wait for documents to load
      await tester.pumpAndSettle(const Duration(seconds: 4));
      
      print('Step 12: Verifying Digital Documents Page...');
      // Verify Page Title
      expect(find.text('الوثائق الرقمية'), findsOneWidget);
      
      // Check for documents or empty state
      final noDocs = find.text('لا توجد وثائق رقمية');
      if (noDocs.evaluate().isNotEmpty) {
        print('Info: No digital documents found (Empty State verified)');
      } else {
        // If documents exist, tap the first one to simulate View/Download
        print('Documents found. Attempting interaction...');
        
        Finder? docTarget;
        final keyDoc = find.byKey(const Key('list_item_0'));
        
        if (keyDoc.evaluate().isNotEmpty) {
             docTarget = keyDoc;
        } else {
             // Fallback to ListTile type
             final listTiles = find.byType(ListTile);
             if (listTiles.evaluate().isNotEmpty) {
                docTarget = listTiles.first;
             }
        }
        
        if (docTarget != null) {
           await tester.scrollUntilVisible(docTarget, 100.0, scrollable: find.byType(Scrollable).first);
           await tester.tap(docTarget);
           await tester.pumpAndSettle();
           print('Tapped document (Simulated View/Download)');
        } else {
           print('Warning: Documents loop entered but no ListTile found!?');
        }
      }

      print('Integration test completed successfully.');
      print('Verified Flow: Login -> Home -> Online Request -> Success -> Tracking -> Home -> Digital Documents');
    });
  });
}
