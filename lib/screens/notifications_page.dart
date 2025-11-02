import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

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
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile tapped')),
          );
        },
        onArrowTap: () {
          Navigator.pop(context);
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 10),
          _buildNotificationCard(
            icon: Icons.check_circle,
            iconColor: const Color(0xFF059669),
            iconBgColor: const Color(0xFFD1FAE5),
            title: 'تم الموافقة على طلبك',
            description: 'تم الموافقة على طلب تجديد بطاقة الهوية الخاصة بك',
            time: 'منذ ساعتين',
            isRead: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.schedule,
            iconColor: const Color(0xFFF59E0B),
            iconBgColor: const Color(0xFFFEF3C7),
            title: 'تذكير بموعدك',
            description: 'لديك موعد غداً في الساعة 10:00 صباحاً',
            time: 'منذ 5 ساعات',
            isRead: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.info_outline,
            iconColor: const Color(0xFF2563EB),
            iconBgColor: const Color(0xFFDEEAFF),
            title: 'تحديث في حالة الطلب',
            description: 'طلب تجديد جواز السفر الخاص بك قيد المراجعة',
            time: 'منذ يوم واحد',
            isRead: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.description,
            iconColor: const Color(0xFF8B5CF6),
            iconBgColor: const Color(0xFFEDE9FE),
            title: 'وثائق مطلوبة',
            description: 'يرجى تحميل الوثائق الإضافية لإكمال طلبك',
            time: 'منذ يومين',
            isRead: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.warning_amber_rounded,
            iconColor: const Color(0xFFEF4444),
            iconBgColor: const Color(0xFFFEE2E2),
            title: 'انتهت صلاحية الوثيقة',
            description: 'بطاقة الهوية الخاصة بك ستنتهي صلاحيتها خلال 30 يوماً',
            time: 'منذ 3 أيام',
            isRead: true,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            icon: Icons.calendar_today_rounded,
            iconColor: const Color(0xFF2563EB),
            iconBgColor: const Color(0xFFDBEAFE),
            title: 'تم تأكيد الموعد',
            description: 'تم تأكيد موعدك بنجاح ليوم 15 نوفمبر 2025',
            time: 'منذ أسبوع',
            isRead: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String description,
    required String time,
    required bool isRead,
  }) {
    return Container(
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
              color: iconBgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: iconColor,
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
                      time,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
                      ),
                    ),
                    // Title on the right
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.4,
                  ),
                  textAlign: TextAlign.right,
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
    );
  }
}