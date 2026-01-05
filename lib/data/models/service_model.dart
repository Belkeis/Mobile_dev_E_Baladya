import 'package:equatable/equatable.dart';

class ServiceModel extends Equatable {
  final int? id;
  final String name;
  final String description;
  final double fee;
  final String processingTime;

  const ServiceModel({
    this.id,
    required this.name,
    required this.description,
    required this.fee,
    required this.processingTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'fee': fee,
      'processing_time': processingTime,
    };
  }

  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String,
      fee: (map['fee'] as num).toDouble(),
      processingTime: map['processing_time'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, description, fee, processingTime];
}


