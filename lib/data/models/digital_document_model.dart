import 'package:equatable/equatable.dart';

class DigitalDocumentModel extends Equatable {
  final int? id;
  final int userId;
  final int documentId;
  final String filePath;
  final String issuedDate;
  final String? expiresOn;
  final int isValid; // 0 or 1

  const DigitalDocumentModel({
    this.id,
    required this.userId,
    required this.documentId,
    required this.filePath,
    required this.issuedDate,
    this.expiresOn,
    required this.isValid,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'document_id': documentId,
      'file_path': filePath,
      'issued_date': issuedDate,
      'expires_on': expiresOn,
      'is_valid': isValid,
    };
  }

  factory DigitalDocumentModel.fromMap(Map<String, dynamic> map) {
    return DigitalDocumentModel(
      id: map['id'] as int?,
      userId: map['user_id'] as int,
      documentId: map['document_id'] as int,
      filePath: map['file_path'] as String,
      issuedDate: map['issued_date'] as String,
      expiresOn: map['expires_on'] as String?,
      isValid: map['is_valid'] as int,
    );
  }

  @override
  List<Object?> get props => [id, userId, documentId, filePath, issuedDate, expiresOn, isValid];
}


