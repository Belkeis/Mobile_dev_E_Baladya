part of 'service_cubit.dart';

abstract class ServiceState extends Equatable {
  const ServiceState();

  @override
  List<Object?> get props => [];
}

class ServiceInitial extends ServiceState {}

class ServiceLoading extends ServiceState {}

class ServiceLoaded extends ServiceState {
  final List<ServiceModel> services;

  const ServiceLoaded(this.services);

  @override
  List<Object?> get props => [services];
}

class ServiceDetailsLoaded extends ServiceState {
  final ServiceModel service;
  final List<DocumentModel> requiredDocuments;
  final List<ServiceModel> allServices; // Keep all services available

  const ServiceDetailsLoaded(this.service, this.requiredDocuments, this.allServices);

  @override
  List<Object?> get props => [service, requiredDocuments, allServices];
}

class RequiredDocumentsLoaded extends ServiceState {
  final List<DocumentModel> documents;
  final List<ServiceModel> allServices; // Keep all services available

  const RequiredDocumentsLoaded(this.documents, this.allServices);

  @override
  List<Object?> get props => [documents, allServices];
}

class ServiceError extends ServiceState {
  final String message;

  const ServiceError(this.message);

  @override
  List<Object?> get props => [message];
}