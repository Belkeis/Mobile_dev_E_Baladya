import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../widgets/custom_app_bar.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        //  CustomAppBar
        appBar: CustomAppBar(
          onArrowTap: () {
            // Navigate back or to home
            Navigator.pop(context);
          },
        ),

        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 🟦 Circle Icon
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

              const SizedBox(height: 15),

              const Text(
                'احجز موعدك',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),

              const SizedBox(height: 5),

              Text(
                'اختر نوع الخدمة المطلوبة',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade700,
                  fontFamily: 'Cairo',
                ),
              ),

              const SizedBox(height: 30),

              const Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'نوع الحجز',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // 🧾 Service Cards
              const ServiceCard(
                icon: Icons.credit_card,
                iconColor: Color(0xFF4CAF50),
                title: 'الحالة المدنية',
                subtitle: 'استخراج وثائق الحالة المدنية',
              ),
              const SizedBox(height: 10),
              const ServiceCard(
                icon: Icons.fingerprint,
                iconColor: Color(0xFF3F51B5),
                title: 'المصالح البيومترية',
                subtitle: 'خدمات البصمة والبيانات البيومترية',
              ),
              const SizedBox(height: 10),
              ServiceCard(
                iconWidget: const FaIcon(
                  FontAwesomeIcons.handHolding,
                  color: Color(0xFFFF9800),
                  size: 24,
                ),
                iconColor: const Color(0xFFFF9800),
                title: 'الاستلام',
                subtitle: 'استلام الوثائق الجاهزة',
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
  final String title;
  final String subtitle;

  const ServiceCard({
    super.key,
    this.icon,
    this.iconWidget,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade100,
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: iconWidget ?? Icon(icon, color: iconColor, size: 24),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Radio(value: false, groupValue: true, onChanged: (_) {}),
        ],
      ),
    );
  }
}
