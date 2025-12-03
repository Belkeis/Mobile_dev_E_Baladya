import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../data/models/service_model.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'service_requirements_screen.dart';

class MyRequiredDocumentsPage extends StatefulWidget {
  const MyRequiredDocumentsPage({super.key});

  @override
  State<MyRequiredDocumentsPage> createState() =>
      _MyRequiredDocumentsPageState();
}

class _MyRequiredDocumentsPageState extends State<MyRequiredDocumentsPage> {
  @override
  void initState() {
    super.initState();
    // Load services once when the page is first created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCubit>().loadServices();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ServiceCubit, ServiceState>(
      buildWhen: (previous, current) {
        // Only rebuild on ServiceLoaded; ignore RequiredDocumentsLoaded to prevent cross-screen interference
        return current is ServiceLoading ||
            current is ServiceLoaded ||
            current is ServiceError;
      },
      builder: (context, state) {
        if (state is ServiceLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        List<ServiceModel> services = [];
        if (state is ServiceLoaded) {
          services = state.services;
        }

        return Scaffold(
          backgroundColor: const Color(0xFFF9FAFB),
          appBar: CustomAppBar(
            onArrowTap: () {
              Navigator.pop(context);
            },
          ),
          body: GenericListPage(
            title: 'الوثائق المطلوبة',
            subtitle:
                'تعرّف على الوثائق المطلوبة لإتمام مختلف \nالمعاملات الإدارية بسهولة.',
            showTrailingArrow: true,
            items: services.map((service) {
              return ListItem(
                title: service.name,
                subtitle: service.description,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ServiceRequirementsScreen(service: service),
                    ),
                  );
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
