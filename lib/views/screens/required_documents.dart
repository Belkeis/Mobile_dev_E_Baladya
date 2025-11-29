import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../data/models/service_model.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import 'service_requirements_screen.dart';

class MyRequiredDocumentsPage extends StatelessWidget {
  const MyRequiredDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Reload services when screen appears
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCubit>().loadServices();
    });

    return BlocBuilder<ServiceCubit, ServiceState>(
      builder: (context, state) {
        if (state is ServiceLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        List<ServiceModel> services = [];
        if (state is ServiceLoaded) {
          services = state.services;
        } else if (state is ServiceDetailsLoaded || state is RequiredDocumentsLoaded) {
          // If state is in details mode, reload services
          context.read<ServiceCubit>().loadServices();
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
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
                      builder: (context) => ServiceRequirementsScreen(service: service),
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
