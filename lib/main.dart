import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'data/services/storage_service.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization failed: $e');
  }
  
  // Initialize database
  await DatabaseHelper.instance.database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final userRepository = UserRepository();
    final serviceRepository = ServiceRepository();
    final requestRepository = RequestRepository();
    final documentRepository = DocumentRepository();
    final storageService = StorageService();
    final notificationRepository = NotificationRepository();
    final bookingRepository = BookingRepository();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LanguageCubit(),
        ),
        BlocProvider(
          create: (context) => AuthCubit(userRepository),
        ),
        BlocProvider(
          create: (context) => ServiceCubit(serviceRepository),
        ),
        BlocProvider(
          create: (context) => RequestCubit(
            requestRepository: requestRepository,
            documentRepository: documentRepository,
            serviceRepository: serviceRepository,
          ),
        ),
        BlocProvider(
          create: (context) => DocumentCubit(
            documentRepository,
            storageService,
            requestRepository,
            serviceRepository,
          ),
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
          return Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: MaterialApp(
              title: 'e-Baladya',
              debugShowCheckedModeBanner: false,
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
          );
        },
      ),
    );
  }
}