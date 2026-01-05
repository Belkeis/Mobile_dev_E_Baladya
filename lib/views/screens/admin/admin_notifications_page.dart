import 'package:flutter/material.dart';
import '../../../i18n/app_localizations.dart';
import '../../widgets/custom_app_bar.dart';

class AdminNotificationsPage extends StatelessWidget {
  const AdminNotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        title: localizations.translate('admin_notifications'),
        onNotificationTap: () {},
        onProfileTap: () {
          Navigator.pushNamed(context, '/admin/profile');
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
            isArabic: isArabic,
            icon: Icons.assignment_rounded,
            iconColor: const Color(0xFF2563EB),
            iconBgColor: const Color(0xFFDBEAFE),
            title: localizations.translate('track_requests'),
            description: localizations.locale.languageCode == 'ar'
                ? 'طلب جديد يحتاج للمراجعة (رقم: REQ-1204)'
                : 'Nouvelle demande à examiner (N°: REQ-1204)',
            time: localizations.locale.languageCode == 'ar' ? 'منذ 8 دقائق' : 'il y a 8 min',
            isRead: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            isArabic: isArabic,
            icon: Icons.event_available_rounded,
            iconColor: const Color(0xFF059669),
            iconBgColor: const Color(0xFFD1FAE5),
            title: localizations.translate('track_bookings'),
            description: localizations.locale.languageCode == 'ar'
                ? 'حجز جديد يحتاج للتأكيد (رقم: BK-3402)'
                : 'Nouvelle réservation à confirmer (N°: BK-3402)',
            time: localizations.locale.languageCode == 'ar' ? 'منذ 35 دقيقة' : 'il y a 35 min',
            isRead: false,
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            isArabic: isArabic,
            icon: Icons.priority_high_rounded,
            iconColor: const Color(0xFFF59E0B),
            iconBgColor: const Color(0xFFFEF3C7),
            title: localizations.locale.languageCode == 'ar'
                ? 'تنبيه'
                : 'Alerte',
            description: localizations.locale.languageCode == 'ar'
                ? 'يوجد 5 طلبات قيد المراجعة'
                : 'Il y a 5 demandes en attente',
            time: localizations.locale.languageCode == 'ar' ? 'منذ ساعة' : 'il y a 1 h',
            isRead: true,
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required bool isArabic,
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
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Expanded(
            child: Column(
              textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: isRead ? FontWeight.normal : FontWeight.w600,
                          color: const Color(0xFF111827),
                        ),
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      ),
                    ),
                    Text(
                      time,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 11,
                        color: Color(0xFF9CA3AF),
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
                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                ),
              ],
            ),
          ),
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
