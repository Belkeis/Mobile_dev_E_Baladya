import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/document_repository.dart';
import '../../data/models/digital_document_model.dart';
import '../../data/models/service_model.dart';

part 'document_state.dart';

class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository _documentRepository;

  DocumentCubit(this._documentRepository) : super(DocumentInitial());

  Future<void> loadDigitalDocuments(int userId) async {
    emit(DocumentLoading());
    try {
      final documentsWithService = await _documentRepository.getDigitalDocumentsWithService(userId);
      emit(DocumentsLoaded(documentsWithService));
    } catch (e) {
      emit(DocumentError('حدث خطأ أثناء تحميل الوثائق الرقمية'));
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
}

