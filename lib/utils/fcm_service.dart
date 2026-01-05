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
  static final FCMService _instance = FCMService._internal();
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  late NotificationRepository _notificationRepository;
  
  // Callback for notification tap
  Function(String? notificationType, int? userId)? onNotificationTap;

  factory FCMService() {
    return _instance;
  }

  FCMService._internal();

  /// Initialize FCM service
  Future<void> initialize(NotificationRepository notificationRepository) async {
    _notificationRepository = notificationRepository;
    
    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request user notification permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    print('User granted permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await _messaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Foreground message received: ${message.messageId}');
      _handleMessage(message);
    });

    // Handle notification tap when app is in background or closed
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Message clicked from background/closed: ${message.messageId}');
      _handleMessageClick(message);
    });

    // Check if app was opened from notification
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from notification: ${initialMessage.messageId}');
      _handleMessageClick(initialMessage);
    }
  }

  /// Handle incoming message (foreground)
  void _handleMessage(RemoteMessage message) {
    print('Message title: ${message.notification?.title}');
    print('Message body: ${message.notification?.body}');
    print('Message data: ${message.data}');

    // Save notification to local database
    _saveNotificationLocally(message);

    // Show notification (you can customize this part)
    // For foreground notifications, you might want to use a local notifications package
    // or show a custom dialog/snackbar
  }

  /// Handle notification tap
  void _handleMessageClick(RemoteMessage message) {
    print('Handling message click: ${message.messageId}');

    // Extract notification type and user ID from message data
    String? notificationType = message.data['type'] ?? 'general';
    int? userId = int.tryParse(message.data['user_id'] ?? '');

    // Call the callback if set
    onNotificationTap?.call(notificationType, userId);
  }

  /// Save notification to local database
  Future<void> _saveNotificationLocally(RemoteMessage message) async {
    try {
      final int userId = int.tryParse(message.data['user_id'] ?? '0') ?? 0;
      
      if (userId == 0) {
        print('Invalid user_id in notification');
        return;
      }

      final notification = NotificationModel(
        userId: userId,
        message: message.notification?.body ?? message.data['message'] ?? 'No message',
        type: message.data['type'] ?? 'general',
        timestamp: DateTime.now().toIso8601String(),
        read: 0,
      );

      await _notificationRepository.createNotification(notification);
      print('Notification saved to local database');
    } catch (e) {
      print('Error saving notification: $e');
    }
  }

  /// Get FCM token
  Future<String?> getFCMToken() async {
    return await _messaging.getToken();
  }

  /// Subscribe to topic (for targeted messaging)
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      print('Subscribed to topic: $topic');
    } catch (e) {
      print('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      print('Unsubscribed from topic: $topic');
    } catch (e) {
      print('Error unsubscribing from topic: $e');
    }
  }

  /// Subscribe user to their personal topic (user_id based)
  Future<void> subscribeUserToPersonalTopic(int userId) async {
    try {
      await subscribeToTopic('user_$userId');
      print('User subscribed to personal topic: user_$userId');
    } catch (e) {
      print('Error subscribing user to personal topic: $e');
    }
  }

  /// Unsubscribe user from their personal topic
  Future<void> unsubscribeUserFromPersonalTopic(int userId) async {
    try {
      await unsubscribeFromTopic('user_$userId');
      print('User unsubscribed from personal topic: user_$userId');
    } catch (e) {
      print('Error unsubscribing user from personal topic: $e');
    }
  }
}
