import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/notification_repository.dart';
import '../../data/models/notification_model.dart';

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
}

