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
import '../views/screens/after_req.dart';
import '../views/screens/my_bookings_page.dart';

// Admin imports
import '../views/screens/admin/admin_login_page.dart';
import '../views/screens/admin/admin_home_page.dart';
import '../views/screens/admin/admin_notifications_page.dart';
import '../views/screens/admin/admin_track_bookings_page.dart';
import '../views/screens/admin/admin_manage_users_page.dart';
import '../views/screens/admin/admin_settings_page.dart';
import '../views/screens/admin/admin_profile_page.dart';

class AppRoutes {
  // User routes
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
  static const String afterRequest = '/after-request';
  static const String myBookings = '/my-bookings';

  // Admin routes
  static const String adminLogin = '/admin/login';
  static const String adminHome = '/admin/home';
  static const String adminNotifications = '/admin/notifications';
  static const String adminTrackBookings = '/admin/bookings';
  static const String adminManageUsers = '/admin/users';
  static const String adminSettings = '/admin/settings';
  static const String adminProfile = '/admin/profile';

  static Map<String, WidgetBuilder> get routes => {
        // User routes
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
              !args.containsKey('serviceTitle') ||
              !args.containsKey('bookingTypeId')) {
            // ADDED bookingTypeId check
            throw ArgumentError(
              'BookingCalendarScreen requires serviceId, serviceTitle, and bookingTypeId',
            );
          }

          return BookingCalendarScreen(
            serviceId: args['serviceId'] as int,
            serviceTitle: args['serviceTitle'] as String,
            bookingTypeId: args['bookingTypeId'] as int,
          );
        },

        afterRequest: (context) => const AfterReq(),
        myBookings: (context) => const MyBookingsPage(),

        // Admin routes
        adminLogin: (context) => const AdminLoginPage(),
        adminHome: (context) => const AdminHomePage(),
        adminNotifications: (context) => const AdminNotificationsPage(),
        adminTrackBookings: (context) => const AdminTrackBookingsPage(),
        adminManageUsers: (context) => const AdminManageUsersPage(),
        adminSettings: (context) => const AdminSettingsPage(),
        adminProfile: (context) => const AdminProfilePage(),
      };

  static String get initialRoute => entering;
}
