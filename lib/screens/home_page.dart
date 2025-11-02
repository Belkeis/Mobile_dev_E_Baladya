import 'package:flutter/material.dart';
import 'MyRequiredDocumentsPage.dart';
<<<<<<< Updated upstream
import 'tracking_requests.dart';
=======
import 'MyOnlineRequestsPage.dart';
import 'profile.dart'; // Add this import
import 'notifications_page.dart'; // Add this import
>>>>>>> Stashed changes

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Column(
        children: [
          // Top blue curve
          ClipPath(
            clipper: TopWaveClipper(),
            child: Container(
              height: 220,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      // Top row icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // Profile icon
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ProfilePage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.person_outline,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Notification icon
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const NotificationsPage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  const Icon(
                                    Icons.notifications_outlined,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFEF4444),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'مرحباً أحمد',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // White background container with content
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 30,
                ),
                child: Column(
                  children: [
                    // First Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            'الوثائق الرقمية',
                            Icons.picture_as_pdf_rounded,
                            const Color(0xFF10B981),
                            const Color(0xFFD1FAE5),
                            () {
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(_buildSnackBar('الوثائق الرقمية'));
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            'طلبات عبر الإنترنت',
                            Icons.language_rounded,
                            const Color(0xFF3B82F6),
                            const Color(0xFFDBEAFE),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyOnlineRequestsPage(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Second Row
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            'الوثائق المطلوبة',
                            Icons.folder_open_rounded,
                            const Color(0xFFF59E0B),
                            const Color(0xFFFEF3C7),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const MyRequiredDocumentsPage(),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            'تتبع الطلبات',
                            Icons.search_rounded,
                            const Color(0xFF8B5CF6),
                            const Color(0xFFEDE9FE),
                            () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RequestTrackingScreen(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Centered single box
                    Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: 160,
                        child: _buildMenuItem(
                          context,
                          'حجز موعد',
                          Icons.calendar_today_rounded,
                          const Color(0xFF2563EB),
                          const Color(0xFFDBEAFE),
                          () {
                            ScaffoldMessenger.of(
                              context,
                            ).showSnackBar(_buildSnackBar('حجز موعد'));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom blue curve
          ClipPath(
            clipper: FooterClipper(),
            child: Container(height: 120, color: const Color(0xFF2563EB)),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    Color iconColor,
    Color bgColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconColor, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
                fontFamily: 'Cairo',
              ),
            ),
          ],
        ),
      ),
    );
  }

  SnackBar _buildSnackBar(String message) {
    return SnackBar(
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 16, fontFamily: 'Cairo'),
      ),
      backgroundColor: const Color(0xFF2563EB),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.all(20),
    );
  }
}

// 🔵 Top smooth wave curve
class TopWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 50,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

// 🔵 Bottom smooth wave curve
class FooterClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(0, 50);

    var firstControlPoint = Offset(size.width / 4, 0);
    var firstEndPoint = Offset(size.width / 2, 30);
    path.quadraticBezierTo(
      firstControlPoint.dx,
      firstControlPoint.dy,
      firstEndPoint.dx,
      firstEndPoint.dy,
    );

    var secondControlPoint = Offset(size.width * 3 / 4, 60);
    var secondEndPoint = Offset(size.width, 50);
    path.quadraticBezierTo(
      secondControlPoint.dx,
      secondControlPoint.dy,
      secondEndPoint.dx,
      secondEndPoint.dy,
    );

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
