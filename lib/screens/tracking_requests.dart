import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';

class RequestTrackingScreen extends StatelessWidget {
  const RequestTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        onArrowTap: () {
          // Navigate back or to home
          Navigator.pop(context);
        },
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(25),
              child: Column(
                children: [
                  Text(
                    'تتبع الطلب',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildRequestCard(
                    icon: Icons.card_travel,
                    iconColor: Color(0xFF2563EB),
                    iconBgColor: Color(0xFFDEEAFF),
                    title: 'تجديد جواز السفر',
                    status: 'قيد المراجعة',
                    statusColor: Color(0xFFFEF3C7),
                    statusTextColor: Color(0xFF92400E),
                    requestStatus: 'حالة الطلب:',
                    submittedTime: 'الوقت المتبقي: 3 أيام',
                    requestDate: 'وقت الطلب: 25 أكتوبر 2025',
                  ),
                  SizedBox(height: 20),
                  _buildRequestCard(
                    icon: Icons.credit_card,
                    iconColor: Color(0xFF059669),
                    iconBgColor: Color(0xFFD1FAE5),
                    title: 'تجديد بطاقة الهوية',
                    status: 'مكتمل',
                    statusColor: Color(0xFFD1FAE5),
                    statusTextColor: Color(0xFF065F46),
                    requestStatus: 'حالة الطلب:',
                    submittedTime: 'الوقت المتبقي: 3 أيام',
                    requestDate: 'وقت الطلب: 25 أكتوبر 2025',
                  ),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).padding.bottom + 20, // ✅ Add safe area padding
            ),
            color: Colors.transparent,
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/online-requests');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('New request tapped')),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2563EB),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'طلب جديد',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequestCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String status,
    required Color statusColor,
    required Color statusTextColor,
    required String requestStatus,
    required String submittedTime,
    required String requestDate,
  }) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
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
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        status,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      requestStatus,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  submittedTime,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.right,
                ),
                SizedBox(height: 4),
                Text(
                  requestDate,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}