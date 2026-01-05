# Firebase Cloud Messaging (FCM) - Complete Implementation Guide for E-Baladya

## 📋 Table of Contents
1. [Prerequisites](#prerequisites)
2. [Firebase Project Setup](#firebase-project-setup)
3. [Android Configuration](#android-configuration)
4. [iOS Configuration](#ios-configuration)
5. [Flutter Implementation](#flutter-implementation)
6. [Testing Notifications](#testing-notifications)
7. [Advanced Features](#advanced-features)

---

## 🔧 Prerequisites

### Required Tools
- Firebase Console account (https://console.firebase.google.com)
- Flutter SDK installed
- Android Studio (for Android)
- Xcode (for iOS, Mac only)
- Google account

### Files You Need to Send Me
❌ **No files needed from your side yet!** 

I'll guide you through creating all necessary files. However, once you set up Firebase:
- `google-services.json` (Android) - Download from Firebase Console
- `GoogleService-Info.plist` (iOS) - Download from Firebase Console

---

## 🔥 Step 1: Firebase Project Setup

### 1.1 Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Click **"Add project"**
3. Enter project name: **"E-Baladya"**
4. Enable/Disable Google Analytics (optional but recommended)
5. Click **"Create project"**

### 1.2 Add Android App

1. In Firebase Console, click the **Android icon** (⚙️)
2. Enter package name: `com.ebaladya.app` (or your package name)
   - Find it in: `android/app/build.gradle` → `applicationId`
3. Enter app nickname: **E-Baladya Android**
4. Leave SHA-1 empty for now (optional for FCM)
5. Click **"Register app"**
6. **Download `google-services.json`**
7. Click **"Next"** → **"Continue to console"**

### 1.3 Add iOS App (if targeting iOS)

1. Click the **iOS icon** (🍎)
2. Enter bundle ID: `com.ebaladya.app` (or your bundle ID)
   - Find it in: `ios/Runner.xcodeproj/project.pbxproj`
3. Enter app nickname: **E-Baladya iOS**
4. Click **"Register app"**
5. **Download `GoogleService-Info.plist`**
6. Click **"Next"** → **"Continue to console"**

### 1.4 Enable Cloud Messaging

1. In Firebase Console → **Build** → **Cloud Messaging**
2. Note your **Sender ID** and **Server Key** (for backend)

---

## 📱 Step 2: Android Configuration

### 2.1 Add Dependencies

**android/build.gradle** (Project-level)
```gradle
buildscript {
    ext.kotlin_version = '1.9.0'
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath 'com.android.tools.build:gradle:7.4.2'
        classpath "org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlin_version"
        // Add this line
        classpath 'com.google.gms:google-services:4.4.0'
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

**android/app/build.gradle** (App-level)
```gradle
plugins {
    id "com.android.application"
    id "kotlin-android"
    id "dev.flutter.flutter-gradle-plugin"
    // Add this line
    id 'com.google.gms.google-services'
}

android {
    namespace "com.ebaladya.app" // Your package name
    compileSdkVersion 34
    ndkVersion flutter.ndkVersion

    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }

    kotlinOptions {
        jvmTarget = '1.8'
    }

    defaultConfig {
        applicationId "com.ebaladya.app" // Your package name
        minSdkVersion 21  // FCM requires minimum SDK 21
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
        multiDexEnabled true
    }

    buildTypes {
        release {
            signingConfig signingConfigs.debug
        }
    }
}

dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    // Add these if not present
    implementation platform('com.google.firebase:firebase-bom:32.7.0')
    implementation 'com.google.firebase:firebase-messaging'
}
```

### 2.2 Place google-services.json

1. Copy the downloaded `google-services.json`
2. Place it in: **`android/app/google-services.json`**

**Directory structure should look like:**
```
android/
  app/
    google-services.json  ← Place here
    build.gradle
    src/
```

### 2.3 Update AndroidManifest.xml

**android/app/src/main/AndroidManifest.xml**
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    
    <!-- Add these permissions -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.VIBRATE" />
    <uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
    <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>

    <application
        android:label="E-Baladya"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>

            <!-- Add this for notification clicks -->
            <intent-filter>
                <action android:name="FLUTTER_NOTIFICATION_CLICK" />
                <category android:name="android.intent.category.DEFAULT" />
            </intent-filter>
        </activity>

        <!-- Add this meta-data for default notification icon -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_icon"
            android:resource="@drawable/ic_notification" />
        
        <!-- Add this meta-data for default notification color -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_color"
            android:resource="@color/notification_color" />

        <!-- Add this meta-data for notification channel -->
        <meta-data
            android:name="com.google.firebase.messaging.default_notification_channel_id"
            android:value="ebaladya_channel" />

        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
</manifest>
```

### 2.4 Create Notification Resources

**android/app/src/main/res/values/colors.xml**
```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="notification_color">#2563EB</color>
</resources>
```

**Create notification icon:**
- Create `android/app/src/main/res/drawable/ic_notification.xml`
```xml
<vector xmlns:android="http://schemas.android.com/apk/res/android"
    android:width="24dp"
    android:height="24dp"
    android:viewportWidth="24"
    android:viewportHeight="24">
    <path
        android:fillColor="#FFFFFF"
        android:pathData="M12,2C6.48,2 2,6.48 2,12s4.48,10 10,10 10,-4.48 10,-10S17.52,2 12,2zM13,17h-2v-6h2v6zM13,9h-2L11,7h2v2z"/>
</vector>
```

---

## 🍎 Step 3: iOS Configuration

### 3.1 Place GoogleService-Info.plist

1. Open your project in Xcode: `ios/Runner.xcworkspace`
2. Right-click on **Runner** folder
3. Select **"Add Files to Runner"**
4. Choose the downloaded `GoogleService-Info.plist`
5. **Check "Copy items if needed"**
6. Click **"Add"**

### 3.2 Enable Push Notifications Capability

1. In Xcode, select **Runner** project
2. Select **Runner** target
3. Go to **"Signing & Capabilities"** tab
4. Click **"+ Capability"**
5. Add **"Push Notifications"**
6. Add **"Background Modes"** and check:
   - **Remote notifications**
   - **Background fetch**

### 3.3 Update Info.plist

**ios/Runner/Info.plist**

Add before the closing `</dict>` tag:
```xml
<key>FirebaseAppDelegateProxyEnabled</key>
<false/>
<key>UIBackgroundModes</key>
<array>
    <string>fetch</string>
    <string>remote-notification</string>
</array>
```

### 3.4 Update AppDelegate.swift

**ios/Runner/AppDelegate.swift**
```swift
import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Firebase initialization
    FirebaseApp.configure()
    
    // Request notification permissions
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self
      
      let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
      UNUserNotificationCenter.current().requestAuthorization(
        options: authOptions,
        completionHandler: { _, _ in }
      )
    } else {
      let settings: UIUserNotificationSettings =
        UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
      application.registerUserNotificationSettings(settings)
    }
    
    application.registerForRemoteNotifications()
    
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  // Handle FCM token refresh
  override func application(_ application: UIApplication,
                            didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
    Messaging.messaging().apnsToken = deviceToken
  }
}
```

---

## 🎯 Step 4: Flutter Implementation

### 4.1 Add Dependencies

**pubspec.yaml**
```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Existing dependencies
  sqflite: ^2.3.0
  path: ^1.8.3
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5
  intl: ^0.18.1
  font_awesome_flutter: ^10.6.0
  path_provider: ^2.1.1
  
  # Add Firebase dependencies
  firebase_core: ^2.24.2
  firebase_messaging: ^14.7.9
  flutter_local_notifications: ^16.3.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.0
```

Run:
```bash
flutter pub get
```

### 4.2 Create Firebase Service

**lib/data/services/firebase_messaging_service.dart**
```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';

// Top-level function for background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling background message: ${message.messageId}');
  // Handle background message here
}

class FirebaseMessagingService {
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService() => _instance;
  FirebaseMessagingService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();

  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Initialize Firebase Messaging
  Future<void> initialize() async {
    // Request permission for iOS
    await _requestPermission();

    // Initialize local notifications
    await _initializeLocalNotifications();

    // Get FCM token
    await _getFCMToken();

    // Configure foreground notification presentation
    await _configureForegroundNotification();

    // Set up message handlers
    _setupMessageHandlers();

    // Listen to token refresh
    _listenToTokenRefresh();
  }

  /// Request notification permissions
  Future<void> _requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');
    
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission ✅');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      print('User granted provisional permission ⚠️');
    } else {
      print('User declined or has not accepted permission ❌');
    }
  }

  /// Initialize local notifications for Android
  Future<void> _initializeLocalNotifications() async {
    // Android initialization
    const AndroidInitializationSettings androidSettings = 
        AndroidInitializationSettings('@drawable/ic_notification');

    // iOS initialization
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // Create Android notification channel
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  /// Create notification channel for Android
  Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'ebaladya_channel', // id
      'E-Baladya Notifications', // name
      description: 'إشعارات تطبيق بلديتي الإلكترونية',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  /// Get FCM Token
  Future<void> _getFCMToken() async {
    try {
      _fcmToken = await _firebaseMessaging.getToken();
      print('📱 FCM Token: $_fcmToken');
      
      // TODO: Send token to your backend server
      // await _sendTokenToBackend(_fcmToken);
    } catch (e) {
      print('Error getting FCM token: $e');
    }
  }

  /// Configure foreground notification presentation
  Future<void> _configureForegroundNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Setup message handlers
  void _setupMessageHandlers() {
    // Handle messages when app is in foreground
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessageOpenedApp);

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Check if app was opened from terminated state
    _checkInitialMessage();
  }

  /// Handle foreground messages
  Future<void> _handleForegroundMessage(RemoteMessage message) async {
    print('📩 Foreground Message: ${message.messageId}');
    print('Title: ${message.notification?.title}');
    print('Body: ${message.notification?.body}');
    print('Data: ${message.data}');

    // Display local notification
    await _showLocalNotification(message);
  }

  /// Handle message when app is opened from notification
  void _handleMessageOpenedApp(RemoteMessage message) {
    print('🔔 App opened from notification: ${message.messageId}');
    print('Data: ${message.data}');
    
    // TODO: Navigate to specific screen based on notification data
    _handleNotificationNavigation(message.data);
  }

  /// Check if app was opened from terminated state by notification
  Future<void> _checkInitialMessage() async {
    RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
    
    if (initialMessage != null) {
      print('🚀 App opened from terminated state: ${initialMessage.messageId}');
      _handleNotificationNavigation(initialMessage.data);
    }
  }

  /// Show local notification
  Future<void> _showLocalNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'ebaladya_channel',
            'E-Baladya Notifications',
            channelDescription: 'إشعارات تطبيق بلديتي الإلكترونية',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@drawable/ic_notification',
            color: const Color(0xFF2563EB),
            enableVibration: true,
            playSound: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.toString(),
      );
    }
  }

  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    print('🔔 Notification tapped: ${response.payload}');
    
    // TODO: Parse payload and navigate to specific screen
    if (response.payload != null) {
      // Handle navigation based on payload
    }
  }

  /// Handle notification navigation based on data
  void _handleNotificationNavigation(Map<String, dynamic> data) {
    // Example: Navigate based on notification type
    String? type = data['type'];
    String? requestId = data['request_id'];
    
    switch (type) {
      case 'request_approved':
        // Navigate to tracking page with specific request
        print('Navigate to request details: $requestId');
        break;
      case 'request_ready':
        // Navigate to tracking page
        print('Navigate to tracking page');
        break;
      case 'document_available':
        // Navigate to digital documents page
        print('Navigate to documents page');
        break;
      default:
        // Navigate to home or do nothing
        break;
    }
  }

  /// Listen to token refresh
  void _listenToTokenRefresh() {
    _firebaseMessaging.onTokenRefresh.listen((newToken) {
      print('🔄 FCM Token refreshed: $newToken');
      _fcmToken = newToken;
      
      // TODO: Send updated token to backend
      // await _sendTokenToBackend(newToken);
    });
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      print('✅ Subscribed to topic: $topic');
    } catch (e) {
      print('❌ Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      print('✅ Unsubscribed from topic: $topic');
    } catch (e) {
      print('❌ Error unsubscribing from topic: $e');
    }
  }

  /// Delete FCM token
  Future<void> deleteToken() async {
    try {
      await _firebaseMessaging.deleteToken();
      _fcmToken = null;
      print('✅ FCM token deleted');
    } catch (e) {
      print('❌ Error deleting token: $e');
    }
  }
}
```

### 4.3 Update Database for FCM Token

**lib/data/database/database_helper.dart**

Add FCM token column to users table:
```dart
Future _createDB(Database db, int version) async {
  await db.execute('''
    CREATE TABLE users (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT NOT NULL,
      birth_date TEXT NOT NULL,
      address TEXT NOT NULL,
      phone TEXT NOT NULL,
      email TEXT NOT NULL,
      fcm_token TEXT,  -- Add this line
      created_at TEXT DEFAULT CURRENT_TIMESTAMP
    )
  ''');
  // ... rest of tables
}
```

Add method to update FCM token:
```dart
Future<int> updateUserFCMToken(int userId, String token) async {
  final db = await instance.database;
  return await db.update(
    'users',
    {'fcm_token': token},
    where: 'id = ?',
    whereArgs: [userId],
  );
}
```

### 4.4 Create Notification Cubit

**lib/logic/cubits/notifications/notification_cubit.dart**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../data/services/firebase_messaging_service.dart';

// States
abstract class NotificationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationPermissionGranted extends NotificationState {}

class NotificationPermissionDenied extends NotificationState {}

class NotificationReceived extends NotificationState {
  final String title;
  final String body;
  final Map<String, dynamic> data;

  NotificationReceived({
    required this.title,
    required this.body,
    required this.data,
  });

  @override
  List<Object?> get props => [title, body, data];
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

// Cubit
class NotificationCubit extends Cubit<NotificationState> {
  final FirebaseMessagingService _messagingService;

  NotificationCubit(this._messagingService) : super(NotificationInitial());

  Future<void> initialize() async {
    try {
      await _messagingService.initialize();
      emit(NotificationPermissionGranted());
    } catch (e) {
      emit(NotificationError('فشل تهيئة الإشعارات: ${e.toString()}'));
    }
  }

  Future<void> subscribeToUserNotifications(int userId) async {
    try {
      // Subscribe to user-specific topic
      await _messagingService.subscribeToTopic('user_$userId');
      
      // Subscribe to general notifications
      await _messagingService.subscribeToTopic('all_users');
    } catch (e) {
      emit(NotificationError('فشل الاشتراك في الإشعارات: ${e.toString()}'));
    }
  }

  Future<void> unsubscribeFromUserNotifications(int userId) async {
    try {
      await _messagingService.unsubscribeFromTopic('user_$userId');
      await _messagingService.unsubscribeFromTopic('all_users');
    } catch (e) {
      emit(NotificationError('فشل إلغاء الاشتراك: ${e.toString()}'));
    }
  }

  String? getFCMToken() {
    return _messagingService.fcmToken;
  }
}
```

### 4.5 Update main.dart

**lib/main.dart**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'data/repositories/user_repository.dart';
import 'data/repositories/request_repository.dart';
import 'data/services/firebase_messaging_service.dart';
import 'logic/cubits/requests/requests_cubit.dart';
import 'logic/cubits/notifications/notification_cubit.dart';
import 'presentation/screens/home_page.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp();
  
  // Initialize Firebase Messaging Service
  final messagingService = FirebaseMessagingService();
  await messagingService.initialize();
  
  runApp(MyApp(messagingService: messagingService));
}

class MyApp extends StatelessWidget {
  final FirebaseMessagingService messagingService;
  
  const MyApp({super.key, required this.messagingService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => RequestsCubit(RequestRepository()),
        ),
        BlocProvider(
          create: (context) => NotificationCubit(messagingService)..initialize(),
        ),
      ],
      child: MaterialApp(
        title: 'E-Baladya',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Cairo',
          primaryColor: const Color(0xFF2563EB),
        ),
        home: const HomePage(),
      ),
    );
  }
}
```

### 4.6 Create Notification Settings Page

**lib/presentation/screens/notification_settings_page.dart**
```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubits/notifications/notification_cubit.dart';
import '../widgets/custom_app_bar.dart';

class NotificationSettingsPage extends StatefulWidget {
  const NotificationSettingsPage({super.key});

  @override
  State<NotificationSettingsPage> createState() => _NotificationSettingsPageState();
}

class _NotificationSettingsPageState extends State<NotificationSettingsPage> {
  bool _requestUpdates = true;
  bool _documentReady = true;
  bool _generalNews = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight),
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: CustomAppBar(
              onArrowTap: () => Navigator.pop(context),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'إعدادات الإشعارات',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Cairo',
                  color: Color(0xFF2563EB),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              const Text(
                'اختر نوع الإشعارات التي تريد استقبالها',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B7280),
                  fontFamily: 'Cairo',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 40),
              
              // FCM Token Display
              BlocBuilder<NotificationCubit, NotificationState>(
                builder: (context, state) {
                  final token = context.read<NotificationCubit>().getFCMToken();
                  
                  if (token != null) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'رمز الجهاز (FCM Token)',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            token,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 10,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                          const SizedBox(height: