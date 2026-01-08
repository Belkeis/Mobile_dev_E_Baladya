import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../data/models/user_model.dart';
import '../widgets/custom_app_bar.dart';
import '../../i18n/app_localizations.dart';
import 'entering.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late TextEditingController _fullNameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _nationalIdController;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
    _nationalIdController = TextEditingController();
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _nationalIdController.dispose();
    super.dispose();
  }

  void _initializeControllers(UserModel user) {
    _fullNameController.text = user.fullName;
    _emailController.text = user.email;
    _phoneController.text = user.phone ?? '';
    _nationalIdController.text = user.nationalId;
  }

  void _showLogoutDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    final isArabic = localizations.isArabic;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
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
                  context.read<AuthCubit>().logout(null);
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

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthInitial) {
           Navigator.pushReplacementNamed(context, '/entering');
        }
      },
      builder: (context, state) {
        if (state is AuthInitial || state is AuthLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is! AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/entering');
          });
          return const SizedBox.shrink();
        }

        final user = state.user;
        _initializeControllers(user);

        return Directionality(
          textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: CustomAppBar(
              title: localizations.translate('profile'),
              onArrowTap: () => Navigator.pop(context),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                   // Profile Header
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(25),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFEFF6FF),
                          child: Icon(
                            Icons.person,
                            size: 50,
                            color: Color(0xFF2563EB),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  // Information Sections
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isArabic ? 'المعلومات الشخصية' : 'Informations Personnelles',
                          style: const TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF111827),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              _buildInfoTile(
                                label: localizations.fullName,
                                value: user.fullName,
                                icon: Icons.person_outline,
                              ),
                              _buildDivider(),
                              _buildInfoTile(
                                label: localizations.email,
                                value: user.email,
                                icon: Icons.email_outlined,
                              ),
                              _buildDivider(),
                              _buildInfoTile(
                                label: isArabic ? 'رقم الهاتف' : 'Téléphone',
                                value: user.phone ?? '---',
                                icon: Icons.phone_outlined,
                              ),
                              _buildDivider(),
                              _buildInfoTile(
                                label: isArabic ? 'رقم التعريف الوطني' : 'ID National',
                                value: user.nationalId,
                                icon: Icons.badge_outlined,
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        // Action Buttons
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(Icons.logout),
                            label: Text(
                              localizations.logout,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
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
                        const SizedBox(height: 50),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoTile({
    required String label,
    required String value,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF2563EB), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 15,
                    color: Color(0xFF1F2937),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return const Divider(
      height: 1,
      thickness: 1,
      color: Color(0xFFF3F4F6),
      indent: 20,
      endIndent: 20,
    );
  }
}
