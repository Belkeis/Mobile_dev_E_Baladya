import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart' hide TextDirection;
import '../../logic/cubit/request_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../data/models/request_model.dart';
import '../../data/models/service_model.dart';
import '../widgets/custom_app_bar.dart';
import '../../i18n/app_localizations.dart';
import '../../data/models/request_document_model.dart';

class RequestTrackingScreen extends StatelessWidget {
  const RequestTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          context.read<RequestCubit>().loadRequests(authState.user.id!);
        } else if (authState is AuthInitial || authState is AuthLoading) {
          // Auto-login if not authenticated
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.read<AuthCubit>().login('ahmed@example.com', 'password123');
          });
        }

        if (authState is! AuthAuthenticated) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: CustomAppBar(
              onArrowTap: () {
                Navigator.pop(context);
              },
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        final localizations = AppLocalizations.of(context)!;
        return Directionality(
          textDirection: localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: CustomAppBar(
              onArrowTap: () {
                Navigator.pop(context);
              },
            ),
            body: BlocBuilder<RequestCubit, RequestState>(
              builder: (context, state) {
                if (state is RequestLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is RequestError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  );
                }

                List<Map<String, dynamic>> requestsWithService = [];
                if (state is RequestsLoaded) {
                  requestsWithService = state.requestsWithService;
                }

                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(25),
                        child: Column(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.trackingTitle,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 24,
                                fontWeight: FontWeight.normal,
                                color: Color(0xFF2563EB),
                              ),
                            ),
                            const SizedBox(height: 40),
                            if (requestsWithService.isEmpty)
                              Padding(
                                padding: const EdgeInsets.all(40.0),
                                child: Text(
                                  AppLocalizations.of(context)!.noRequests,
                                  style: const TextStyle(
                                    fontFamily: 'Cairo',
                                    fontSize: 16,
                                    color: Color(0xFF6B7280),
                                  ),
                                ),
                              )
                            else
                              ...requestsWithService.map((item) {
                                final request = item['request'] as RequestModel;
                                final service = item['service'] as ServiceModel?;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: _buildRequestCard(
                                    request: request,
                                    service: service,
                                    context: context,
                                  ),
                                );
                              }),
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
                          onPressed: () {
                            Navigator.pushNamed(context, '/online-requests');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2563EB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            AppLocalizations.of(context)!.newRequest,
                            style: const TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildRequestCard({
    required RequestModel request,
    ServiceModel? service,
    required BuildContext context,
  }) {
    final localizations = AppLocalizations.of(context)!;

    // Determine status colors
    Color statusColor;
    Color statusTextColor;
    String statusText;
    IconData icon;
    Color iconColor;
    Color iconBgColor;

    switch (request.status) {
      case 'pending':
        statusColor = const Color(0xFFFEF3C7);
        statusTextColor = const Color(0xFF92400E);
        statusText = localizations.pending;
        icon = Icons.pending;
        iconColor = const Color(0xFFF59E0B);
        iconBgColor = const Color(0xFFFEF3C7);
        break;
      case 'approved':
        statusColor = const Color(0xFFDBEAFE);
        statusTextColor = const Color(0xFF1E40AF);
        statusText = localizations.approved;
        icon = Icons.check_circle;
        iconColor = const Color(0xFF2563EB);
        iconBgColor = const Color(0xFFDBEAFE);
        break;
      case 'ready':
        statusColor = const Color(0xFFD1FAE5);
        statusTextColor = const Color(0xFF065F46);
        statusText = localizations.ready;
        icon = Icons.done_all;
        iconColor = const Color(0xFF059669);
        iconBgColor = const Color(0xFFD1FAE5);
        break;
      case 'rejected':
        statusColor = const Color(0xFFFEE2E2);
        statusTextColor = const Color(0xFF991B1B);
        statusText = localizations.rejected;
        icon = Icons.cancel;
        iconColor = const Color(0xFFDC2626);
        iconBgColor = const Color(0xFFFEE2E2);
        break;
      default:
        statusColor = const Color(0xFFF3F4F6);
        statusTextColor = const Color(0xFF6B7280);
        statusText = request.status;
        icon = Icons.info;
        iconColor = const Color(0xFF6B7280);
        iconBgColor = const Color(0xFFF3F4F6);
    }

    final requestDate = DateTime.parse(request.requestDate);
    final expectedDate = DateTime.parse(request.expectedDate);
    final now = DateTime.now();
    final daysRemaining = expectedDate.difference(now).inDays;

    return Container(
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  service?.name ?? AppLocalizations.of(context)!.service,
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Color(0xFF111827),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        statusText,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: statusTextColor,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context)!.requestStatus,
                      style: const TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '${AppLocalizations.of(context)!.remainingTime} ${daysRemaining > 0 ? '$daysRemaining ${AppLocalizations.of(context)!.locale.languageCode == 'ar' ? 'أيام' : 'jours'}' : (AppLocalizations.of(context)!.locale.languageCode == 'ar' ? 'منتهي' : 'Expiré')}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 4),
                Text(
                  '${AppLocalizations.of(context)!.requestDate} ${DateFormat('yyyy/MM/dd', AppLocalizations.of(context)!.locale.languageCode).format(requestDate)}',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 12),
                Align(
                  alignment: localizations.isArabic ? Alignment.bottomLeft : Alignment.bottomRight,
                  child: FutureBuilder<List<RequestDocumentModel>>(
                    future: context.read<RequestCubit>().repository.getRequestDocuments(request.id!),
                    builder: (context, snapshot) {
                      final count = snapshot.data?.length ?? 0;
                      return TextButton.icon(
                        onPressed: () => _showAttachedDocuments(context, request.id!),
                        icon: const Icon(Icons.attach_file, size: 16),
                        label: Text(
                          localizations.isArabic 
                            ? "مشاهدة المرفقات ${count > 0 ? "($count)" : ""}" 
                            : "Voir les documents ${count > 0 ? "($count)" : ""}",
                          style: const TextStyle(fontFamily: 'Cairo', fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF2563EB),
                          backgroundColor: count > 0 ? const Color(0xFFDBEAFE) : const Color(0xFFEFF6FF),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      );
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAttachedDocuments(BuildContext context, int requestId) {
    final localizations = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Directionality(
          textDirection: localizations.isArabic ? TextDirection.rtl : TextDirection.ltr,
          child: FutureBuilder<List<RequestDocumentModel>>(
            future: context.read<RequestCubit>().repository.getRequestDocuments(requestId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                  height: 200,
                  child: Center(child: CircularProgressIndicator()),
                );
              }

              if (snapshot.hasError) {
                return Container(
                  padding: const EdgeInsets.all(25),
                  child: Text("Error: ${snapshot.error}"),
                );
              }

              final List<RequestDocumentModel> docs = snapshot.data ?? [];
              return Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.isArabic
                          ? "الوثائق المرفقة للطلب #$requestId"
                          : "Documents pour la demande #$requestId",
                      style: const TextStyle(fontFamily: 'Cairo', fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                    ),
                    const SizedBox(height: 15),
                    if (docs.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            localizations.isArabic ? "لا توجد وثائق مرفقة بعد." : "Aucun document lié pour le moment.",
                            style: const TextStyle(fontFamily: 'Cairo', color: Color(0xFF6B7280)),
                          ),
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: docs.length,
                          separatorBuilder: (context, index) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final doc = docs[index];
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: const Icon(Icons.file_present, color: Colors.blue),
                              title: Text(
                                doc.fileName,
                                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text(
                                doc.fileUrl,
                                style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              onTap: () {
                                // Optional: Open document if needed
                              },
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}