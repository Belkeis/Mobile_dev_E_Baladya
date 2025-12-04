import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/cubit/booking_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../data/models/booking_model.dart';
import '../../data/models/service_model.dart';
import '../widgets/custom_app_bar.dart';

class MyBookingsPage extends StatelessWidget {
  const MyBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          context.read<BookingCubit>().loadBookings(authState.user.id!);
        } else if (authState is AuthInitial || authState is AuthLoading) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AuthCubit>().login('ahmed@example.com', 'password123');
          });
        }

        if (authState is! AuthAuthenticated) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: CustomAppBar(
              onArrowTap: () {
                Navigator.pop(context);
              },
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: CustomAppBar(
            onArrowTap: () {
              Navigator.pop(context);
            },
          ),
          body: BlocBuilder<BookingCubit, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is BookingError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                );
              }

              List<Map<String, dynamic>> bookingsWithService = [];
              if (state is BookingsLoaded) {
                bookingsWithService = state.bookingsWithService;
              }

              return SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'حجوزاتي',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'عرض جميع حجوزاتك والمواعيد المحددة',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (bookingsWithService.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Center(
                          child: Text(
                            'لا توجد حجوزات',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 16,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ),
                      )
                    else
                      ...bookingsWithService.map((item) {
                        final booking = item['booking'] as BookingModel;
                        final service = item['service'] as ServiceModel?;
                        final bookingType = item['booking_type']
                            as Map<String, dynamic>?; // NEW
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _buildBookingCard(
                            booking: booking,
                            service: service,
                            bookingType: bookingType, // NEW
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildBookingCard({
    required BookingModel booking,
    ServiceModel? service,
    Map<String, dynamic>? bookingType, // NEW
  }) {
    // Determine status colors
    Color statusColor;
    Color statusTextColor;
    String statusText;
    IconData icon;
    Color iconColor;
    Color iconBgColor;

    switch (booking.status) {
      case 'pending':
        statusColor = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFF92400E);
        statusText = 'قيد الانتظار';
        icon = Icons.pending;
        iconColor = const Color(0xFFF59E0B);
        iconBgColor = const Color(0xFFFEF3C7);
        break;
      case 'confirmed':
        statusColor = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF065F46);
        statusText = 'مؤكد';
        icon = Icons.check_circle;
        iconColor = const Color(0xFF059669);
        iconBgColor = const Color(0xFFD1FAE5);
        break;
      case 'cancelled':
        statusColor = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFF991B1B);
        statusText = 'ملغي';
        icon = Icons.cancel;
        iconColor = const Color(0xFFDC2626);
        iconBgColor = const Color(0xFFFEE2E2);
        break;
      default:
        statusColor = const Color(0xFFF3F4F6);
        statusTextColor = const Color(0xFF6B7280);
        statusText = booking.status;
        icon = Icons.info;
        iconColor = const Color(0xFF6B7280);
        iconBgColor = const Color(0xFFF3F4F6);
    }

    final bookingDate = DateTime.parse(booking.date);
    final formattedDate = DateFormat('yyyy/MM/dd', 'ar').format(bookingDate);
    final formattedTime = DateFormat('HH:mm', 'ar').format(bookingDate);

    // NEW: Use booking type name if available, otherwise fallback to service name
    final displayName = bookingType != null
        ? bookingType['name'] as String
        : (service?.name ?? 'خدمة');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
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
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  displayName, // NEW: Display booking type name
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'الحالة:',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      formattedTime,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.access_time,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      formattedDate,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.calendar_today,
                      size: 16,
                      color: Color(0xFF6B7280),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
