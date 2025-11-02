import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/tracking_requests.dart';
import 'screens/online_request_page.dart';
import 'screens/required_doc_passport.dart';
import 'screens/MyRequiredDocumentsPage.dart';
import 'screens/booking_page.dart';
import 'screens/digital_versions_page.dart';
import 'screens/MyOnlineRequestsPage.dart';
import 'screens/booking_calendar_screen.dart';
import 'screens/entering.dart';
import 'screens/sign_up.dart';
import 'screens/after_req.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Tracking App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF2563EB),
        scaffoldBackgroundColor: const Color(0xFFF9FAFB),
        fontFamily: 'Cairo',
      ),
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/tracking': (context) => const RequestTrackingScreen(),
        '/required-documents-passport': (context) => const RequiredDocumentsPassportPage(),
        '/required-documents': (context) =>
            const MyRequiredDocumentsPage(),
        '/booking': (context) => const BookingPage(),
        '/digital-versions': (context) => const DigitalVersionsPage(),
        '/online-requests': (context) => const MyOnlineRequestsPage(),
        '/boocking-cal':(context) =>const BookingCalendarScreen(),
        '/entering' :(context) =>const Entering(),
        '/sign_up' :(context) =>const SignUpPage(),
        '/after_req' :(context) =>const AfterReq(),
        
      },
    );
  }
}
