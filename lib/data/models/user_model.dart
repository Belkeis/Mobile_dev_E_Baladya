import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final int? id;
  final String fullName;
  final String email;
  final String? phone;
  final String nationalId;
  final String password;
  final String createdAt;

  const UserModel({
    this.id,
    required this.fullName,
    required this.email,
    this.phone,
    required this.nationalId,
    required this.password,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'national_id': nationalId,
      'password': password,
      'created_at': createdAt,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as int?,
      fullName: map['full_name'] as String,
      email: map['email'] as String,
      phone: map['phone'] as String?,
      nationalId: map['national_id'] as String,
      password: map['password'] as String,
      createdAt: map['created_at'] as String,
    );
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? nationalId,
    String? password,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      nationalId: nationalId ?? this.nationalId,
      password: password ?? this.password,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, fullName, email, phone, nationalId, password, createdAt];
}


