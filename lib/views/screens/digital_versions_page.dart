import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/cubit/document_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../i18n/app_localizations.dart';
import '../../data/models/document_model.dart';
import '../../data/models/digital_document_model.dart';
import '../../data/repo/document_repository.dart';
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
    final documentCubit = context.read<DocumentCubit>();
    final documentRepository = context.read<DocumentRepository>();
    final localizations = AppLocalizations.of(context)!;
    
    showDialog(
      context: context,
      builder: (context) {
        return FutureBuilder<List<DocumentModel>>(
          future: documentRepository.getAllDocumentTypes(),
          builder: (context, snapshot) {
            List<DocumentModel> docTypes = snapshot.data ?? [];
            final isLoading = snapshot.connectionState == ConnectionState.waiting;

            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: Text(
                localizations.isArabic ? 'اختر نوع الوثيقة للرفع' : 'Choisir le type de document',
                style: const TextStyle(fontFamily: 'Cairo', fontWeight: FontWeight.bold, color: Color(0xFF2563EB)),
                textAlign: TextAlign.center,
              ),
              content: isLoading || docTypes.isEmpty
                  ? const SizedBox(
                      height: 100,
                      child: Center(child: CircularProgressIndicator()))
                  : SizedBox(
                      width: double.maxFinite,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: docTypes.length,
                        separatorBuilder: (context, index) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final docType = docTypes[index];
                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            leading: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF0F7FF),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.description_outlined, color: Color(0xFF2563EB)),
                            ),
                            title: Text(
                              localizations.isArabic ? docType.name.replaceAll('Certificate', 'شهادة') : docType.name, // Simple localization fallback
                              style: const TextStyle(fontFamily: 'Cairo', fontSize: 14),
                            ),
                            trailing: const Icon(Icons.chevron_right, size: 18),
                            onTap: () async {
                              Navigator.pop(context);
                              final file = await FilePickerHelper.pickDocument();
                              if (file != null && file.path != null) {
                                documentCubit.uploadAndSaveDigitalDocument(
                                  userId: userId,
                                  documentId: docType.id!, // Pass Document ID
                                  file: File(file.path!),
                                );
                              }
                            },
                          );
                        },
                      ),
                    ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    localizations.isArabic ? 'إلغاء' : 'Annuler',
                    style: const TextStyle(fontFamily: 'Cairo', color: Colors.grey),
                  ),
                ),
              ],
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
            // floatingActionButton: Removed as per user request (read-only admin data)
            body: BlocListener<DocumentCubit, DocumentState>(
              listener: (context, state) {
                if (state is DocumentOperationSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.message),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              child: BlocBuilder<DocumentCubit, DocumentState>(
                builder: (context, state) {
                  if (state is DocumentLoading || state is DocumentUploading || state is DocumentFileUploading) {
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
                      final document = item['document'] as DigitalDocumentModel;
                      final docType = item['documentType'] as DocumentModel?;
                      final issuedDate = DateTime.parse(document.issuedDate);
                      final typeName = docType != null
                          ? (localizations.isArabic && docType.name == 'Birth Certificate' ? 'شهادة ميلاد' : docType.name)
                          : localizations.digitalDocument;
                      final subtitle = docType != null
                          ? '${typeName} - ${DateFormat('yyyy', localizations.locale.languageCode).format(issuedDate)}'
                          : DateFormat('yyyy', localizations.locale.languageCode).format(issuedDate);

                      return ListItem(
                        title: typeName,
                        subtitle: subtitle,
                        onTap: () async {
                          String filePath = document.filePath.trim();
                          if (filePath.isEmpty) return;

                          if (filePath.startsWith('/documents/') || filePath.contains('mock-storage.com')) {
                            filePath = 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf';
                          }
                          
                          final encodedPath = filePath.replaceAll(' ', '%20');
                          final Uri url = Uri.parse(encodedPath);
                          
                          try {
                            bool launched = await launchUrl(url, mode: LaunchMode.platformDefault);
                            if (!launched) {
                              await launchUrl(url, mode: LaunchMode.externalApplication);
                            }
                          } catch (e) {
                            debugPrint('URL Launch Failure: $e');
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
                          } catch (e) {
                            debugPrint('Download Failure: $e');
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
