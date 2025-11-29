import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final int? id;
  final int userId;
  final String message;
  final String type;
  final String timestamp;
  final int read; // 0 or 1

  const NotificationModel({
    this.id,
    required this.userId,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.read,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'message': message,
      'type': type,
      'timestamp': timestamp,
      'read': read,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      message: map['message'] as String,
      type: map['type'] as String,
      timestamp: map['timestamp'] as String,
      read: map['read'] as int,
    );
  }

  NotificationModel copyWith({
    int? id,
    int? userId,
    String? message,
    String? type,
    String? timestamp,
    int? read,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      message: message ?? this.message,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      read: read ?? this.read,
    );
  }

  @override
  List<Object?> get props => [id, userId, message, type, timestamp, read];
}


