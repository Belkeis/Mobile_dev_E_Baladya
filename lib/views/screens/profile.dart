import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/auth_cubit.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        String userName = 'اسم المستخدم';
        String email = 'example@gmail.com';
        String phone = '456 123 555 213+';
        String nationalId = '****-****-1234';
        String address = 'حي البدر، الجزائر العاصمة، الجزائر';

        if (authState is AuthAuthenticated) {
          final user = authState.user;
          userName = user.fullName;
          email = user.email;
          phone = user.phone ?? 'غير متوفر';
          nationalId = user.nationalId;
          address = 'ولاية الجزائر، بلدية باب الزوار'; // Default address
        }

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            //  AppBar
            appBar: PreferredSize(
              preferredSize: const Size.fromHeight(76),
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFF2563EB),
                ),
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 20,
                  right: 20,
                  bottom: 16,
                ),
                child: Stack(
                  children: [
                    //  "تعديل" on LEFT
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'تعديل',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),

                    //  Profile title in CENTER
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'الملف الشخصي',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Cairo',
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),

                    // Arrow on RIGHT pointing right - goes back to previous page
                    Align(
                      alignment: Alignment.centerRight,
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            body: SingleChildScrollView(
              padding: EdgeInsets.only(
                left: 25,
                right: 25,
                top: 25,
                bottom: MediaQuery.of(context).padding.bottom + 25,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //  User Picture
                  const CircleAvatar(
                    radius: 48,
                    backgroundImage: AssetImage('assets/images/person.png'),
                  ),
                  const SizedBox(height: 12),

                  //  User Name
                  Text(
                    userName,
                    style: const TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18,
                      fontWeight: FontWeight.normal,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 32),

                  //  Personal Details Section
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'المعلومات الشخصية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
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
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.badge,
                          label: 'رقم الهوية',
                          value: nationalId,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Color(0xFFE5E7EB)),
                        ),
                        _buildInfoRow(
                          icon: Icons.cake,
                          label: 'تاريخ الميلاد',
                          value: 'August 15, 1988',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  //  Contact Information Section
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'معلومات الاتصال',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
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
                    child: Column(
                      children: [
                        _buildInfoRow(
                          icon: Icons.email,
                          label: 'البريد الإلكتروني',
                          value: email,
                          hasVerification: true,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Divider(height: 1, color: Color(0xFFE5E7EB)),
                        ),
                        _buildInfoRow(
                          icon: Icons.phone,
                          label: 'الهاتف',
                          value: phone,
                          hasVerification: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  //  Address Section
                  const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'العنوان',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  Container(
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
                    child: _buildInfoRow(
                      icon: Icons.location_on,
                      label: 'العنوان المسجل',
                      value: address,
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    bool hasVerification = false,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF2563EB),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 13,
                  fontWeight: FontWeight.normal,
                  color: Color(0xFF6B7280),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF111827),
                      ),
                    ),
                  ),
                  if (hasVerification)
                    const Icon(
                      Icons.check_circle,
                      color: Color(0xFF059669),
                      size: 18,
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
