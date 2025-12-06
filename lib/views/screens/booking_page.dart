import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../../i18n/app_localizations.dart';
import 'booking_calendar_screen.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onArrowTap: () {
          Navigator.pop(context);
        },
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
            Text(
              AppLocalizations.of(context)!.bookYourAppointment,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.normal,
                fontFamily: 'Cairo',
                color: Color(0xFF2563EB),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context)!.selectServiceType,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                fontFamily: 'Cairo',
              ),
            ),
            const SizedBox(height: 50),

            // Service Cards
            ServiceCard(
              title: AppLocalizations.of(context)!.civilStatus,
              subtitle: AppLocalizations.of(context)!.civilStatusSubtitle,
              onTap: () {
                final localizations = AppLocalizations.of(context)!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingCalendarScreen(
                      serviceId: 1,
                      bookingTypeId: 1,
                      serviceTitle: localizations.civilStatus,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ServiceCard(
              title: AppLocalizations.of(context)!.biometricServices,
              subtitle: AppLocalizations.of(context)!.biometricServicesSubtitle,
              onTap: () {
                final localizations = AppLocalizations.of(context)!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingCalendarScreen(
                      serviceId: 2,
                      bookingTypeId: 2,
                      serviceTitle: localizations.biometricServices,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ServiceCard(
              title: AppLocalizations.of(context)!.pickup,
              subtitle: AppLocalizations.of(context)!.pickupSubtitle,
              onTap: () {
                final localizations = AppLocalizations.of(context)!;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BookingCalendarScreen(
                      serviceId: 3,
                      bookingTypeId: 3,
                      serviceTitle: localizations.pickup,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ServiceCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.normal,
                color: Color(0xFF111827),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              textAlign: TextAlign.left,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
