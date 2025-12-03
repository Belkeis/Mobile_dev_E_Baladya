// lib/commons/app_routes.dart
import 'package:flutter/material.dart';
import '../views/screens/home_page.dart';
import '../views/screens/entering.dart';
import '../views/screens/sign_up.dart';
import '../views/screens/profile.dart';
import '../views/screens/notifications_page.dart';
import '../views/screens/online_requests.dart';
import '../views/screens/required_documents.dart';
import '../views/screens/digital_versions_page.dart';
import '../views/screens/tracking_requests.dart';
import '../views/screens/booking_page.dart';
import '../views/screens/booking_calendar_screen.dart';
import '../views/screens/passport_online_request.dart';
import '../views/screens/passport_requirement.dart';
import '../views/screens/id_card_online_request.dart';
import '../views/screens/id_card_requirement.dart';
import '../views/screens/after_req.dart';
import '../views/screens/service_details_screen.dart';
import '../views/screens/service_requirements_screen.dart';
import '../views/screens/my_bookings_page.dart';

class AppRoutes {
  static const String entering = '/entering';
  static const String home = '/home';
  static const String signUp = '/sign_up';
  static const String profile = '/profile';
  static const String notifications = '/notifications';
  static const String onlineRequests = '/online-requests';
  static const String requiredDocuments = '/required-documents';
  static const String digitalVersions = '/digital-versions';
  static const String tracking = '/tracking';
  static const String booking = '/booking';
  static const String bookingCalendar = '/booking-calendar';
  static const String passportOnlineRequest = '/passport-online-request';
  static const String passportRequirement = '/passport-requirement';
  static const String idCardOnlineRequest = '/id-card-online-request';
  static const String idCardRequirement = '/id-card-requirement';
  static const String afterRequest = '/after-request';
  static const String myBookings = '/my-bookings';

  static Map<String, WidgetBuilder> get routes => {
        entering: (context) => const Entering(),
        home: (context) => const HomePage(),
        signUp: (context) => const SignUpPage(),
        profile: (context) => const ProfilePage(),
        notifications: (context) => const NotificationsPage(),
        onlineRequests: (context) => const MyOnlineRequestsPage(),
        requiredDocuments: (context) => const MyRequiredDocumentsPage(),
        digitalVersions: (context) => const DigitalVersionsPage(),
        tracking: (context) => const RequestTrackingScreen(),
        booking: (context) => const BookingPage(),
        // For BookingCalendarScreen, extract arguments from RouteSettings
        bookingCalendar: (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          if (args == null ||
              !args.containsKey('serviceId') ||
              !args.containsKey('serviceTitle')) {
            throw ArgumentError(
                'BookingCalendarScreen requires serviceId and serviceTitle');
          }

          return BookingCalendarScreen(
            serviceId: args['serviceId'] as int,
            serviceTitle: args['serviceTitle'] as String,
          );
        },
        passportOnlineRequest: (context) => const OnlineRequestPassport(),
        passportRequirement: (context) => const RequiredDocumentsPage(),
        idCardOnlineRequest: (context) => const IdRequest(),
        idCardRequirement: (context) => const IdRequirements(),
        afterRequest: (context) => const AfterReq(),
        myBookings: (context) => const MyBookingsPage(),
      };

  static String get initialRoute => entering;
}
