import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/custom_app_bar.dart';
import 'booking_calendar_screen.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

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
              onArrowTap: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                    Icons.event_available,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'احجز موعدك',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                  fontFamily: 'Cairo',
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'اختر نوع الخدمة المطلوبة',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: 'Cairo',
                ),
              ),
              const SizedBox(height: 50),

              // Service Cards
              ServiceCard(
                icon: Icons.credit_card,
                iconColor: const Color(0xFF4CAF50),
                iconBgColor: const Color(0xFFD1FAE5),
                title: 'الحالة المدنية',
                subtitle: 'استخراج وثائق الحالة المدنية',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingCalendarScreen(
                        serviceId: 1,
                        serviceTitle: 'الحالة المدنية',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ServiceCard(
                icon: Icons.fingerprint,
                iconColor: const Color(0xFF3F51B5),
                iconBgColor: const Color(0xFFDEEAFF),
                title: 'المصالح البيومترية',
                subtitle: 'خدمات البصمة والبيانات البيومترية',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingCalendarScreen(
                        serviceId: 2,
                        serviceTitle: 'المصالح البيومترية',
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              ServiceCard(
                iconWidget: const FaIcon(
                  FontAwesomeIcons.handHolding,
                  color: Color(0xFFFF9800),
                  size: 24,
                ),
                iconColor: const Color(0xFFFF9800),
                iconBgColor: const Color(0xFFFEF3C7),
                title: 'الاستلام',
                subtitle: 'استلام الوثائق الجاهزة',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BookingCalendarScreen(
                        serviceId: 3,
                        serviceTitle: 'الاستلام',
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final IconData? icon;
  final Widget? iconWidget;
  final Color iconColor;
  final Color iconBgColor;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    this.icon,
    this.iconWidget,
    required this.iconColor,
    required this.iconBgColor,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: iconWidget ?? Icon(icon, color: iconColor, size: 24),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF111827),
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
