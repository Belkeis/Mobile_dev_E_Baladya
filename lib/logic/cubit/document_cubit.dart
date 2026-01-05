import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/document_repository.dart';
import '../../data/models/digital_document_model.dart';
import '../../data/services/storage_service.dart';
import 'dart:io';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository _documentRepository;
  final StorageService _storageService;

  DocumentCubit({
    required DocumentRepository documentRepository,
    required StorageService storageService,
  })  : _documentRepository = documentRepository,
        _storageService = storageService,
        super(DocumentInitial());

  Future<void> loadDigitalDocuments(int userId) async {
    emit(DocumentLoading());
    try {
      final documentsWithService = await _documentRepository.getDigitalDocumentsWithService(userId);
      emit(DocumentsLoaded(documentsWithService));
    } catch (e) {
      emit(DocumentError('Error loading docs: $e'));
    }
  }

  Future<void> createDigitalDocument(DigitalDocumentModel document) async {
    try {
      await _documentRepository.createDigitalDocument(document);
      await loadDigitalDocuments(document.userId);
    } catch (e) {
      emit(DocumentError('حدث خطأ أثناء إنشاء الوثيقة الرقمية'));
    }
  }

  Future<void> uploadAndSaveDigitalDocument({
    required int userId,
    required int serviceId,
    required File file,
  }) async {
    emit(DocumentUploading());
    try {
      // 1. Upload the file
      final String remotePath = 'users/$userId/documents';
      final String fileUrl = await _storageService.uploadFile(file, remotePath);

      // 2. Create the model
      final now = DateTime.now();
      final document = DigitalDocumentModel(
        userId: userId,
        serviceId: serviceId,
        filePath: fileUrl,
        issuedDate: now.toIso8601String(),
        isValid: 1,
      );

      // 3. Save to database
      await _documentRepository.createDigitalDocument(document);

      // 4. Reload the list
      emit(const DocumentOperationSuccess('تم رفع الوثيقة بنجاح'));
      await loadDigitalDocuments(userId);
    } catch (e) {
      emit(DocumentError('حدث خطأ أثناء رفع الوثيقة: $e'));
    }
  }
}

