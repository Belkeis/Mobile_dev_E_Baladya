import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../logic/cubit/language_cubit.dart';
import '../../i18n/app_localizations.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                          // Profile icon (SVG)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/profile');
                            },
                            child: SvgPicture.asset(
                              'assets/icons/profile.svg',
                              width: 26,
                              height: 26,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Language toggle button
                          BlocBuilder<LanguageCubit, LanguageState>(
                            builder: (context, state) {
                              final isArabic = state.locale.languageCode == 'ar';
                              return GestureDetector(
                                onTap: () {
                                  context.read<LanguageCubit>().toggleLanguage();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.white.withOpacity(0.3),
                                      width: 1,
                                    ),
                                  ),
                                  child: Text(
                                    isArabic ? 'FR' : 'AR',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 16),
                          // Notification icon (SVG)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/notifications');
                            },
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                SvgPicture.asset(
                                  'assets/icons/notification.svg',
                                  width: 17,
                                  height: 20,
                                  colorFilter: const ColorFilter.mode(
                                    Colors.white,
                                    BlendMode.srcIn,
                                  ),
                                ),
                                Positioned(
                                  top: -2,
                                  right: -2,
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
                        ],
                      ),
                      const SizedBox(height: 30),
                      Text(
                        AppLocalizations.of(context)!.welcome,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
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
                color: Color(0xFFF9FAFB),
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
                            AppLocalizations.of(context)!.digitalDocuments,
                            Icons.picture_as_pdf_rounded,
                            () => Navigator.pushNamed(
                                context, '/digital-versions'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            AppLocalizations.of(context)!.onlineRequests,
                            Icons.language_rounded,
                            () => Navigator.pushNamed(
                                context, '/online-requests'),
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
                            AppLocalizations.of(context)!.requiredDocuments,
                            Icons.folder_open_rounded,
                            () => Navigator.pushNamed(
                                context, '/required-documents'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            AppLocalizations.of(context)!.trackingRequests,
                            Icons.search_rounded,
                            () => Navigator.pushNamed(context, '/tracking'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Third Row - Bookings
                    Row(
                      children: [
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            AppLocalizations.of(context)!.myBookings,
                            Icons.event_note_rounded,
                            () => Navigator.pushNamed(context, '/my-bookings'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: _buildMenuItem(
                            context,
                            AppLocalizations.of(context)!.bookAppointment,
                            Icons.calendar_today_rounded,
                            () => Navigator.pushNamed(context, '/booking'),
                          ),
                        ),
                      ],
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
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon directly without background container
            Icon(
              icon,
              color: const Color(0xFF2563EB), // Blue color for all icons
              size: 40,
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
}

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
