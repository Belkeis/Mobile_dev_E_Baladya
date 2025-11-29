import '../database/database_helper.dart';
import '../models/notification_model.dart';

class NotificationRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<NotificationModel>> getNotificationsByUserId(int userId) async {
    return await _dbHelper.getNotificationsByUserId(userId);
  }

  Future<int> createNotification(NotificationModel notification) async {
    return await _dbHelper.insertNotification(notification);
  }

  Future<int> markAsRead(int notificationId) async {
    return await _dbHelper.markNotificationAsRead(notificationId);
  }

  Future<int> getUnreadCount(int userId) async {
    final notifications = await getNotificationsByUserId(userId);
    return notifications.where((n) => n.read == 0).length;
  }
}

