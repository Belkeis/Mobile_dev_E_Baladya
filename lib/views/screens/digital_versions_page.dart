import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/cubit/document_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../i18n/app_localizations.dart';
import '../../data/models/service_model.dart';
import '../../utils/file_picker_helper.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';

class DigitalVersionsPage extends StatefulWidget {
  const DigitalVersionsPage({super.key});

  @override
  State<DigitalVersionsPage> createState() => _DigitalVersionsPageState();
}

class _DigitalVersionsPageState extends State<DigitalVersionsPage> {
  @override
  void initState() {
    super.initState();
    // Load services once for the upload dialog
    context.read<ServiceCubit>().loadServices();
    
    // Initial load of documents if user is already authenticated
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      context.read<DocumentCubit>().loadDigitalDocuments(authState.user.id!);
    }
  }

  void _showUploadDialog(BuildContext context, int userId) {
    final serviceCubit = context.read<ServiceCubit>();
    final documentCubit = context.read<DocumentCubit>();
    final localizations = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) {
        return BlocBuilder<ServiceCubit, ServiceState>(
          builder: (context, state) {
            List<ServiceModel> services = [];
            if (state is ServiceLoaded) {
              services = state.services;
            }

            return AlertDialog(
              title: Text(
                localizations.digitalDocumentsTitle,
                style: const TextStyle(fontFamily: 'Cairo'),
              ),
              content: services.isEmpty
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.maxFinite,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: services.length,
                        itemBuilder: (context, index) {
                          final service = services[index];
                          return ListTile(
                            title: Text(
                              localizations.translateServiceName(service.name),
                              style: const TextStyle(fontFamily: 'Cairo'),
                            ),
                            onTap: () async {
                              Navigator.pop(context);
                              final file = await FilePickerHelper.pickDocument();
                              if (file != null && file.path != null) {
                                documentCubit.uploadAndSaveDigitalDocument(
                                  userId: userId,
                                  serviceId: service.id!,
                                  file: File(file.path!),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, authState) {
        if (authState is AuthAuthenticated) {
          context.read<DocumentCubit>().loadDigitalDocuments(authState.user.id!);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, authState) {
          return Scaffold(
            backgroundColor: const Color(0xFFF9FAFB),
            appBar: CustomAppBar(
              onArrowTap: () {
                Navigator.pop(context);
              },
            ),
            floatingActionButton: authState is AuthAuthenticated
                ? FloatingActionButton(
                    onPressed: () => _showUploadDialog(
                      context,
                      (authState as AuthAuthenticated).user.id!,
                    ),
                    backgroundColor: const Color(0xFF2563EB),
                    child: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
                  )
                : null,
            body: BlocListener<DocumentCubit, DocumentState>(
              listener: (context, state) {
                if (state is DocumentOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: BlocBuilder<DocumentCubit, DocumentState>(
                builder: (context, state) {
                  if (state is DocumentLoading || state is DocumentUploading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is DocumentError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                            const SizedBox(height: 16),
                            Text(
                              state.message,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 16,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                if (authState is AuthAuthenticated) {
                                  context.read<DocumentCubit>().loadDigitalDocuments(authState.user.id!);
                                }
                              },
                              child: Text(localizations.isArabic ? 'إعادة المحاولة' : 'Réessayer'),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  List<Map<String, dynamic>> documentsWithService = [];
                  if (state is DocumentsLoaded) {
                    documentsWithService = state.documentsWithService;
                  }

                  if (documentsWithService.isEmpty) {
                    return GenericListPage(
                      title: localizations.digitalDocumentsTitle,
                      subtitle: localizations.digitalDocumentsSubtitle,
                      showDownloadIcon: true,
                      showTrailingArrow: false,
                      items: [
                        ListItem(
                          title: localizations.noDigitalDocuments,
                          subtitle: localizations.digitalDocumentsSubtitle,
                        ),
                      ],
                    );
                  }

                  return GenericListPage(
                    title: localizations.digitalDocumentsTitle,
                    subtitle: localizations.digitalDocumentsSubtitle,
                    showDownloadIcon: true,
                    showTrailingArrow: false,
                    items: documentsWithService.map((item) {
                      final document = item['document'];
                      final service = item['service'];
                      final issuedDate = DateTime.parse(document.issuedDate);
                      final serviceName = service != null
                          ? localizations.translateServiceName(service.name)
                          : localizations.digitalDocument;
                      final subtitle = service != null
                          ? '${serviceName} - ${DateFormat('yyyy', localizations.locale.languageCode).format(issuedDate)}'
                          : DateFormat('yyyy', localizations.locale.languageCode).format(issuedDate);

                      return ListItem(
                        title: serviceName,
                        subtitle: subtitle,
                        onTap: () async {
                          String filePath = document.filePath.trim();
                          if (filePath.isEmpty) return;

                          // For testing: Use a reliable public PDF if it's a mock path
                          if (filePath.startsWith('/documents/') || filePath.contains('mock-storage.com')) {
                            filePath = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
                          }
                          
                          // Ensure valid URL encoding
                          final encodedPath = filePath.replaceAll(' ', '%20');
                          final Uri url = Uri.parse(encodedPath);
                          
                          try {
                            // Try in-app browser first (better UX)
                            bool launched = await launchUrl(url, mode: LaunchMode.platformDefault);
                            if (!launched) {
                              // Fallback to external browser
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          } catch (e) {
                            debugPrint('URL Launch Failure: $e');
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${localizations.errorMessage(e.toString())}'),
                                  backgroundColor: Colors.redAccent,
                                  duration: const Duration(seconds: 10),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    textColor: Colors.white,
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        onDownload: () async {
                          String filePath = document.filePath.trim();
                          if (filePath.isEmpty) return;

                          if (filePath.startsWith('/documents/') || filePath.contains('mock-storage.com')) {
                            filePath = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
                          }

                          final encodedPath = filePath.replaceAll(' ', '%20');
                          final Uri url = Uri.parse(encodedPath);
                          
                          try {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(localizations.downloadDocument)),
                              );
                            }
                          } catch (e) {
                             if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('${localizations.errorMessage(e.toString())}'),
                                  backgroundColor: Colors.redAccent,
                                ),
                              );
                            }
                          }
                        },
                      );
                    }).toList(),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
