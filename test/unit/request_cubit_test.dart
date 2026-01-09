import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:e_baladya/logic/cubit/request_cubit.dart';
import 'package:e_baladya/data/repo/request_repository.dart';
import 'package:e_baladya/data/repo/document_repository.dart';
import 'package:e_baladya/data/repo/service_repository.dart';
import 'package:e_baladya/data/models/request_model.dart';

// Mock classes
class MockRequestRepository extends Mock implements RequestRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

class MockServiceRepository extends Mock implements ServiceRepository {}

// Fake classes for mocktail
class FakeRequestModel extends Fake implements RequestModel {}

void main() {
  late RequestCubit requestCubit;
  late MockRequestRepository mockRepository;
  late MockDocumentRepository mockDocumentRepository;
  late MockServiceRepository mockServiceRepository;

  // Register fallback values for mocktail
  setUpAll(() {
    registerFallbackValue(FakeRequestModel());
  });

  // Sample data for testing
  final testRequest = RequestModel(
    id: null,
    userId: 1,
    serviceId: 1,
    status: 'pending',
    requestDate: '2026-01-08',
    expectedDate: '2026-01-15',
    notes: 'Test notes',
  );

  final createdRequest = testRequest.copyWith(id: 123);

  final testRequestsWithService = [
    {
      'request': createdRequest,
      'service': {'id': 1, 'name': 'Test Service'},
    }
  ];

  setUp(() {
    mockRepository = MockRequestRepository();
    mockDocumentRepository = MockDocumentRepository();
    mockServiceRepository = MockServiceRepository();
    requestCubit = RequestCubit(
      requestRepository: mockRepository,
      documentRepository: mockDocumentRepository,
      serviceRepository: mockServiceRepository,
    );
  });

  tearDown(() {
    requestCubit.close();
  });

  group('RequestCubit', () {
    test('initial state is RequestInitial', () {
      expect(requestCubit.state, isA<RequestInitial>());
    });

    group('createRequest', () {
      blocTest<RequestCubit, RequestState>(
        'emits [RequestLoading, RequestCreated, RequestLoading, RequestsLoaded] when request is created successfully',
        build: () {
          when(() => mockRepository.createRequest(testRequest))
              .thenAnswer((_) async => 123);
          when(() => mockRepository.getRequestsWithService(1))
              .thenAnswer((_) async => testRequestsWithService);
          return requestCubit;
        },
        act: (cubit) => cubit.createRequest(testRequest),
        expect: () => [
          RequestLoading(),
          RequestCreated(createdRequest),
          RequestLoading(),
          RequestsLoaded(testRequestsWithService),
        ],
        verify: (_) {
          verify(() => mockRepository.createRequest(testRequest)).called(1);
          verify(() => mockRepository.getRequestsWithService(1)).called(1);
        },
      );

      blocTest<RequestCubit, RequestState>(
        'emits [RequestLoading, RequestError] when request creation fails',
        build: () {
          when(() => mockRepository.createRequest(testRequest))
              .thenThrow(Exception('Database error'));
          return requestCubit;
        },
        act: (cubit) => cubit.createRequest(testRequest),
        expect: () => [
          RequestLoading(),
          isA<RequestError>().having((e) => e.message, 'message',
              contains('حدث خطأ أثناء إنشاء الطلب')),
        ],
        verify: (_) {
          verify(() => mockRepository.createRequest(testRequest)).called(1);
          verifyNever(() => mockRepository.getRequestsWithService(any()));
        },
      );

      test('created request has correct data', () async {
        when(() => mockRepository.createRequest(testRequest))
            .thenAnswer((_) async => 123);
        when(() => mockRepository.getRequestsWithService(1))
            .thenAnswer((_) async => testRequestsWithService);

        final states = <RequestState>[];
        final subscription = requestCubit.stream.listen(states.add);

        await requestCubit.createRequest(testRequest);
        await Future.delayed(Duration.zero);

        expect(states[1], isA<RequestCreated>());
        final createdState = states[1] as RequestCreated;
        expect(createdState.request.id, 123);
        expect(createdState.request.userId, testRequest.userId);
        expect(createdState.request.serviceId, testRequest.serviceId);
        expect(createdState.request.status, testRequest.status);
        expect(createdState.request.requestDate, testRequest.requestDate);
        expect(createdState.request.expectedDate, testRequest.expectedDate);
        expect(createdState.request.notes, testRequest.notes);

        await subscription.cancel();
      });
    });

    group('loadRequests', () {
      blocTest<RequestCubit, RequestState>(
        'emits [RequestLoading, RequestsLoaded] when requests are loaded successfully',
        build: () {
          when(() => mockRepository.getRequestsWithService(1))
              .thenAnswer((_) async => testRequestsWithService);
          return requestCubit;
        },
        act: (cubit) => cubit.loadRequests(1),
        expect: () => [
          RequestLoading(),
          RequestsLoaded(testRequestsWithService),
        ],
        verify: (_) {
          verify(() => mockRepository.getRequestsWithService(1)).called(1);
        },
      );

      blocTest<RequestCubit, RequestState>(
        'emits [RequestLoading, RequestError] when loading requests fails',
        build: () {
          when(() => mockRepository.getRequestsWithService(1))
              .thenThrow(Exception('Network error'));
          return requestCubit;
        },
        act: (cubit) => cubit.loadRequests(1),
        expect: () => [
          RequestLoading(),
          const RequestError('حدث خطأ أثناء تحميل الطلبات'),
        ],
        verify: (_) {
          verify(() => mockRepository.getRequestsWithService(1)).called(1);
        },
      );

      test('loaded requests contain correct data', () async {
        when(() => mockRepository.getRequestsWithService(1))
            .thenAnswer((_) async => testRequestsWithService);

        final states = <RequestState>[];
        final subscription = requestCubit.stream.listen(states.add);

        await requestCubit.loadRequests(1);
        await Future.delayed(Duration.zero);

        expect(states[1], isA<RequestsLoaded>());
        final loadedState = states[1] as RequestsLoaded;
        expect(loadedState.requestsWithService, testRequestsWithService);
        expect(loadedState.requestsWithService.length, 1);

        await subscription.cancel();
      });
    });

    group('updateRequestStatus', () {
      final existingRequest = RequestModel(
        id: 123,
        userId: 1,
        serviceId: 1,
        status: 'pending',
        requestDate: '2026-01-08',
        expectedDate: '2026-01-15',
        notes: 'Test notes',
      );

      final updatedRequest = existingRequest.copyWith(status: 'approved');

      blocTest<RequestCubit, RequestState>(
        'emits [RequestLoading, RequestsLoaded] when status is updated successfully',
        build: () {
          when(() => mockRepository.getRequestById(123))
              .thenAnswer((_) async => existingRequest);
          when(() => mockRepository.updateRequest(updatedRequest))
              .thenAnswer((_) async => 1);
          when(() => mockRepository.getRequestsWithService(1))
              .thenAnswer((_) async => testRequestsWithService);
          return requestCubit;
        },
        act: (cubit) => cubit.updateRequestStatus(123, 'approved'),
        expect: () => [
          RequestLoading(),
          RequestsLoaded(testRequestsWithService),
        ],
        verify: (_) {
          verify(() => mockRepository.getRequestById(123)).called(1);
          verify(() => mockRepository.updateRequest(updatedRequest)).called(1);
          verify(() => mockRepository.getRequestsWithService(1)).called(1);
        },
      );

      blocTest<RequestCubit, RequestState>(
        'emits [RequestError] when update fails',
        build: () {
          when(() => mockRepository.getRequestById(123))
              .thenThrow(Exception('Database error'));
          return requestCubit;
        },
        act: (cubit) => cubit.updateRequestStatus(123, 'approved'),
        expect: () => [
          const RequestError('حدث خطأ أثناء تحديث حالة الطلب'),
        ],
        verify: (_) {
          verify(() => mockRepository.getRequestById(123)).called(1);
          verifyNever(() => mockRepository.updateRequest(any()));
          verifyNever(() => mockRepository.getRequestsWithService(any()));
        },
      );

      blocTest<RequestCubit, RequestState>(
        'does not emit error when request is not found',
        build: () {
          when(() => mockRepository.getRequestById(123))
              .thenAnswer((_) async => null);
          return requestCubit;
        },
        act: (cubit) => cubit.updateRequestStatus(123, 'approved'),
        expect: () => [],
        verify: (_) {
          verify(() => mockRepository.getRequestById(123)).called(1);
          verifyNever(() => mockRepository.updateRequest(any()));
          verifyNever(() => mockRepository.getRequestsWithService(any()));
        },
        errors: () => [], // No errors expected
      );
    });

    group('State transitions', () {
      blocTest<RequestCubit, RequestState>(
        'RequestLoading to RequestCreated to RequestsLoaded sequence',
        build: () {
          when(() => mockRepository.createRequest(testRequest))
              .thenAnswer((_) async => 123);
          when(() => mockRepository.getRequestsWithService(1))
              .thenAnswer((_) async => testRequestsWithService);
          return requestCubit;
        },
        act: (cubit) => cubit.createRequest(testRequest),
        expect: () => [
          RequestLoading(),
          RequestCreated(createdRequest),
          RequestLoading(),
          RequestsLoaded(testRequestsWithService),
        ],
      );

      blocTest<RequestCubit, RequestState>(
        'RequestLoading to RequestError sequence',
        build: () {
          when(() => mockRepository.createRequest(testRequest))
              .thenThrow(Exception('Error'));
          return requestCubit;
        },
        act: (cubit) => cubit.createRequest(testRequest),
        expect: () => [
          RequestLoading(),
          isA<RequestError>().having((e) => e.message, 'message',
              contains('حدث خطأ أثناء إنشاء الطلب')),
        ],
      );
    });

    group('Error messages', () {
      test('createRequest error has correct message', () async {
        when(() => mockRepository.createRequest(testRequest))
            .thenThrow(Exception('Error'));

        final states = <RequestState>[];
        final subscription = requestCubit.stream.listen(states.add);

        await requestCubit.createRequest(testRequest);
        await Future.delayed(Duration.zero);

        final errorState = states[1] as RequestError;
        expect(errorState.message, contains('حدث خطأ أثناء إنشاء الطلب'));

        await subscription.cancel();
      });

      test('loadRequests error has correct message', () async {
        when(() => mockRepository.getRequestsWithService(1))
            .thenThrow(Exception('Error'));

        final states = <RequestState>[];
        final subscription = requestCubit.stream.listen(states.add);

        await requestCubit.loadRequests(1);
        await Future.delayed(Duration.zero);

        final errorState = states[1] as RequestError;
        expect(errorState.message, 'حدث خطأ أثناء تحميل الطلبات');

        await subscription.cancel();
      });

      test('updateRequestStatus error has correct message', () async {
        when(() => mockRepository.getRequestById(123))
            .thenThrow(Exception('Error'));

        final states = <RequestState>[];
        final subscription = requestCubit.stream.listen(states.add);

        await requestCubit.updateRequestStatus(123, 'approved');
        await Future.delayed(Duration.zero);

        final errorState = states[0] as RequestError;
        expect(errorState.message, 'حدث خطأ أثناء تحديث حالة الطلب');

        await subscription.cancel();
      });
    });
  });
}
