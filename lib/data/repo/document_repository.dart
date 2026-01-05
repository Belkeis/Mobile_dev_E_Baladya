import '../database/database_helper.dart';
import '../models/digital_document_model.dart';

/// Repository for document-related data operations
/// Follows clean architecture principles by separating data layer from business logic
class DocumentRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  /// Fetch all documents for a specific user
  Future<List<DigitalDocumentModel>> getDigitalDocumentsByUserId(int userId) async {
    try {
      return await _dbHelper.getDigitalDocumentsByUserId(userId);
    } catch (e) {
      throw RepositoryException('Failed to fetch documents: ${e.toString()}');
    }
  }

  /// Get a single document by ID
  Future<DigitalDocumentModel?> getDocumentById(int documentId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'digital_documents',
        where: 'id = ?',
        whereArgs: [documentId],
      );
      if (maps.isEmpty) return null;
      return DigitalDocumentModel.fromMap(maps.first);
    } catch (e) {
      throw RepositoryException('Failed to fetch document: ${e.toString()}');
    }
  }

  /// Create a new document
  Future<int> createDigitalDocument(DigitalDocumentModel doc) async {
    try {
      return await _dbHelper.insertDigitalDocument(doc);
    } catch (e) {
      throw RepositoryException('Failed to create document: ${e.toString()}');
    }
  }

  /// Update an existing document
  Future<int> updateDigitalDocument(DigitalDocumentModel doc) async {
    try {
      final db = await _dbHelper.database;
      return await db.update(
        'digital_documents',
        doc.toMap(),
        where: 'id = ?',
        whereArgs: [doc.id],
      );
    } catch (e) {
      throw RepositoryException('Failed to update document: ${e.toString()}');
    }
  }

  /// Delete a document by ID
  Future<int> deleteDigitalDocument(int documentId) async {
    try {
      final db = await _dbHelper.database;
      return await db.delete(
        'digital_documents',
        where: 'id = ?',
        whereArgs: [documentId],
      );
    } catch (e) {
      throw RepositoryException('Failed to delete document: ${e.toString()}');
    }
  }

  /// Search documents by service ID
  Future<List<DigitalDocumentModel>> searchByServiceId(int userId, int serviceId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'digital_documents',
        where: 'user_id = ? AND service_id = ?',
        whereArgs: [userId, serviceId],
        orderBy: 'issued_date DESC',
      );
      return maps.map((map) => DigitalDocumentModel.fromMap(map)).toList();
    } catch (e) {
      throw RepositoryException('Failed to search documents: ${e.toString()}');
    }
  }

  /// Filter valid documents
  Future<List<DigitalDocumentModel>> getValidDocuments(int userId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'digital_documents',
        where: 'user_id = ? AND is_valid = ?',
        whereArgs: [userId, 1],
        orderBy: 'issued_date DESC',
      );
      return maps.map((map) => DigitalDocumentModel.fromMap(map)).toList();
    } catch (e) {
      throw RepositoryException('Failed to filter documents: ${e.toString()}');
    }
  }

  /// Get documents with their associated service information
  Future<List<Map<String, dynamic>>> getDigitalDocumentsWithService(int userId) async {
    try {
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
    } catch (e) {
      throw RepositoryException('Failed to fetch documents with services: ${e.toString()}');
    }
  }
}

/// Custom exception for repository operations
class RepositoryException implements Exception {
  final String message;
  RepositoryException(this.message);

  @override
  String toString() => message;
}
