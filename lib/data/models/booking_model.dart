import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
  final int? id;
  final int userId;
  final int serviceId;
  final int? bookingTypeId; // NEW: Add booking type ID
  final String date;
  final String status; // pending, confirmed, cancelled

  const BookingModel({
    this.id,
    required this.userId,
    required this.serviceId,
    this.bookingTypeId, // NEW
    required this.date,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'service_id': serviceId,
      'booking_type_id': bookingTypeId, // NEW
      'date': date,
      'status': status,
    };
  }

  factory BookingModel.fromMap(Map<String, dynamic> map) {
    return BookingModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      serviceId: map['service_id'] as int,
      bookingTypeId: map['booking_type_id'] as int?, // NEW
      date: map['date'] as String,
      status: map['status'] as String,
    );
  }

  BookingModel copyWith({
    int? id,
    int? userId,
    int? serviceId,
    int? bookingTypeId, // NEW
    String? date,
    String? status,
  }) {
    return BookingModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      bookingTypeId: bookingTypeId ?? this.bookingTypeId, // NEW
      date: date ?? this.date,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props =>
      [id, userId, serviceId, bookingTypeId, date, status]; // Updated
}

