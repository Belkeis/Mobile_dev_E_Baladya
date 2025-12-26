import 'package:flutter/material.dart';
import '../../../i18n/app_localizations.dart';
import '../../widgets/custom_app_bar.dart';

class AdminSettingsPage extends StatefulWidget {
  const AdminSettingsPage({super.key});

  @override
  State<AdminSettingsPage> createState() => _AdminSettingsPageState();
}

class _AdminSettingsPageState extends State<AdminSettingsPage> {
  bool _pushNotifications = true;
  bool _sound = true;
  bool _emailNotifications = false;
  bool _maintenanceMode = false;

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: CustomAppBar(
        title: localizations.translate('admin_settings_title'),
        onArrowTap: () => Navigator.pop(context),
        onProfileTap: () {
          Navigator.pushNamed(context, '/admin/profile');
        },
        onNotificationTap: () {
          Navigator.pushNamed(context, '/admin/notifications');
        },
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSettingCard(
            isArabic: isArabic,
            title: localizations.translate('setting_push_notifications'),
            value: _pushNotifications,
            onChanged: (v) {
              setState(() {
                _pushNotifications = v;
              });
            },
            icon: Icons.notifications_active_rounded,
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            isArabic: isArabic,
            title: localizations.translate('setting_sound'),
            value: _sound,
            onChanged: (v) {
              setState(() {
                _sound = v;
              });
            },
            icon: Icons.volume_up_rounded,
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            isArabic: isArabic,
            title: localizations.translate('setting_email_notifications'),
            value: _emailNotifications,
            onChanged: (v) {
              setState(() {
                _emailNotifications = v;
              });
            },
            icon: Icons.email_rounded,
          ),
          const SizedBox(height: 12),
          _buildSettingCard(
            isArabic: isArabic,
            title: localizations.translate('setting_maintenance_mode'),
            value: _maintenanceMode,
            onChanged: (v) {
              setState(() {
                _maintenanceMode = v;
              });
            },
            icon: Icons.build_circle_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required bool isArabic,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    required IconData icon,
  }) {
    final iconWidget = Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFDBEAFE),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: const Color(0xFF2563EB),
        size: 22,
      ),
    );
    final textWidget = Expanded(
      child: Text(
        title,
        style: const TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Color(0xFF111827),
        ),
        textAlign: isArabic ? TextAlign.right : TextAlign.left,
      ),
    );
    final switchWidget = Switch(
      value: value,
      onChanged: onChanged,
      activeColor: const Color(0xFF2563EB),
    );

    return Container(
      padding: const EdgeInsets.all(16),
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
        children: isArabic
            ? [switchWidget, const SizedBox(width: 14), textWidget, const SizedBox(width: 14), iconWidget]
            : [iconWidget, const SizedBox(width: 14), textWidget, const SizedBox(width: 14), switchWidget],
      ),
    );
  }
}
