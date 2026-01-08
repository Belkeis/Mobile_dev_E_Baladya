import 'package:firebase_messaging/firebase_messaging.dart';
import '../data/models/notification_model.dart';
import '../data/repo/notification_repository.dart';

/// Global background message handler for Firebase Cloud Messaging
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('Handling a background message: ${message.messageId}');
  print('Message data: ${message.data}');
  print('Message notification: ${message.notification?.title}');
}

class FCMService {
  static FCMService? _instance;
  FirebaseMessaging? _messaging;
  NotificationRepository? _notificationRepository;
  bool _initialized = false;

  Function(String? notificationType, int? userId)? onNotificationTap;

  // Factory constructor that allows injection for testing
  factory FCMService() {
    _instance ??= FCMService._internal();
    return _instance!;
  }

  FCMService._internal();

  // Allow resetting instance for tests
  static void resetInstance() {
    _instance = null;
  }

  /// Initialize FCM service
  Future<void> initialize(NotificationRepository notificationRepository) async {
    if (_initialized) return;

    _notificationRepository = notificationRepository;

    try {
      _messaging = FirebaseMessaging.instance;

      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      NotificationSettings settings = await _messaging!.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('User granted permission: ${settings.authorizationStatus}');

      String? token = await _messaging!.getToken();
      print('FCM Token: $token');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('Foreground message received: ${message.messageId}');
        _handleMessage(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('Message clicked from background/closed: ${message.messageId}');
        _handleMessageClick(message);
      });

      RemoteMessage? initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        print('App opened from notification: ${initialMessage.messageId}');
        _handleMessageClick(initialMessage);
      }

      _initialized = true;
    } catch (e) {
      print('FCM initialization failed: $e');
      // Don't throw, just log - allows app to work without FCM
    }
  }

  void _handleMessage(RemoteMessage message) {
    print('Message title: ${message.notification?.title}');
    print('Message body: ${message.notification?.body}');
    print('Message data: ${message.data}');
    _saveNotificationLocally(message);
  }

  void _handleMessageClick(RemoteMessage message) {
    print('Handling message click: ${message.messageId}');
    String? notificationType = message.data['type'] ?? 'general';
    int? userId = int.tryParse(message.data['user_id'] ?? '');
    onNotificationTap?.call(notificationType, userId);
  }

  Future<void> _saveNotificationLocally(RemoteMessage message) async {
    try {
      if (_notificationRepository == null) {
        print('Notification repository not initialized');
        return;
      }

      final int userId = int.tryParse(message.data['user_id'] ?? '0') ?? 0;

      if (userId == 0) {
        print('Invalid user_id in notification');
        return;
      }

      final notification = NotificationModel(
        userId: userId,
        message: message.notification?.body ??
            message.data['message'] ??
            'No message',
        type: message.data['type'] ?? 'general',
        timestamp: DateTime.now().toIso8601String(),
        read: 0,
      );

      await _notificationRepository!.createNotification(notification);
      print('Notification saved to local database');
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  Future<String?> getFCMToken() async {
    if (_messaging == null) {
      print('FCM not initialized');
      return null;
    }
    return await _messaging!.getToken();
  }

  Future<void> subscribeToTopic(String topic) async {
    if (_messaging == null) {
      print('FCM not initialized, skipping topic subscription: $topic');
      return;
    }
    try {
      await _messaging!.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeFromTopic(String topic) async {
    if (_messaging == null) {
      print('FCM not initialized, skipping topic unsubscription: $topic');
      return;
    }
    try {
      await _messaging!.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  Future<void> subscribeUserToPersonalTopic(int userId) async {
    if (!_initialized || _messaging == null) {
      print(
          'FCM not initialized, skipping personal topic subscription for user $userId');
      return;
    }
    try {
      await subscribeToTopic('user_$userId');
      print('User subscribed to personal topic: user_$userId');
    } catch (e) {
      print('Error subscribing user to personal topic: $e');
    }
  }

  Future<void> unsubscribeUserFromPersonalTopic(int userId) async {
    if (!_initialized || _messaging == null) {
      print(
          'FCM not initialized, skipping personal topic unsubscription for user $userId');
      return;
    }
    try {
      await unsubscribeFromTopic('user_$userId');
      print('User unsubscribed from personal topic: user_$userId');
    } catch (e) {
      print('Error unsubscribing user from personal topic: $e');
    }
  }
}
