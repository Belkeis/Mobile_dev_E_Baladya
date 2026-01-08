import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_baladya/logic/cubit/auth_cubit.dart';
import 'package:e_baladya/data/models/user_model.dart';
import 'package:e_baladya/data/repo/user_repository.dart';
import 'package:e_baladya/utils/fcm_service.dart';

// Mocks
class MockUserRepository extends Mock implements UserRepository {}

class MockFCMService extends Mock implements FCMService {}

class FakeUserModel extends Fake implements UserModel {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late AuthCubit authCubit;
  late MockUserRepository mockRepo;
  late MockFCMService mockFCMService;

  // Sample test data
  const testEmail = 'test@example.com';
  const testPassword = '123456';
  final testUser = UserModel(
    id: 42,
    fullName: 'Test User',
    email: testEmail,
    phone: '0123456789',
    nationalId: '12345678901234',
    password: testPassword,
    createdAt: DateTime.now().toIso8601String(),
  );

  setUpAll(() {
    registerFallbackValue(FakeUserModel());
  });

  setUp(() {
    // Initialize SharedPreferences with empty values
    SharedPreferences.setMockInitialValues({});

    mockRepo = MockUserRepository();
    mockFCMService = MockFCMService();

    // Mock FCM service methods to do nothing (they return Future<void>)
    when(() => mockFCMService.subscribeUserToPersonalTopic(any()))
        .thenAnswer((_) async => {});
    when(() => mockFCMService.unsubscribeUserFromPersonalTopic(any()))
        .thenAnswer((_) async => {});

    // Create AuthCubit with mocked FCM service
    authCubit = AuthCubit(mockRepo, fcmService: mockFCMService);
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit login', () {
    blocTest<AuthCubit, AuthState>(
      'successful login flow',
      setUp: () {
        when(() => mockRepo.login(testEmail, testPassword))
            .thenAnswer((_) async => testUser);
      },
      build: () => authCubit,
      act: (cubit) => cubit.login(testEmail, testPassword),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthAuthenticated>((state) {
          return state.user.id == 42 &&
              state.user.email == testEmail &&
              state.user.fullName == 'Test User';
        }),
      ],
      verify: (_) {
        verify(() => mockRepo.login(testEmail, testPassword)).called(1);
        verify(() => mockFCMService.subscribeUserToPersonalTopic(42)).called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'wrong credentials → error',
      setUp: () {
        when(() => mockRepo.login(testEmail, 'wrongpass'))
            .thenAnswer((_) async => null);
      },
      build: () => authCubit,
      act: (cubit) => cubit.login(testEmail, 'wrongpass'),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthError>((state) {
          return state.message == 'البريد الإلكتروني أو كلمة المرور غير صحيحة';
        }),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'repository throws exception during login → generic error',
      setUp: () {
        when(() => mockRepo.login(any(), any()))
            .thenThrow(Exception('Database error'));
      },
      build: () => authCubit,
      act: (cubit) => cubit.login(testEmail, testPassword),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthError>((state) {
          return state.message == 'حدث خطأ أثناء تسجيل الدخول';
        }),
      ],
    );
  });

  group('AuthCubit register', () {
    blocTest<AuthCubit, AuthState>(
      'successful registration',
      setUp: () {
        when(() => mockRepo.createUser(any())).thenAnswer((_) async => 777);
      },
      build: () => authCubit,
      act: (cubit) => cubit.register(testUser),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthAuthenticated>((state) {
          return state.user.id == 777;
        }),
      ],
      verify: (_) {
        verify(() => mockRepo.createUser(any())).called(1);
        verify(() => mockFCMService.subscribeUserToPersonalTopic(777))
            .called(1);
      },
    );

    blocTest<AuthCubit, AuthState>(
      'repository throws exception during registration → generic error',
      setUp: () {
        when(() => mockRepo.createUser(any()))
            .thenThrow(Exception('Database error'));
      },
      build: () => authCubit,
      act: (cubit) => cubit.register(testUser),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthError>((state) {
          return state.message == 'حدث خطأ أثناء التسجيل';
        }),
      ],
    );
  });

  group('AuthCubit updateUser', () {
    blocTest<AuthCubit, AuthState>(
      'successful user update',
      setUp: () {
        when(() => mockRepo.updateUser(any())).thenAnswer((_) async => 1);
      },
      build: () => authCubit,
      act: (cubit) => cubit.updateUser(testUser),
      expect: () => [
        isA<AuthLoading>(),
        predicate<AuthAuthenticated>((state) {
          return state.user.id == 42;
        }),
      ],
    );
  });

  group('AuthCubit logout', () {
    blocTest<AuthCubit, AuthState>(
      'logout returns to initial state',
      build: () => authCubit,
      act: (cubit) => cubit.logout(42),
      expect: () => [
        isA<AuthInitial>(),
      ],
      verify: (_) {
        verify(() => mockFCMService.unsubscribeUserFromPersonalTopic(42))
            .called(1);
      },
    );
  });

  group('AuthCubit checkAuthStatus', () {
    blocTest<AuthCubit, AuthState>(
      'user logged in → authenticated state',
      setUp: () {
        SharedPreferences.setMockInitialValues({'user_id': 42});
        when(() => mockRepo.getUserById(42)).thenAnswer((_) async => testUser);
      },
      build: () => authCubit,
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        isA<AuthLoading>(), // loadUser emits loading first
        predicate<AuthAuthenticated>((state) => state.user.id == 42),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'no saved user → stays in initial state',
      setUp: () {
        SharedPreferences.setMockInitialValues({});
      },
      build: () => authCubit,
      act: (cubit) => cubit.checkAuthStatus(),
      expect: () => [
        isA<AuthLoading>(),
        isA<AuthInitial>(),
      ],
    );
  });
}
