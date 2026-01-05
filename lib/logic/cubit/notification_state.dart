part of 'notification_cubit.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationsLoaded extends NotificationState {
  final List<NotificationModel> notifications;
  final int unreadCount;

  const NotificationsLoaded(this.notifications, this.unreadCount);

  @override
  List<Object?> get props => [notifications, unreadCount];
}

class NotificationNavigate extends NotificationState {
  final String route;
  final Map<String, dynamic>? arguments;
  final String? notificationType;

  const NotificationNavigate({
    required this.route,
    this.arguments,
    this.notificationType,
  });

  @override
  List<Object?> get props => [route, arguments, notificationType];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}

