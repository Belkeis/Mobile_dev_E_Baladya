import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../i18n/app_localizations.dart';
import '../../../logic/cubit/auth_cubit.dart';
import '../../../utils/admin_auth.dart';
import '../../widgets/custom_app_bar.dart';
import '../entering.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  void _showLogoutDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            title: Text(
              localizations.logout,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
                color: Color(0xFF1F2937),
              ),
            ),
            content: Text(
              localizations.logoutConfirm,
              style: const TextStyle(
                fontFamily: 'Cairo',
                color: Color(0xFF6B7280),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                },
                child: Text(
                  localizations.cancel,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  AdminAuth().logout();
                  context.read<AuthCubit>().logout();
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const Entering()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade600,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  localizations.logout,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;

    final adminName = isArabic ? 'مسؤول البلدية' : 'Administrateur';
    final adminEmail = 'admin@baladya.tn';
    final adminRole = isArabic ? 'مسؤول' : 'Administrateur';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FAFB),
        appBar: CustomAppBar(
          title: localizations.translate('admin_profile_title'),
          onArrowTap: () => Navigator.pop(context),
          onNotificationTap: () {
            Navigator.pushNamed(context, '/admin/notifications');
          },
          onProfileTap: () {},
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Column(
                        textDirection:
                            isArabic ? TextDirection.rtl : TextDirection.ltr,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: isArabic
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: const CircleAvatar(
                              radius: 28,
                              backgroundColor: Color(0xFFDBEAFE),
                              child: Icon(
                                Icons.admin_panel_settings_rounded,
                                color: Color(0xFF2563EB),
                                size: 28,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            adminName,
                            textAlign: isArabic ? TextAlign.right : TextAlign.left,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF111827),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            adminEmail,
                            textAlign: isArabic ? TextAlign.right : TextAlign.left,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 12,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildInfoRow(
                      context: context,
                      icon: Icons.badge_rounded,
                      label: localizations.translate('admin_role'),
                      value: adminRole,
                      isArabic: isArabic,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(
                      context: context,
                      icon: Icons.location_city_rounded,
                      label: localizations.translate('municipality'),
                      value: isArabic ? 'بلدية' : 'Municipalité',
                      isArabic: isArabic,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: const Icon(Icons.logout, size: 20),
                  label: Text(
                    localizations.logout,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
    required bool isArabic,
  }) {
    final iconWidget = Icon(icon, size: 18, color: const Color(0xFF2563EB));
    final textWidget = Column(
      mainAxisSize: MainAxisSize.min,
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          textAlign: isArabic ? TextAlign.right : TextAlign.left,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF111827),
          ),
        ),
      ],
    );

    return Align(
      alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        children: [
          iconWidget,
          const SizedBox(width: 10),
          textWidget,
        ],
      ),
    );
  }
}
