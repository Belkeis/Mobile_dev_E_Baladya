import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../data/models/service_model.dart';
import '../widgets/custom_app_bar.dart';
import 'service_details_screen.dart';

class MyOnlineRequestsPage extends StatelessWidget {
  const MyOnlineRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Reload services when screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCubit>().loadServices();
    });

    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ServiceError) {
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
              body: Center(
                child: Text(
                  state.message,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          );
        }

        List<ServiceModel> services = [];
        if (state is ServiceLoaded) {
          services = state.services;
        }

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
                  // Title
                  const Text(
                    'الطلبات الإلكترونية',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Cairo',
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'اختر نوع الطلب وأكمل تأكيد معلوماتك\nلتقديمه إلكترونيًا بسهولة.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                      fontFamily: 'Cairo',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 50),

                  // Service Cards from database
                  ...services.map((service) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildServiceCard(
                          context,
                          service: service,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ServiceDetailsScreen(service: service),
                              ),
                            );
                          },
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildServiceCard(
    BuildContext context, {
    required ServiceModel service,
    required VoidCallback onTap,
  }) {
    // Map service names to icons
    IconData icon = Icons.description;
    Color iconColor = const Color(0xFF2563EB);
    Color iconBgColor = const Color(0xFFDBEAFE);

    if (service.name.contains('بطاقة') || service.name.contains('هوية')) {
      icon = FontAwesomeIcons.idCard;
      iconColor = const Color(0xFF0381FF);
      iconBgColor = const Color(0xFFDEEAFF);
    } else if (service.name.contains('جواز')) {
      icon = FontAwesomeIcons.passport;
      iconColor = const Color(0xFF0DA839);
      iconBgColor = const Color(0xFFD1FAE5);
    } else if (service.name.contains('ميلاد')) {
      icon = FontAwesomeIcons.certificate;
      iconColor = const Color(0xFF9C27B0);
      iconBgColor = const Color(0xFFF3E5F5);
    } else if (service.name.contains('زواج')) {
      icon = FontAwesomeIcons.heart;
      iconColor = const Color(0xFFE03CBC);
      iconBgColor = const Color(0xFFFCE4EC);
    } else if (service.name.contains('إقامة')) {
      icon = FontAwesomeIcons.house;
      iconColor = const Color(0xFFDF6F1A);
      iconBgColor = const Color(0xFFFEF3C7);
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: FaIcon(icon, color: iconColor, size: 22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                service.name,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 17,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF111827),
                ),
                textAlign: TextAlign.right,
              ),
            ),
            const Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF9CA3AF),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}