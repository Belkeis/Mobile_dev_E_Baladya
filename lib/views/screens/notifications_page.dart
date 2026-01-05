import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/cubit/notification_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../widgets/custom_app_bar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated && authState.user.id != null) {
      context.read<NotificationCubit>().loadNotifications(authState.user.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        title: 'الإشعارات',
        onNotificationTap: () {
          // Already on notifications page
        },
        onProfileTap: () {
          Navigator.pushNamed(context, '/profile');
        },
        onArrowTap: () {
          Navigator.pop(context);
        },
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2563EB)),
              ),
            );
          }

          if (state is NotificationsLoaded) {
            if (state.notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.notifications_none_outlined,
                      size: 80,
                      color: Colors.grey[300],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'لا توجد إشعارات',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'سيتم عرض الإشعارات هنا عند وصول رسائل جديدة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                _loadNotifications();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(20),
                itemCount: state.notifications.length,
                itemBuilder: (context, index) {
                  final notification = state.notifications[index];
                  final isRead = notification.read == 1;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildNotificationCard(
                      context,
                      notification: notification,
                      isRead: isRead,
                      onTap: () {
                        // Mark as read and navigate
                        if (!isRead) {
                          context.read<NotificationCubit>().markAsRead(
                                notification.id!,
                                notification.userId,
                              );
                        }
                        // Handle navigation based on notification type
                        context.read<NotificationCubit>().handleNotificationTap(
                              notification.type,
                              notification.userId,
                            );
                      },
                    ),
                  );
                },
              ),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 80,
                    color: Colors.red[300],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'حدث خطأ',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.red[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.message,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadNotifications,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'إعادة محاولة',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildNotificationCard(
    BuildContext context, {
    required notification,
    required bool isRead,
    required VoidCallback onTap,
  }) {
    final typeIconMap = {
      'booking': Icons.calendar_today_rounded,
      'request': Icons.assignment,
      'document': Icons.description,
      'service': Icons.handshake,
      'general': Icons.notifications,
    };

    final typeColorMap = {
      'booking': const Color(0xFF2563EB),
      'request': const Color(0xFF8B5CF6),
      'document': const Color(0xFF059669),
      'service': const Color(0xFFF59E0B),
      'general': const Color(0xFF6B7280),
    };

    final typeBackgroundMap = {
      'booking': const Color(0xFFDBEAFE),
      'request': const Color(0xFFEDE9FE),
      'document': const Color(0xFFD1FAE5),
      'service': const Color(0xFFFEF3C7),
      'general': const Color(0xFFE5E7EB),
    };

    final icon = typeIconMap[notification.type] ?? Icons.notifications;
    final color = typeColorMap[notification.type] ?? const Color(0xFF6B7280);
    final backgroundColor =
        typeBackgroundMap[notification.type] ?? const Color(0xFFE5E7EB);

    // Format time difference
    final notificationTime = DateTime.parse(notification.timestamp);
    final now = DateTime.now();
    final difference = now.difference(notificationTime);

    String timeString;
    if (difference.inMinutes < 60) {
      timeString = 'قبل ${difference.inMinutes} دقيقة';
    } else if (difference.inHours < 24) {
      timeString = 'قبل ${difference.inHours} ساعة';
    } else if (difference.inDays < 30) {
      timeString = 'قبل ${difference.inDays} يوم';
    } else {
      timeString = DateFormat('dd/MM/yyyy').format(notificationTime);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isRead ? Colors.white : const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isRead ? const Color(0xFFE5E7EB) : const Color(0xFFBAE6FD),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Time on the left
                      Text(
                        timeString,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 11,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                      // Type badge on the right
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: backgroundColor,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _getArabicType(notification.type),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification.message,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 13,
                      fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                      color: const Color(0xFF111827),
                      height: 1.4,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            // Unread indicator dot
            if (!isRead) ...[
              const SizedBox(width: 6),
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _getArabicType(String type) {
    switch (type) {
      case 'booking':
        return 'موعد';
      case 'request':
        return 'طلب';
      case 'document':
        return 'وثيقة';
      case 'service':
        return 'خدمة';
      default:
        return 'عام';
    }
  }
}
