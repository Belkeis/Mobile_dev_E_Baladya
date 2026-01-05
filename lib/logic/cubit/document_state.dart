part of 'document_cubit.dart';

/// Base abstract class for all document states
/// Uses Equatable for value comparison to optimize rebuild performance
abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

// ============================================================================
// IDLE STATES
// ============================================================================

/// Initial state when no documents have been loaded yet
class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

// ============================================================================
// LOADING STATES
// ============================================================================

/// Generic loading state for any document operation
class DocumentLoading extends DocumentState {
  const DocumentLoading();
}

/// Specific loading state for fetching documents
class DocumentsFetching extends DocumentState {
  const DocumentsFetching();
}

/// Loading state for creating a new document
class DocumentCreating extends DocumentState {
  const DocumentCreating();
}

/// Loading state for updating a document
class DocumentUpdating extends DocumentState {
  final int documentId;
  
  const DocumentUpdating(this.documentId);
  
  @override
  List<Object?> get props => [documentId];
}

/// Loading state for deleting a document
class DocumentDeleting extends DocumentState {
  final int documentId;
  
  const DocumentDeleting(this.documentId);
  
  @override
  List<Object?> get props => [documentId];
}

/// Loading state for search/filter operations
class DocumentSearching extends DocumentState {
  const DocumentSearching();
}

/// Loading state for file upload
class DocumentFileUploading extends DocumentState {
  const DocumentFileUploading();
}

// ============================================================================
// SUCCESS STATES
// ============================================================================

/// Documents successfully loaded with their service information
class DocumentsLoaded extends DocumentState {
  final List<Map<String, dynamic>> documentsWithService;
  final DigitalDocumentModel? selectedDocument;
  
  const DocumentsLoaded(
    this.documentsWithService, {
    this.selectedDocument,
  });

  @override
  List<Object?> get props => [documentsWithService, selectedDocument];
  
  /// Create a copy with updated selection
  DocumentsLoaded copyWith({
    List<Map<String, dynamic>>? documentsWithService,
    DigitalDocumentModel? selectedDocument,
  }) {
    return DocumentsLoaded(
      documentsWithService ?? this.documentsWithService,
      selectedDocument: selectedDocument ?? this.selectedDocument,
    );
  }
  
  /// Clear selection
  DocumentsLoaded clearSelection() {
    return DocumentsLoaded(
      documentsWithService,
      selectedDocument: null,
    );
  }
}

/// Document successfully created
class DocumentCreated extends DocumentState {
  final int documentId;
  final String message;
  
  const DocumentCreated(this.documentId, this.message);
  
  @override
  List<Object?> get props => [documentId, message];
}

/// Document successfully updated
class DocumentUpdated extends DocumentState {
  final int documentId;
  final String message;
  
  const DocumentUpdated(this.documentId, this.message);
  
  @override
  List<Object?> get props => [documentId, message];
}

/// Document successfully deleted
class DocumentDeleted extends DocumentState {
  final int documentId;
  final String message;
  
  const DocumentDeleted(this.documentId, this.message);
  
  @override
  List<Object?> get props => [documentId, message];
}

/// Search/filter results
class DocumentSearchResults extends DocumentState {
  final List<DigitalDocumentModel> documents;
  final String? searchQuery;
  
  const DocumentSearchResults(this.documents, {this.searchQuery});
  
  @override
  List<Object?> get props => [documents, searchQuery];
}

/// Document selected
class DocumentSelected extends DocumentState {
  final DigitalDocumentModel document;
  
  const DocumentSelected(this.document);
  
  @override
  List<Object?> get props => [document];
}

@Deprecated('Use DocumentUploadSuccess instead')
class DocumentFileUploaded extends DocumentState {
  final String downloadUrl;
  
  const DocumentFileUploaded(this.downloadUrl);
  
  @override
  List<Object?> get props => [downloadUrl];
}

/// Document file successfully uploaded
class DocumentUploadSuccess extends DocumentState {
  final String downloadUrl;

  const DocumentUploadSuccess(this.downloadUrl);

  @override
  List<Object?> get props => [downloadUrl];
}

// ============================================================================
// ERROR STATES
// ============================================================================

/// Base error state for all document operations
class DocumentError extends DocumentState {
  final String message;
  final String? errorCode;
  final dynamic exception;
  
  const DocumentError(
    this.message, {
    this.errorCode,
    this.exception,
  });

  @override
  List<Object?> get props => [message, errorCode, exception];
}

/// Specific error for fetch operations
class DocumentFetchError extends DocumentError {
  const DocumentFetchError(
    super.message, {
    super.errorCode,
    super.exception,
  });
}

/// Specific error for create operations
class DocumentCreateError extends DocumentError {
  const DocumentCreateError(
    super.message, {
    super.errorCode,
    super.exception,
  });
}

/// Specific error for update operations
class DocumentUpdateError extends DocumentError {
  const DocumentUpdateError(
    super.message, {
    super.errorCode,
    super.exception,
  });
}

/// Specific error for delete operations
class DocumentDeleteError extends DocumentError {
  const DocumentDeleteError(
    super.message, {
    super.errorCode,
    super.exception,
  });
}

/// Specific error for search operations
class DocumentSearchError extends DocumentError {
  const DocumentSearchError(
    super.message, {
    super.errorCode,
    super.exception,
  });
}

/// Specific error for upload operations
class DocumentUploadError extends DocumentError {
  const DocumentUploadError(
    super.message, {
    super.errorCode,
    super.exception,
  });
}

