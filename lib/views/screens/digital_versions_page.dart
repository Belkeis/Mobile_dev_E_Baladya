import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/cubit/document_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
import '../../i18n/app_localizations.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';

class DigitalVersionsPage extends StatelessWidget {
  const DigitalVersionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, authState) {
        if (authState is AuthAuthenticated) {
          context.read<DocumentCubit>().loadDigitalDocuments(authState.user.id!);
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: CustomAppBar(
            onArrowTap: () {
              Navigator.pop(context);
            },
          ),
          body: BlocBuilder<DocumentCubit, DocumentState>(
            builder: (context, state) {
              if (state is DocumentLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (state is DocumentError) {
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

              List<Map<String, dynamic>> documentsWithService = [];
              if (state is DocumentsLoaded) {
                documentsWithService = state.documentsWithService;
              }

              final localizations = AppLocalizations.of(context)!;
              
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
                    onTap: () {
                      // In a real app, this would open/view the PDF
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(localizations.documentWillOpenSoon),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  );
                }).toList(),
              );
            },
          ),
        );
      },
    );
  }
}
