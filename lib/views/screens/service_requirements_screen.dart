import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../data/models/service_model.dart';
import '../widgets/custom_app_bar.dart';

class ServiceRequirementsScreen extends StatefulWidget {
  final ServiceModel service;

  const ServiceRequirementsScreen({super.key, required this.service});

  @override
  State<ServiceRequirementsScreen> createState() =>
      _ServiceRequirementsScreenState();
}

class _ServiceRequirementsScreenState extends State<ServiceRequirementsScreen> {
  @override
  void initState() {
    super.initState();
    // Load required documents once when the screen appears to avoid repeated calls
    if (widget.service.id != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.read<ServiceCubit>().loadRequiredDocuments(widget.service.id!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        List requiredDocuments = [];
        if (state is RequiredDocumentsLoaded) {
          requiredDocuments = state.documents;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: CustomAppBar(
            onArrowTap: () {
              Navigator.pop(context);
            },
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.service.name,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF2563EB),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  widget.service.description,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 14,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
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
                          children: requiredDocuments.isEmpty
                              ? [
                                  const Text(
                                    'لا توجد وثائق مطلوبة',
                                    style: TextStyle(
                                      fontFamily: 'Cairo',
                                      fontSize: 14,
                                      color: Color(0xFF6B7280),
                                    ),
                                  ),
                                ]
                              : requiredDocuments
                                  .map<Widget>(
                                      (doc) => _buildRequirement(doc.name))
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
                    color: const Color(0xFFF0F7FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        color: Color(0xFF2563EB),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'يرجى التأكد من إحضار جميع الوثائق المطلوبة عند زيارة البلدية.',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 13,
                            color: Color(0xFF2563EB),
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
        );
      },
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
