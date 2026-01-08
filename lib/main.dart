import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'commons/app_routes.dart';
import 'data/database/database_helper.dart';
import 'data/repo/user_repository.dart';
import 'data/repo/service_repository.dart';
import 'data/repo/request_repository.dart';
import 'data/repo/document_repository.dart';
import 'data/repo/notification_repository.dart';
import 'data/repo/booking_repository.dart';
import 'logic/cubit/auth_cubit.dart';
import 'logic/cubit/service_cubit.dart';
import 'logic/cubit/request_cubit.dart';
import 'logic/cubit/document_cubit.dart';
import 'logic/cubit/notification_cubit.dart';
import 'logic/cubit/booking_cubit.dart';
import 'logic/cubit/language_cubit.dart';
import 'i18n/app_localizations.dart';
import 'utils/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize database
  await DatabaseHelper.instance.database;

  // Initialize FCM service
  final notificationRepository = NotificationRepository();
  await FCMService().initialize(notificationRepository);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    _setupNotificationListener();
  }

  void _setupNotificationListener() {
    FCMService().onNotificationTap = (notificationType, userId) {
      if (_navigatorKey.currentContext != null) {
        final notificationCubit =
            _navigatorKey.currentContext!.read<NotificationCubit>();
        notificationCubit.handleNotificationTap(notificationType, userId);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final userRepository = UserRepository();
    final serviceRepository = ServiceRepository();
    final requestRepository = RequestRepository();
    final documentRepository = DocumentRepository();
    final notificationRepository = NotificationRepository();
    final bookingRepository = BookingRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(
          create: (context) {
            final authCubit = AuthCubit(userRepository);
            // Check auth status when app starts
            authCubit.checkAuthStatus();
            return authCubit;
          },
        ),
        BlocProvider(
          create: (context) => ServiceCubit(serviceRepository),
        ),
        BlocProvider(
          create: (context) => RequestCubit(requestRepository),
        ),
        BlocProvider(
          create: (context) => DocumentCubit(documentRepository),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(notificationRepository),
        ),
        BlocProvider(
          create: (context) => BookingCubit(bookingRepository),
        ),
      ],
      child: BlocBuilder<LanguageCubit, LanguageState>(
        builder: (context, languageState) {
          final isArabic = languageState.locale.languageCode == 'ar';
          return BlocListener<NotificationCubit, NotificationState>(
            listener: (context, state) {
              if (state is NotificationNavigate) {
                _navigatorKey.currentState?.pushNamed(
                  state.route,
                  arguments: state.arguments,
                );
              }
            },
            child: Directionality(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              child: MaterialApp(
                title: 'e-Baladya',
                debugShowCheckedModeBanner: false,
                navigatorKey: _navigatorKey,
                locale: languageState.locale,
                supportedLocales: const [
                  Locale('ar', ''),
                  Locale('fr', ''),
                ],
                localizationsDelegates: const [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                theme: ThemeData(
                  primaryColor: const Color(0xFF2563EB),
                  scaffoldBackgroundColor: const Color(0xFFF9FAFB),
                  fontFamily: 'Cairo',
                ),
                initialRoute: AppRoutes.initialRoute,
                routes: AppRoutes.routes,
              ),
            ),
          );
        },
      ),
    );
  }
}
