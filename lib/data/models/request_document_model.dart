import 'package:equatable/equatable.dart';

class RequestDocumentModel extends Equatable {
  final int? id;
  final int requestId;
  final String fileUrl;
  final String fileName;

  const RequestDocumentModel({
    this.id,
    required this.requestId,
    required this.fileUrl,
    required this.fileName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'request_id': requestId,
      'file_url': fileUrl,
      'file_name': fileName,
    };
  }

  factory RequestDocumentModel.fromMap(Map<String, dynamic> map) {
    return RequestDocumentModel(
      id: map['id'] as int?,
      requestId: map['request_id'] as int,
      fileUrl: map['file_url'] as String,
      fileName: map['file_name'] as String,
    );
  }

  @override
  List<Object?> get props => [id, requestId, fileUrl, fileName];
}
