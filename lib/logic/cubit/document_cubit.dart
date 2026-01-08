import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/repo/document_repository.dart';
import '../../data/repo/request_repository.dart';
import '../../data/repo/service_repository.dart';
import '../../data/models/digital_document_model.dart';
import '../../data/models/request_document_model.dart';
import '../../data/models/service_model.dart';
import '../../data/models/document_model.dart';
import '../../data/services/storage_service.dart';

part 'document_state.dart';

/// DocumentCubit handles all document-related business logic and state management
class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository _documentRepository;
  final RequestRepository _requestRepository;
  final ServiceRepository _serviceRepository;
  final StorageService _storageService;
  
  // Cache for current user ID to simplify operations
  int? _currentUserId;

  DocumentCubit(
    this._documentRepository,
    this._storageService,
    this._requestRepository,
    this._serviceRepository,
  ) : super(const DocumentInitial());

  // ==========================================================================
  // CORE CRUD OPERATIONS
  // ==========================================================================

  /// Load all documents for a specific user
  Future<void> loadDocuments(int userId) async {
    _currentUserId = userId;
    emit(const DocumentsFetching());
    
    try {
      final documentsWithService = await _documentRepository.getDigitalDocumentsWithInfo(userId);
      emit(DocumentsLoaded(documentsWithService));
    } catch (e) {
      emit(DocumentFetchError(
        'حدث خطأ أثناء تحميل الوثائق الرقمية',
        exception: e,
      ));
    }
  }

  /// Create a new document
  Future<void> createDocument(DigitalDocumentModel document) async {
    emit(const DocumentCreating());
    
    try {
      final documentId = await _documentRepository.createDigitalDocument(document);
      emit(DocumentCreated(documentId, 'تم إنشاء الوثيقة بنجاح'));
      
      // Reload documents to show the new one
      await loadDocuments(document.userId);
    } catch (e) {
      emit(DocumentCreateError(
        'حدث خطأ أثناء إنشاء الوثيقة الرقمية',
        exception: e,
      ));
    }
  }

  /// Update an existing document
  Future<void> updateDocument(DigitalDocumentModel document) async {
    if (document.id == null) {
      emit(const DocumentUpdateError('معرف الوثيقة مفقود'));
      return;
    }
    
    emit(DocumentUpdating(document.id!));
    
    try {
      final rowsAffected = await _documentRepository.updateDigitalDocument(document);
      
      if (rowsAffected > 0) {
        emit(DocumentUpdated(document.id!, 'تم تحديث الوثيقة بنجاح'));
        
        // Reload documents to show updated data
        if (_currentUserId != null) {
          await loadDocuments(_currentUserId!);
        }
      } else {
        emit(const DocumentUpdateError('لم يتم العثور على الوثيقة'));
      }
    } catch (e) {
      emit(DocumentUpdateError(
        'حدث خطأ أثناء تحديث الوثيقة',
        exception: e,
      ));
    }
  }

  /// Delete a document by ID
  Future<void> deleteDocument(int documentId, int userId) async {
    emit(DocumentDeleting(documentId));
    
    try {
      final rowsAffected = await _documentRepository.deleteDigitalDocument(documentId);
      
      if (rowsAffected > 0) {
        emit(DocumentDeleted(documentId, 'تم حذف الوثيقة بنجاح'));
        
        // Reload documents to reflect deletion
        await loadDocuments(userId);
      } else {
        emit(const DocumentDeleteError('لم يتم العثور على الوثيقة'));
      }
    } catch (e) {
      emit(DocumentDeleteError(
        'حدث خطأ أثناء حذف الوثيقة',
        exception: e,
      ));
    }
  }

  /// Upload a document file to storage
  Future<void> uploadDocumentFile(File file) async {
    emit(const DocumentFileUploading());
    
    try {
      if (_currentUserId == null) {
        throw Exception('User ID not found');
      }
      
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final path = 'documents/$_currentUserId/$fileName';
      
      final downloadUrl = await _storageService.uploadFile(file, path);
      emit(DocumentFileUploaded(downloadUrl));
    } catch (e) {
      emit(DocumentUploadError(
        'حدث خطأ أثناء رفع ملف الوثيقة',
        exception: e,
      ));
    }
  }

  /// Upload a file using PlatformFile (from file_picker)
  Future<void> uploadFile(PlatformFile file) async {
    emit(const DocumentFileUploading());

    try {
      if (_currentUserId == null) {
        throw Exception('User ID not found');
      }

      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.name}';
      final path = 'documents/$_currentUserId/$fileName';

      // Convert PlatformFile to File for StorageService
      final fileObj = File(file.path!); 
      
      final downloadUrl = await _storageService.uploadFile(fileObj, path);
      emit(DocumentUploadSuccess(downloadUrl));
    } catch (e) {
      emit(DocumentUploadError(
        'حدث خطأ أثناء رفع ملف الوثيقة',
        exception: e,
      ));
    }
  }

  // ==========================================================================
  // SEARCH AND FILTER OPERATIONS
  // ==========================================================================

  /// Search documents by document type ID
  Future<void> searchByDocumentId(int userId, int documentId) async {
    emit(const DocumentSearching());
    
    try {
      final documents = await _documentRepository.searchByDocumentId(userId, documentId);
      emit(DocumentSearchResults(
        documents,
        searchQuery: 'Document Type ID: $documentId',
      ));
    } catch (e) {
      emit(DocumentSearchError(
        'حدث خطأ أثناء البحث عن الوثائق',
        exception: e,
      ));
    }
  }

  /// Filter to show only valid documents
  Future<void> filterValidDocuments(int userId) async {
    emit(const DocumentSearching());
    
    try {
      final documents = await _documentRepository.getValidDocuments(userId);
      emit(DocumentSearchResults(
        documents,
        searchQuery: 'Valid documents only',
      ));
    } catch (e) {
      emit(DocumentSearchError(
        'حدث خطأ أثناء تصفية الوثائق',
        exception: e,
      ));
    }
  }

  /// Filter documents by validity status (client-side filtering)
  void filterByValidity(bool isValid) {
    final currentState = state;
    if (currentState is! DocumentsLoaded) {
      emit(const DocumentError('لا توجد وثائق محملة للتصفية'));
      return;
    }

    final filteredDocs = currentState.documentsWithService.where((item) {
      final doc = item['document'] as DigitalDocumentModel;
      return doc.isValid == (isValid ? 1 : 0);
    }).toList();

    emit(DocumentsLoaded(filteredDocs));
  }

  /// Clear search/filter and reload all documents
  Future<void> clearSearch() async {
    if (_currentUserId != null) {
      await loadDocuments(_currentUserId!);
    } else {
      emit(const DocumentError('معرف المستخدم غير متوفر'));
    }
  }

  // ==========================================================================
  // SELECTION OPERATIONS
  // ==========================================================================

  /// Select a document to view its details
  void selectDocument(DigitalDocumentModel document) {
    emit(DocumentSelected(document));
  }

  /// Update selection in the loaded state
  void updateSelection(DigitalDocumentModel? document) {
    final currentState = state;
    if (currentState is DocumentsLoaded) {
      emit(currentState.copyWith(selectedDocument: document));
    }
  }

  /// Clear the current selection
  void clearSelection() {
    final currentState = state;
    if (currentState is DocumentsLoaded) {
      emit(currentState.clearSelection());
    }
  }

  /// Get a specific document by ID
  Future<void> getDocumentById(int documentId) async {
    emit(const DocumentLoading());
    
    try {
      final document = await _documentRepository.getDocumentById(documentId);
      
      if (document != null) {
        emit(DocumentSelected(document));
      } else {
        emit(const DocumentFetchError('لم يتم العثور على الوثيقة'));
      }
    } catch (e) {
      emit(DocumentFetchError(
        'حدث خطأ أثناء جلب الوثيقة',
        exception: e,
      ));
    }
  }

  // ==========================================================================
  // UTILITY METHODS
  // ==========================================================================

  /// Reset cubit to initial state
  void reset() {
    _currentUserId = null;
    emit(const DocumentInitial());
  }

  /// Refresh current documents (reload)
  Future<void> refresh() async {
    if (_currentUserId != null) {
      await loadDocuments(_currentUserId!);
    } else {
      emit(const DocumentError('معرف المستخدم غير متوفر للتحديث'));
    }
  }

  // Helper method to combine logic from both branches
  // Helper method to combine logic from both branches
  Future<void> uploadAndSaveDigitalDocument({
    required int userId,
    required int documentId, // CHANGED: Now using documentId
    required File file,
  }) async {
    _currentUserId = userId;
    emit(const DocumentFileUploading());
    try {
      // 1. Upload to storage
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
      final String remotePath = 'documents/$userId/$fileName';
      final String fileUrl = await _storageService.uploadFile(file, remotePath);

      // 2. CHECK FOR DUPLICATES & REPLACE
      // Find existing documents of this type
      final existingDocs = await _documentRepository.getDigitalDocumentsByDocumentId(userId, documentId);
      for (final oldDoc in existingDocs) {
        if (oldDoc.id != null) {
          // Delete old document (logical delete or from DB)
          // For now, we delete from DB to enforce "only one version" rule as requested
          await _documentRepository.deleteDigitalDocument(oldDoc.id!);
        }
      }

      // 3. Save to Digital Documents (Vault)
      final now = DateTime.now();
      final document = DigitalDocumentModel(
        userId: userId,
        documentId: documentId, // CHANGED
        filePath: fileUrl,
        issuedDate: now.toIso8601String(),
        isValid: 1,
      );

      await _documentRepository.createDigitalDocument(document);

      emit(const DocumentOperationSuccess('تم رفع الوثيقة بنجاح'));
      await loadDocuments(userId);
    } catch (e) {
      emit(DocumentUploadError('حدث خطأ أثناء رفع الوثيقة: $e', exception: e));
    }
  }

  /// Legacy methods for backward compatibility
  Future<void> loadDigitalDocuments(int userId) => loadDocuments(userId);
  Future<void> createDigitalDocument(DigitalDocumentModel document) => createDocument(document);
}
