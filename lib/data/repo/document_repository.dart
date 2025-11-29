import '../database/database_helper.dart';
import '../models/digital_document_model.dart';
import '../models/service_model.dart';

class DocumentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<DigitalDocumentModel>> getDigitalDocumentsByUserId(int userId) async {
    return await _dbHelper.getDigitalDocumentsByUserId(userId);
  }

  Future<int> createDigitalDocument(DigitalDocumentModel doc) async {
    return await _dbHelper.insertDigitalDocument(doc);
  }

  Future<List<Map<String, dynamic>>> getDigitalDocumentsWithService(int userId) async {
    final documents = await getDigitalDocumentsByUserId(userId);
    final result = <Map<String, dynamic>>[];

    for (final doc in documents) {
      final service = await _dbHelper.getServiceById(doc.serviceId);
      result.add({
        'document': doc,
        'service': service,
      });
    }

    return result;
  }
}

