import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/service_repository.dart';
import '../../data/models/service_model.dart';
import '../../data/models/document_model.dart';

part 'service_state.dart';

class ServiceCubit extends Cubit<ServiceState> {
  final ServiceRepository _serviceRepository;
  List<ServiceModel>? _cachedServices; // Cache services

  ServiceCubit(this._serviceRepository) : super(ServiceInitial()) {
    loadServices();
  }

  Future<void> loadServices() async {
    emit(ServiceLoading());
    try {
      final services = await _serviceRepository.getAllServices();
      _cachedServices = services; // Cache the services
      emit(ServiceLoaded(services));
    } catch (e) {
      emit(ServiceError('حدث خطأ أثناء تحميل الخدمات'));
    }
  }

  Future<void> loadServiceDetails(int serviceId) async {
    emit(ServiceLoading());
    try {
      final service = await _serviceRepository.getServiceById(serviceId);
      if (service != null) {
        final documents = await _serviceRepository.getRequiredDocuments(serviceId);
        // Pass cached services along with details
        emit(ServiceDetailsLoaded(service, documents, _cachedServices ?? []));
      } else {
        emit(ServiceError('الخدمة غير موجودة'));
      }
    } catch (e) {
      emit(ServiceError('حدث خطأ أثناء تحميل تفاصيل الخدمة'));
    }
  }

  Future<void> loadRequiredDocuments(int serviceId) async {
    try {
      final documents = await _serviceRepository.getRequiredDocuments(serviceId);
      emit(RequiredDocumentsLoaded(documents, _cachedServices ?? []));
    } catch (e) {
      emit(ServiceError('حدث خطأ أثناء تحميل الوثائق المطلوبة'));
    }
  }
}