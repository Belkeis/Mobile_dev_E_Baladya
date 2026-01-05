import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/notification_repository.dart';
import '../../data/models/notification_model.dart';
import '../../commons/app_routes.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository _notificationRepository;

  NotificationCubit(this._notificationRepository) : super(NotificationInitial());

  Future<void> loadNotifications(int userId) async {
    emit(NotificationLoading());
    try {
      final notifications = await _notificationRepository.getNotificationsByUserId(userId);
      final unreadCount = await _notificationRepository.getUnreadCount(userId);
      emit(NotificationsLoaded(notifications, unreadCount));
    } catch (e) {
      emit(NotificationError('حدث خطأ أثناء تحميل الإشعارات'));
    }
  }

  Future<void> markAsRead(int notificationId, int userId) async {
    try {
      await _notificationRepository.markAsRead(notificationId);
      await loadNotifications(userId);
    } catch (e) {
      emit(NotificationError('حدث خطأ أثناء تحديث الإشعار'));
    }
  }

  /// Handle notification tap and navigate to appropriate screen
  void handleNotificationTap(String? notificationType, int? userId) {
    if (userId == null) return;

    // Map notification type to appropriate screen route
    final routeMap = {
      'booking': AppRoutes.myBookings,
      'request': AppRoutes.tracking,
      'document': AppRoutes.digitalVersions,
      'service': AppRoutes.home,
      'general': AppRoutes.notifications,
    };

    final route = routeMap[notificationType] ?? AppRoutes.notifications;

    emit(NotificationNavigate(
      route: route,
      notificationType: notificationType,
      arguments: userId != null ? {'userId': userId} : null,
    ));
  }

  /// Add new notification to the list
  Future<void> addNotification(NotificationModel notification) async {
    try {
      await _notificationRepository.createNotification(notification);
      // Reload notifications
      await loadNotifications(notification.userId);
    } catch (e) {
      emit(NotificationError('حدث خطأ أثناء إضافة الإشعار'));
    }
  }
}


