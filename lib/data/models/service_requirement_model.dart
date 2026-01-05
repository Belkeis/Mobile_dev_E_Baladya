import 'package:equatable/equatable.dart';

class ServiceRequirementModel extends Equatable {
  final int? id;
  final int serviceId;
  final int documentId;

  const ServiceRequirementModel({
    this.id,
    required this.serviceId,
    required this.documentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'service_id': serviceId,
      'document_id': documentId,
    };
  }

  factory ServiceRequirementModel.fromMap(Map<String, dynamic> map) {
    return ServiceRequirementModel(
      id: map['id'] as int?,
      serviceId: map['service_id'] as int,
      documentId: map['document_id'] as int,
    );
  }

  @override
  List<Object?> get props => [id, serviceId, documentId];
}



