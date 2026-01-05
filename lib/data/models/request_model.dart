import 'package:equatable/equatable.dart';

class RequestModel extends Equatable {
  final int? id;
  final int userId;
  final int serviceId;
  final String status; // pending, approved, rejected, ready
  final String requestDate;
  final String expectedDate;
  final String? notes;

  const RequestModel({
    this.id,
    required this.userId,
    required this.serviceId,
    required this.status,
    required this.requestDate,
    required this.expectedDate,
    this.notes,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'status': status,
      'request_date': requestDate,
      'expected_date': expectedDate,
      'notes': notes,
    };
  }

  factory RequestModel.fromMap(Map<String, dynamic> map) {
    return RequestModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      serviceId: map['service_id'] as int,
      status: map['status'] as String,
      requestDate: map['request_date'] as String,
      expectedDate: map['expected_date'] as String,
      notes: map['notes'] as String?,
    );
  }

  RequestModel copyWith({
    int? id,
    int? userId,
    int? serviceId,
    String? status,
    String? requestDate,
    String? expectedDate,
    String? notes,
  }) {
    return RequestModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      status: status ?? this.status,
      requestDate: requestDate ?? this.requestDate,
      expectedDate: expectedDate ?? this.expectedDate,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [id, userId, serviceId, status, requestDate, expectedDate, notes];
}


