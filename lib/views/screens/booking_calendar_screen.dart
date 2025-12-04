import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/cubit/booking_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../data/models/booking_model.dart';
import '../widgets/custom_app_bar.dart';

class BookingCalendarScreen extends StatefulWidget {
  final String serviceTitle;
  final int serviceId;
  final int bookingTypeId; // NEW: Add booking type ID

  const BookingCalendarScreen({
    super.key,
    required this.serviceTitle,
    required this.serviceId,
    required this.bookingTypeId, // NEW
  });

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  final List<int> availableDates = [1, 3, 8, 11, 15, 22, 25, 29, 31];
  final List<int> unavailableDates = [2, 4, 10, 16, 17, 24, 30];

  int? selectedDate;
  int selectedMonth = DateTime.now().month;
  int selectedYear = DateTime.now().year;
  bool _isSubmitting = false;

  final List<String> weekDays = ['خ', 'ج', 'س', 'ح', 'إ', 'ث', 'أ'];

  Future<void> _submitBooking() async {
    if (selectedDate == null) return;

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يجب تسجيل الدخول أولاً')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final bookingDate = DateTime(selectedYear, selectedMonth, selectedDate!);
      final booking = BookingModel(
        userId: authState.user.id!,
        serviceId: widget.serviceId,
        bookingTypeId: widget.bookingTypeId, // NEW: Include booking type ID
        date: bookingDate.toIso8601String(),
        status: 'pending',
      );

      await context.read<BookingCubit>().createBooking(booking);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حجز الموعد بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        title: 'حجز في ${widget.serviceTitle}',
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildCalendarCard(),
                  const SizedBox(height: 24),
                  _buildSubmitButton(),
                  const SizedBox(height: 20),
                  _buildLegend(),
                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard() {
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    final firstDay = DateTime(selectedYear, selectedMonth, 1).weekday;
    int adjustedFirstDay = (firstDay + 1) % 7;

    List<List<int?>> weeks = [];
    List<int?> currentWeek = [];

    for (int i = 0; i < adjustedFirstDay; i++) currentWeek.add(null);
    for (int day = 1; day <= daysInMonth; day++) {
      currentWeek.add(day);
      if (currentWeek.length == 7) {
        weeks.add(List.from(currentWeek));
        currentWeek.clear();
      }
    }
    if (currentWeek.isNotEmpty)
      while (currentWeek.length < 7) currentWeek.add(null);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          _buildMonthHeader(),
          const SizedBox(height: 16),
          _buildWeekDays(),
          const SizedBox(height: 12),
          Column(
            children: weeks.map((week) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: week.map((day) => _buildDayCell(day)).toList(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthHeader() {
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              if (selectedMonth == 1) {
                selectedMonth = 12;
                selectedYear--;
              } else
                selectedMonth--;
            });
          },
          icon: const Icon(Icons.chevron_left, size: 24),
        ),
        Text(
          '${months[selectedMonth - 1]} $selectedYear',
          style: const TextStyle(
              fontFamily: 'Cairo',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF111827)),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              if (selectedMonth == 12) {
                selectedMonth = 1;
                selectedYear++;
              } else
                selectedMonth++;
            });
          },
          icon: const Icon(Icons.chevron_right, size: 24),
        ),
      ],
    );
  }

  Widget _buildWeekDays() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: weekDays.map((day) {
        return SizedBox(
          width: 40,
          child: Center(
            child: Text(
              day,
              style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF6B7280)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayCell(int? day) {
    if (day == null) return const SizedBox(width: 40, height: 40);

    final currentDate = DateTime.now();
    final checkDate = DateTime(selectedYear, selectedMonth, day);
    final isPast = checkDate.isBefore(
        DateTime(currentDate.year, currentDate.month, currentDate.day));
    bool isAvailable = availableDates.contains(day) && !isPast;
    bool isUnavailable = unavailableDates.contains(day) || isPast;
    bool isSelected = selectedDate == day;

    Color backgroundColor;
    Color textColor;

    if (isSelected) {
      backgroundColor = const Color(0xFF2563EB);
      textColor = Colors.white;
    } else if (isAvailable) {
      backgroundColor = const Color(0xFFD1FAE5);
      textColor = const Color(0xFF065F46);
    } else if (isUnavailable) {
      backgroundColor = const Color(0xFFFECDD3);
      textColor = const Color(0xFF9F1239);
    } else {
      backgroundColor = Colors.transparent;
      textColor = const Color(0xFF9CA3AF);
    }

    return GestureDetector(
      onTap: isAvailable ? () => setState(() => selectedDate = day) : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: textColor),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed:
            (selectedDate != null && !_isSubmitting) ? _submitBooking : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: (selectedDate != null && !_isSubmitting)
              ? const Color(0xFF2563EB)
              : const Color(0xFFE5E7EB),
          disabledBackgroundColor: const Color(0xFFE5E7EB),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: _isSubmitting
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white)))
            : Text('احجز',
                style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: (selectedDate != null && !_isSubmitting)
                        ? Colors.white
                        : const Color(0xFF9CA3AF))),
      ),
    );
  }

  Widget _buildLegend() {
    return Align(
      alignment: Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildLegendItem('الأخضر متاح للحجز', const Color(0xFF10B981)),
          const SizedBox(height: 12),
          _buildLegendItem('الأحمر غير متاح للحجز', const Color(0xFFEF4444)),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
            width: 16,
            height: 16,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(text,
            style: const TextStyle(
                fontFamily: 'Cairo', fontSize: 13, color: Color(0xFF6B7280))),
      ],
    );
  }
}
