import '../database/database_helper.dart';
import '../models/request_model.dart';
import '../models/request_document_model.dart';

class RequestRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> createRequest(RequestModel request) async {
    return await _dbHelper.insertRequest(request);
  }

  Future<List<RequestModel>> getRequestsByUserId(int userId) async {
    return await _dbHelper.getRequestsByUserId(userId);
  }

  Future<RequestModel?> getRequestById(int id) async {
    return await _dbHelper.getRequestById(id);
  }

  Future<int> updateRequest(RequestModel request) async {
    return await _dbHelper.updateRequest(request);
  }

  Future<List<Map<String, dynamic>>> getRequestsWithService(int userId) async {
    final requests = await getRequestsByUserId(userId);
    final result = <Map<String, dynamic>>[];

    for (final request in requests) {
      final service = await _dbHelper.getServiceById(request.serviceId);
      result.add({
        'request': request,
        'service': service,
      });
    }

    return result;
  }

  Future<int> linkDocumentToRequest(RequestDocumentModel doc) async {
    return await _dbHelper.insertRequestDocument(doc);
  }

  Future<List<RequestDocumentModel>> getRequestDocuments(int requestId) async {
    return await _dbHelper.getDocumentsByRequestId(requestId);
  }

  Future<List<RequestModel>> getActiveRequestsByService(int userId, int serviceId) async {
    return await _dbHelper.getActiveRequestsByService(userId, serviceId);
  }
}
