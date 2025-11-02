import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class BookingCalendarScreen extends StatefulWidget {
  const BookingCalendarScreen({super.key});

  @override
  State<BookingCalendarScreen> createState() => _BookingCalendarScreenState();
}

class _BookingCalendarScreenState extends State<BookingCalendarScreen> {
  // Available dates (green)
  final List<int> availableDates = [1, 3, 8, 11, 15, 22, 25, 29, 31];

  // Unavailable dates (red/pink)
  final List<int> unavailableDates = [2, 4, 10, 16, 17, 24, 30];

  int? selectedDate;

  final List<String> weekDays = [ 'خ', 'ج', 'س','ح', 'إ', 'ث', 'أ'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: const CustomAppBar(title: 'حجز في الحالة المدنية'),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  // Calendar card
                  Container(
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
                    child: Column(
                      children: [
                        // Month/Year header with arrows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chevron_left, size: 24),
                            ),
                            const Text(
                              'يناير 2026',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF111827),
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.chevron_right, size: 24),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Week days header
                        Row(
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
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),

                        const SizedBox(height: 12),

                        // Calendar grid
                        _buildCalendarGrid(),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Bottom button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: selectedDate != null
                          ? () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('حجز للتاريخ: $selectedDate'),
                                ),
                              );
                            }
                          : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE5E7EB),
                        disabledBackgroundColor: const Color(0xFFE5E7EB),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'احجز',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF9CA3AF),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Legend (vertical)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        _buildLegendItem(
                          'الأخضر متاح للحجز',
                          const Color(0xFF10B981),
                        ),
                        const SizedBox(height: 12),
                        _buildLegendItem(
                          'الأحمر غير متاح للحجز',
                          const Color(0xFFEF4444),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: MediaQuery.of(context).padding.bottom + 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarGrid() {
    // January 2024 starts on Monday
    List<Widget> dayWidgets = [];

    // Days of the month - fixed for proper RTL calendar
    List<List<int?>> weeks = [
      [1, 2, 3, 4, 5, 6, 7],
      [8, 9, 10, 11, 12, 13, 14],
      [15, 16, 17, 18, 19, 20, 21],
      [22, 23, 24, 25, 26, 27, 28],
      [29, 30, 31, null, null, null, null],
    ];

    return Column(
      children: weeks.map((week) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: week.map((day) {
              return _buildDayCell(day);
            }).toList(),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDayCell(int? day) {
    if (day == null) {
      return const SizedBox(width: 40, height: 40);
    }

    bool isAvailable = availableDates.contains(day);
    bool isUnavailable = unavailableDates.contains(day);
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
      onTap: isAvailable
          ? () {
              setState(() {
                selectedDate = day;
              });
            }
          : null,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '$day',
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      textDirection: TextDirection.rtl,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 13,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }
}
