import '../database/database_helper.dart';
import '../models/service_model.dart';
import '../models/document_model.dart';

class ServiceRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<List<ServiceModel>> getAllServices() async {
    return await _dbHelper.getAllServices();
  }

  Future<ServiceModel?> getServiceById(int id) async {
    return await _dbHelper.getServiceById(id);
  }

  Future<List<DocumentModel>> getRequiredDocuments(int serviceId) async {
    return await _dbHelper.getDocumentsByServiceId(serviceId);
  }
}

