import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../data/models/service_model.dart';
import '../widgets/custom_app_bar.dart';
import '../../i18n/app_localizations.dart';
import 'service_details_screen.dart';

class MyOnlineRequestsPage extends StatelessWidget {
  const MyOnlineRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
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

        // Extract services from any state that has them
        List<ServiceModel> services = [];
        if (state is ServiceLoaded) {
          services = state.services;
        } else if (state is ServiceDetailsLoaded) {
          services = state.allServices; // Use cached services
        } else if (state is RequiredDocumentsLoaded) {
          services = state.allServices; // Use cached services
        }

        final localizations = AppLocalizations.of(context)!;
        return Directionality(
          textDirection: localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
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
                  Text(
                    AppLocalizations.of(context)!.onlineRequestsTitle,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'Cairo',
                      color: Color(0xFF2563EB),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context)!.onlineRequestsSubtitle,
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
  final localizations = AppLocalizations.of(context)!;
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
        children: [
          Expanded(
            child: Text(
              localizations.translateServiceName(service.name),
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 17,
                fontWeight: FontWeight.normal,
                color: Color(0xFF111827),
              ),
              textAlign: localizations.isArabic ? TextAlign.right : TextAlign.left,
            ),
          ),
        ],
      ),
    ),
  );
}

}