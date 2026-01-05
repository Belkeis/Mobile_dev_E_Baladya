import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:e_baladya/logic/cubit/document_cubit.dart';
import 'package:e_baladya/data/repo/document_repository.dart';
import 'package:e_baladya/data/models/digital_document_model.dart';
import 'package:e_baladya/data/services/storage_service.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';

// Mock classes
class MockDocumentRepository extends Mock implements DocumentRepository {}
class MockStorageService extends Mock implements StorageService {}

void main() {
  late DocumentRepository mockRepository;
  late StorageService mockStorageService;
  late DocumentCubit documentCubit;

  // Test data
  final testUserId = 1;
  final testDocument = DigitalDocumentModel(
    id: 1,
    userId: testUserId,
    serviceId: 1,
    filePath: '/path/to/document.pdf',
    issuedDate: '2024-01-01',
    isValid: 1,
  );
  
  final testDocumentsList = [testDocument];
  
  final testDocumentsWithService = [
    {
      'document': testDocument,
      'service': {'id': 1, 'name': 'Test Service'},
    }
  ];

  setUp(() {
    mockRepository = MockDocumentRepository();
    mockStorageService = MockStorageService();
    documentCubit = DocumentCubit(mockRepository, mockStorageService);
  });

  tearDown(() {
    documentCubit.close();
  });

  group('DocumentCubit', () {
    // ==========================================================================
    // INITIAL STATE
    // ==========================================================================
    
    test('initial state is DocumentInitial', () {
      expect(documentCubit.state, isA<DocumentInitial>());
    });

    // ==========================================================================
    // LOAD DOCUMENTS
    // ==========================================================================
    
    group('loadDocuments', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentsFetching, DocumentsLoaded] when documents are loaded successfully',
        build: () {
          when(() => mockRepository.getDigitalDocumentsWithService(testUserId))
              .thenAnswer((_) async => testDocumentsWithService);
          return documentCubit;
        },
        act: (cubit) => cubit.loadDocuments(testUserId),
        expect: () => [
          isA<DocumentsFetching>(),
          isA<DocumentsLoaded>()
              .having((s) => s.documentsWithService, 'documents', testDocumentsWithService),
        ],
        verify: (_) {
          verify(() => mockRepository.getDigitalDocumentsWithService(testUserId)).called(1);
        },
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentsFetching, DocumentFetchError] when loading fails',
        build: () {
          when(() => mockRepository.getDigitalDocumentsWithService(testUserId))
              .thenThrow(Exception('Failed to load'));
          return documentCubit;
        },
        act: (cubit) => cubit.loadDocuments(testUserId),
        expect: () => [
          isA<DocumentsFetching>(),
          isA<DocumentFetchError>()
              .having((s) => s.message, 'message', contains('حدث خطأ')),
        ],
      );
    });

    // ==========================================================================
    // CREATE DOCUMENT
    // ==========================================================================
    
    group('createDocument', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentCreating, DocumentCreated, DocumentsFetching, DocumentsLoaded] when document is created successfully',
        build: () {
          when(() => mockRepository.createDigitalDocument(testDocument))
              .thenAnswer((_) async => 1);
          when(() => mockRepository.getDigitalDocumentsWithService(testUserId))
              .thenAnswer((_) async => testDocumentsWithService);
          return documentCubit;
        },
        act: (cubit) => cubit.createDocument(testDocument),
        expect: () => [
          isA<DocumentCreating>(),
          isA<DocumentCreated>()
              .having((s) => s.documentId, 'documentId', 1)
              .having((s) => s.message, 'message', contains('بنجاح')),
          isA<DocumentsFetching>(),
          isA<DocumentsLoaded>(),
        ],
        verify: (_) {
          verify(() => mockRepository.createDigitalDocument(testDocument)).called(1);
          verify(() => mockRepository.getDigitalDocumentsWithService(testUserId)).called(1);
        },
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentCreating, DocumentCreateError] when creation fails',
        build: () {
          when(() => mockRepository.createDigitalDocument(testDocument))
              .thenThrow(Exception('Creation failed'));
          return documentCubit;
        },
        act: (cubit) => cubit.createDocument(testDocument),
        expect: () => [
          isA<DocumentCreating>(),
          isA<DocumentCreateError>()
              .having((s) => s.message, 'message', contains('حدث خطأ')),
        ],
      );
    });

    // ==========================================================================
    // UPDATE DOCUMENT
    // ==========================================================================
    
    group('updateDocument', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentUpdating, DocumentUpdated, DocumentsFetching, DocumentsLoaded] when document is updated successfully',
        build: () {
          when(() => mockRepository.updateDigitalDocument(testDocument))
              .thenAnswer((_) async => 1);
          when(() => mockRepository.getDigitalDocumentsWithService(testUserId))
              .thenAnswer((_) async => testDocumentsWithService);
          return documentCubit;
        },
        act: (cubit) async {
          await cubit.loadDocuments(testUserId);
          await cubit.updateDocument(testDocument);
        },
        skip: 2, // Skip loading states from loadDocuments
        expect: () => [
          isA<DocumentUpdating>()
              .having((s) => s.documentId, 'documentId', 1),
          isA<DocumentUpdated>()
              .having((s) => s.documentId, 'documentId', 1)
              .having((s) => s.message, 'message', contains('بنجاح')),
          isA<DocumentsFetching>(),
          isA<DocumentsLoaded>(),
        ],
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentUpdateError] when document id is null',
        build: () => documentCubit,
        act: (cubit) => cubit.updateDocument(
          testDocument.copyWith(id: null),
        ),
        expect: () => [
          isA<DocumentUpdateError>()
              .having((s) => s.message, 'message', contains('مفقود')),
        ],
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentUpdating, DocumentUpdateError] when update fails',
        build: () {
          when(() => mockRepository.updateDigitalDocument(testDocument))
              .thenThrow(Exception('Update failed'));
          return documentCubit;
        },
        act: (cubit) async {
          await cubit.loadDocuments(testUserId);
          await cubit.updateDocument(testDocument);
        },
        skip: 2,
        expect: () => [
          isA<DocumentUpdating>(),
          isA<DocumentUpdateError>()
              .having((s) => s.message, 'message', contains('حدث خطأ')),
        ],
      );
    });

    // ==========================================================================
    // DELETE DOCUMENT
    // ==========================================================================
    
    group('deleteDocument', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentDeleting, DocumentDeleted, DocumentsFetching, DocumentsLoaded] when document is deleted successfully',
        build: () {
          when(() => mockRepository.deleteDigitalDocument(1))
              .thenAnswer((_) async => 1);
          when(() => mockRepository.getDigitalDocumentsWithService(testUserId))
              .thenAnswer((_) async => []);
          return documentCubit;
        },
        act: (cubit) => cubit.deleteDocument(1, testUserId),
        expect: () => [
          isA<DocumentDeleting>()
              .having((s) => s.documentId, 'documentId', 1),
          isA<DocumentDeleted>()
              .having((s) => s.documentId, 'documentId', 1)
              .having((s) => s.message, 'message', contains('بنجاح')),
          isA<DocumentsFetching>(),
          isA<DocumentsLoaded>()
              .having((s) => s.documentsWithService, 'documents', isEmpty),
        ],
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentDeleting, DocumentDeleteError] when deletion fails',
        build: () {
          when(() => mockRepository.deleteDigitalDocument(1))
              .thenThrow(Exception('Deletion failed'));
          return documentCubit;
        },
        act: (cubit) => cubit.deleteDocument(1, testUserId),
        expect: () => [
          isA<DocumentDeleting>(),
          isA<DocumentDeleteError>()
              .having((s) => s.message, 'message', contains('حدث خطأ')),
        ],
      );
    });

    // ==========================================================================
    // UPLOAD DOCUMENT
    // ==========================================================================
    
    group('uploadDocumentFile', () {
      final testFile = File('test_path');
      final testUrl = 'https://firebase.storage.url/doc.pdf';

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentFileUploading, DocumentFileUploaded] when upload is successful',
        build: () {
          when(() => mockStorageService.uploadFile(any(), any()))
              .thenAnswer((_) async => testUrl);
          return documentCubit;
        },
        act: (cubit) async {
          await cubit.loadDocuments(testUserId);
          await cubit.uploadDocumentFile(testFile);
        },
        skip: 2, // Skip loadDocuments states
        expect: () => [
          isA<DocumentFileUploading>(),
          isA<DocumentFileUploaded>()
              .having((s) => s.downloadUrl, 'downloadUrl', testUrl),
        ],
        verify: (_) {
          verify(() => mockStorageService.uploadFile(any(), any())).called(1);
        },
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentFileUploading, DocumentUploadError] when upload fails',
        build: () {
          when(() => mockStorageService.uploadFile(any(), any()))
              .thenThrow(Exception('Upload failed'));
          return documentCubit;
        },
        act: (cubit) async {
          await cubit.loadDocuments(testUserId);
          await cubit.uploadDocumentFile(testFile);
        },
        skip: 2,
        expect: () => [
          isA<DocumentFileUploading>(),
          isA<DocumentUploadError>()
              .having((s) => s.message, 'message', contains('حدث خطأ')),
        ],
      );
    });
    
    // ==========================================================================
    // UPLOAD PLATFORM FILE
    // ==========================================================================

    group('uploadFile (PlatformFile)', () {
      final testPlatformFile = PlatformFile(
        name: 'test_doc.pdf', 
        size: 1024,
        path: 'path/to/test_doc.pdf',
      );
      final testUrl = 'https://firebase.storage.url/doc.pdf';

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentFileUploading, DocumentUploadSuccess] when upload is successful',
        build: () {
          when(() => mockStorageService.uploadFile(any(), any()))
              .thenAnswer((_) async => testUrl);
          return documentCubit;
        },
        act: (cubit) async {
          await cubit.loadDocuments(testUserId);
          await cubit.uploadFile(testPlatformFile);
        },
        skip: 2, // Skip loadDocuments states
        expect: () => [
          isA<DocumentFileUploading>(),
          isA<DocumentUploadSuccess>()
              .having((s) => s.downloadUrl, 'downloadUrl', testUrl),
        ],
        verify: (_) {
          verify(() => mockStorageService.uploadFile(any(), any())).called(1);
        },
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentFileUploading, DocumentUploadError] when upload fails',
        build: () {
          when(() => mockStorageService.uploadFile(any(), any()))
              .thenThrow(Exception('Upload failed'));
          return documentCubit;
        },
        act: (cubit) async {
          await cubit.loadDocuments(testUserId);
          await cubit.uploadFile(testPlatformFile);
        },
        skip: 2,
        expect: () => [
          isA<DocumentFileUploading>(),
          isA<DocumentUploadError>()
              .having((s) => s.message, 'message', contains('حدث خطأ')),
        ],
      );
    });

    // ==========================================================================
    // SEARCH AND FILTER
    // ==========================================================================
    
    group('searchByService', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentSearching, DocumentSearchResults] when search is successful',
        build: () {
          when(() => mockRepository.searchByServiceId(testUserId, 1))
              .thenAnswer((_) async => testDocumentsList);
          return documentCubit;
        },
        act: (cubit) => cubit.searchByService(testUserId, 1),
        expect: () => [
          isA<DocumentSearching>(),
          isA<DocumentSearchResults>()
              .having((s) => s.documents, 'documents', testDocumentsList)
              .having((s) => s.searchQuery, 'searchQuery', contains('Service ID')),
        ],
      );
    });

    group('filterValidDocuments', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentSearching, DocumentSearchResults] with valid documents only',
        build: () {
          when(() => mockRepository.getValidDocuments(testUserId))
              .thenAnswer((_) async => testDocumentsList);
          return documentCubit;
        },
        act: (cubit) => cubit.filterValidDocuments(testUserId),
        expect: () => [
          isA<DocumentSearching>(),
          isA<DocumentSearchResults>()
              .having((s) => s.documents, 'documents', testDocumentsList),
        ],
      );
    });

    // ==========================================================================
    // SELECTION
    // ==========================================================================
    
    group('selectDocument', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentSelected] when document is selected',
        build: () => documentCubit,
        act: (cubit) => cubit.selectDocument(testDocument),
        expect: () => [
          isA<DocumentSelected>()
              .having((s) => s.document, 'document', testDocument),
        ],
      );
    });

    group('getDocumentById', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentLoading, DocumentSelected] when document is found',
        build: () {
          when(() => mockRepository.getDocumentById(1))
              .thenAnswer((_) async => testDocument);
          return documentCubit;
        },
        act: (cubit) => cubit.getDocumentById(1),
        expect: () => [
          isA<DocumentLoading>(),
          isA<DocumentSelected>()
              .having((s) => s.document, 'document', testDocument),
        ],
      );

      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentLoading, DocumentFetchError] when document is not found',
        build: () {
          when(() => mockRepository.getDocumentById(1))
              .thenAnswer((_) async => null);
          return documentCubit;
        },
        act: (cubit) => cubit.getDocumentById(1),
        expect: () => [
          isA<DocumentLoading>(),
          isA<DocumentFetchError>()
              .having((s) => s.message, 'message', contains('لم يتم العثور')),
        ],
      );
    });

    // ==========================================================================
    // UTILITY METHODS
    // ==========================================================================
    
    group('reset', () {
      blocTest<DocumentCubit, DocumentState>(
        'emits [DocumentInitial] when reset is called',
        build: () => documentCubit,
        seed: () => DocumentsLoaded(testDocumentsWithService),
        act: (cubit) => cubit.reset(),
        expect: () => [
          isA<DocumentInitial>(),
        ],
      );
    });

    group('refresh', () {
      blocTest<DocumentCubit, DocumentState>(
        'reloads documents when refresh is called',
        build: () {
          when(() => mockRepository.getDigitalDocumentsWithService(testUserId))
              .thenAnswer((_) async => testDocumentsWithService);
          return documentCubit;
        },
        act: (cubit) async {
          await cubit.loadDocuments(testUserId);
          await cubit.refresh();
        },
        skip: 2, // Skip initial load states
        expect: () => [
          isA<DocumentsFetching>(),
          isA<DocumentsLoaded>(),
        ],
      );
    });
  });
}

// Extension for creating copies with null id
extension DigitalDocumentModelX on DigitalDocumentModel {
  DigitalDocumentModel copyWith({
    int? id,
    int? userId,
    int? serviceId,
    String? filePath,
    String? issuedDate,
    String? expiresOn,
    int? isValid,
  }) {
    return DigitalDocumentModel(
      id: id,
      userId: userId ?? this.userId,
      serviceId: serviceId ?? this.serviceId,
      filePath: filePath ?? this.filePath,
      issuedDate: issuedDate ?? this.issuedDate,
      expiresOn: expiresOn ?? this.expiresOn,
      isValid: isValid ?? this.isValid,
    );
  }
}
