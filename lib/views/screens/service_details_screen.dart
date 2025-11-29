import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../logic/cubit/request_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../data/models/service_model.dart';
import '../../data/models/request_model.dart';
import '../../data/models/user_model.dart';
import '../widgets/custom_app_bar.dart';
import 'after_req.dart';

class ServiceDetailsScreen extends StatelessWidget {
  final ServiceModel service;

  const ServiceDetailsScreen({super.key, required this.service});

  void _showConfirmationDialog(BuildContext context, UserModel user) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.3),
      builder: (BuildContext context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Dialog(
              elevation: 0,
              backgroundColor: Colors.white,
              insetPadding: const EdgeInsets.symmetric(horizontal: 25, vertical: 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(22.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      "تأكيد البيانات الشخصية",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.normal,
                        color: Color(0xFF2563EB),
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "يرجى مراجعة معلوماتك لتأكيد هويتك واستكمال الطلب بسهولة.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    const SizedBox(height: 18),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoRow("الاسم الكامل:", user.fullName),
                        _InfoRow("البريد الإلكتروني:", user.email),
                        _InfoRow("رقم الهاتف:", user.phone ?? 'غير متوفر'),
                        _InfoRow("رقم الهوية:", user.nationalId),
                      ],
                    ),
                    const SizedBox(height: 25),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: _ActionButton(
                            text: "تأكيد ",
                            textColor: Colors.white,
                            background: const Color(0xFF2563EB),
                            isConfirm: true,
                            service: service,
                            userId: user.id!,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            text: "إلغاء",
                            textColor: const Color(0xFF6B7280),
                            background: Colors.white,
                            shadow: true,
                            isConfirm: false,
                            service: service,
                            userId: user.id!,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, serviceState) {
        if (serviceState is ServiceDetailsLoaded) {
          return _buildContent(context, serviceState.requiredDocuments);
        } else if (serviceState is ServiceLoading) {
          context.read<ServiceCubit>().loadServiceDetails(service.id!);
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        } else {
          context.read<ServiceCubit>().loadServiceDetails(service.id!);
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Widget _buildContent(BuildContext context, List requiredDocuments) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        UserModel? user;
        if (authState is AuthAuthenticated) {
          user = authState.user;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: CustomAppBar(
            onArrowTap: () {
              Navigator.pop(context);
            },
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Text(
                        service.name,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 24,
                          fontWeight: FontWeight.normal,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        service.description,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildInfoCard(
                        'مدة المعالجة',
                        service.processingTime,
                        Icons.access_time,
                        const Color(0xFF3B82F6),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoCard(
                        'الرسوم',
                        '${service.fee.toStringAsFixed(0)} دج',
                        Icons.payments,
                        const Color(0xFF10B981),
                      ),
                      const SizedBox(height: 40),
                      Container(
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
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: const BoxDecoration(
                                color: Color(0xFFF0F7FF),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(16),
                                  topRight: Radius.circular(16),
                                ),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.description,
                                    color: Color(0xFF2563EB),
                                    size: 24,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'الوثائق المطلوبة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                      color: Color(0xFF2563EB),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                children: requiredDocuments
                                    .map<Widget>((doc) => _buildRequirement(doc.name))
                                    .toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.info_outline,
                              color: Color(0xFF92400E),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'بعد تقديم الطلب، ستحصل على إشعار تأكيد. ثم قم بزيارة البلدية لاستلام الوثيقة والدفع (مثال: ${service.fee.toStringAsFixed(0)} دج).',
                                style: const TextStyle(
                                  fontFamily: 'Cairo',
                                  fontSize: 13,
                                  color: Color(0xFF92400E),
                                  height: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                  bottom: MediaQuery.of(context).padding.bottom + 20,
                ),
                color: Colors.transparent,
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: user != null
                        ? () => _showConfirmationDialog(context, user!)
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00D26A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'طلب الآن',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.send, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 24),
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
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF111827),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, left: 12),
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: Color(0xFF2563EB),
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: RichText(
        textDirection: TextDirection.rtl,
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontSize: 14,
            color: Color(0xFF111827),
          ),
          children: [
            TextSpan(
              text: "$label ",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            TextSpan(
              text: value,
              style: const TextStyle(color: Color(0xFF6B7280)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String text;
  final Color textColor;
  final Color background;
  final bool isConfirm;
  final bool shadow;
  final ServiceModel service;
  final int userId;

  const _ActionButton({
    required this.text,
    required this.textColor,
    required this.background,
    required this.isConfirm,
    this.shadow = false,
    required this.service,
    required this.userId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pop(context);
          if (isConfirm) {
            final now = DateTime.now();
            final expectedDate = now.add(const Duration(days: 7));
            final request = RequestModel(
              userId: userId,
              serviceId: service.id!,
              status: 'pending',
              requestDate: now.toIso8601String(),
              expectedDate: expectedDate.toIso8601String(),
            );
            context.read<RequestCubit>().createRequest(request);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AfterReq()),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: background,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: shadow
                ? const BorderSide(color: Color(0xFFE5E7EB), width: 1)
                : BorderSide.none,
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }
}

