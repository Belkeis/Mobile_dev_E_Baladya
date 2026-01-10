import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../logic/cubit/service_cubit.dart';
import '../../data/models/service_model.dart';
import '../widgets/generic_list_page.dart';
import '../widgets/custom_app_bar.dart';
import '../../i18n/app_localizations.dart';
import 'service_requirements_screen.dart';

class MyRequiredDocumentsPage extends StatefulWidget {
  const MyRequiredDocumentsPage({super.key});

  @override
  State<MyRequiredDocumentsPage> createState() =>
      _MyRequiredDocumentsPageState();
}

class _MyRequiredDocumentsPageState extends State<MyRequiredDocumentsPage>
    with RouteAware {
  RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();
  bool _firstLoad = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    if (route is PageRoute) {
      routeObserver.subscribe(this, route);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    // Called when the route is pushed onto the stack
    _loadServices();
  }

  @override
  void didPopNext() {
    // Called when a route is popped and this route becomes the top route
    _loadServices();
  }

  void _loadServices() {
    // Debounce to prevent multiple calls
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ServiceCubit>().loadServices();
    });
  }

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
      builder: (context, state) {
        // ... rest of your build method remains the same
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
            title: AppLocalizations.of(context)!.requiredDocumentsTitle,
            subtitle: AppLocalizations.of(context)!.requiredDocumentsSubtitle,
            showTrailingArrow: true,
            items: services.map((service) {
              final localizations = AppLocalizations.of(context)!;
              return ListItem(
                title: localizations.translateServiceName(service.name),
                subtitle: localizations.translateServiceDescription(service.description),
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