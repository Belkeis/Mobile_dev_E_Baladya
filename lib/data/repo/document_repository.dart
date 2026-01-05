import '../database/database_helper.dart';
import '../models/digital_document_model.dart';
import '../models/document_model.dart';

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

  /// Finds digital documents of a specific document type for a user
  Future<List<DigitalDocumentModel>> getDigitalDocumentsByDocumentId(int userId, int documentId) async {
    try {
      return await _dbHelper.getDigitalDocumentsByDocumentId(userId, documentId);
    } catch (e) {
      throw RepositoryException('Failed to fetch documents by type: ${e.toString()}');
    }
  }

  /// Get all available document types
  Future<List<DocumentModel>> getAllDocumentTypes() async {
    try {
      return await _dbHelper.getAllDocuments();
    } catch (e) {
      throw RepositoryException('Failed to fetch document types: ${e.toString()}');
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

  /// Search documents by document type ID
  Future<List<DigitalDocumentModel>> searchByDocumentId(int userId, int documentId) async {
    try {
      final db = await _dbHelper.database;
      final maps = await db.query(
        'digital_documents',
        where: 'user_id = ? AND document_id = ?',
        whereArgs: [userId, documentId],
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

  /// Get documents with their associated document type information
  Future<List<Map<String, dynamic>>> getDigitalDocumentsWithInfo(int userId) async {
    try {
      final documents = await getDigitalDocumentsByUserId(userId);
      final result = <Map<String, dynamic>>[];
      
      // Cache common lookups
      final allTypes = await getAllDocumentTypes();
      final typeMap = {for (var e in allTypes) e.id: e};

      for (final doc in documents) {
        final docType = typeMap[doc.documentId];
        result.add({
          'document': doc,
          'documentType': docType,
        });
      }

      if (result.isEmpty) {
        // Fallback: If DB is empty or user has no docs, RETURN DUMMY DATA as requested
        final now = DateTime.now();
        final dummyDocs = [
          // Birth Cert
          DigitalDocumentModel(
            userId: userId,
            documentId: allTypes.firstWhere((t) => t.type == 'certificate', orElse: () => allTypes.first).id!,
            filePath: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
            issuedDate: now.subtract(const Duration(days: 30)).toIso8601String(),
            isValid: 1,
            id: 991,
          ),
          // ID Card
          DigitalDocumentModel(
            userId: userId,
            documentId: allTypes.firstWhere((t) => t.type == 'copy', orElse: () => allTypes.length > 1 ? allTypes[1] : allTypes.first).id!,
            filePath: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
            issuedDate: now.subtract(const Duration(days: 100)).toIso8601String(),
            isValid: 1,
            id: 992,
          ),
           // Passport
          DigitalDocumentModel(
            userId: userId,
            documentId: allTypes.firstWhere((t) => t.type == 'passport', orElse: () => allTypes.last).id!,
            filePath: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
            issuedDate: now.subtract(const Duration(days: 20)).toIso8601String(),
            isValid: 1,
            id: 993,
          ),
        ];

        for (final doc in dummyDocs) {
           final docType = typeMap[doc.documentId] ?? (allTypes.isNotEmpty ? allTypes.first : DocumentModel(name: 'Document', type: 'unknown'));
           result.add({
             'document': doc,
             'documentType': docType,
           });
        }
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
