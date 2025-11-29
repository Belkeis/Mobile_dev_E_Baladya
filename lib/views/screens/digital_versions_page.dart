import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../logic/cubit/document_cubit.dart';
import '../../logic/cubit/auth_cubit.dart';
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

              if (documentsWithService.isEmpty) {
                return GenericListPage(
                  title: 'الوثائق الرقمية',
                  subtitle:
                      'الوصول إلى جميع الوثائق الرسمية الرقمية بسهولة وتنزيلها مباشرة من هذه الصفحة',
                  showDownloadIcon: true,
                  showTrailingArrow: false,
                  items: const [
                    ListItem(
                      title: 'لا توجد وثائق رقمية',
                      subtitle: 'سيتم عرض الوثائق الرقمية هنا عند توفرها',
                    ),
                  ],
                );
              }

              return GenericListPage(
                title: 'الوثائق الرقمية',
                subtitle:
                    'الوصول إلى جميع الوثائق الرسمية الرقمية بسهولة وتنزيلها مباشرة من هذه الصفحة',
                showDownloadIcon: true,
                showTrailingArrow: false,
                items: documentsWithService.map((item) {
                  final document = item['document'];
                  final service = item['service'];
                  final issuedDate = DateTime.parse(document.issuedDate);
                  final subtitle = service != null
                      ? '${service.name} - ${DateFormat('yyyy', 'ar').format(issuedDate)}'
                      : DateFormat('yyyy', 'ar').format(issuedDate);

                  return ListItem(
                    title: service?.name ?? 'وثيقة رقمية',
                    subtitle: subtitle,
                    onTap: () {
                      // In a real app, this would open/view the PDF
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('سيتم فتح الوثيقة قريباً'),
                          duration: Duration(seconds: 2),
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
