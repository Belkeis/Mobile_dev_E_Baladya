import 'package:equatable/equatable.dart';

class DocumentModel extends Equatable {
  final int? id;
  final String name;
  final String type;

  const DocumentModel({
    this.id,
    required this.name,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'type': type,
    };
  }

  factory DocumentModel.fromMap(Map<String, dynamic> map) {
    return DocumentModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      type: map['type'] as String,
    );
  }

  @override
  List<Object?> get props => [id, name, type];
}



