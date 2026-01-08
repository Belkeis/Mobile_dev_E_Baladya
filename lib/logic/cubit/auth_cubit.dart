import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../data/repo/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../utils/fcm_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;
  final FCMService? _fcmService;
  static const String _userIdKey = 'user_id';

  // Constructor with optional FCM service for testing
  AuthCubit(
    this._userRepository, {
    FCMService? fcmService,
  })  : _fcmService = fcmService ?? FCMService(),
        super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
        if (user.id != null) {
          await _fcmService?.subscribeUserToPersonalTopic(user.id!);
          await _saveUserId(user.id!);
        }
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('البريد الإلكتروني أو كلمة المرور غير صحيحة'));
      }
    } catch (e) {
      emit(const AuthError('حدث خطأ أثناء تسجيل الدخول'));
    }
  }

  Future<void> register(UserModel user) async {
    emit(AuthLoading());
    try {
      final userId = await _userRepository.createUser(user);
      final newUser = user.copyWith(id: userId);

      if (newUser.id != null) {
        await _fcmService?.subscribeUserToPersonalTopic(newUser.id!);
        await _saveUserId(newUser.id!);
      }

      emit(AuthAuthenticated(newUser));
    } catch (e) {
      emit(const AuthError('حدث خطأ أثناء التسجيل'));
    }
  }

  Future<void> updateUser(UserModel user) async {
    emit(AuthLoading());
    try {
      await _userRepository.updateUser(user);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(const AuthError('حدث خطأ أثناء تحديث البيانات'));
    }
  }

  Future<void> logout(int? userId) async {
    if (userId != null) {
      await _fcmService?.unsubscribeUserFromPersonalTopic(userId);
    }
    await _clearUserId();
    emit(AuthInitial());
  }

  Future<void> loadUser(int userId) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.getUserById(userId);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthError('المستخدم غير موجود'));
      }
    } catch (e) {
      emit(const AuthError('حدث خطأ أثناء تحميل بيانات المستخدم'));
    }
  }

  Future<void> _saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_userIdKey, userId);
  }

  Future<int?> _getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_userIdKey);
  }

  Future<void> _clearUserId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
  }

  Future<void> checkAuthStatus() async {
    emit(AuthLoading()); 
    final userId = await _getSavedUserId();
    if (userId != null) {
      await loadUser(userId);
    } else {
      emit(AuthInitial());
    }
  }
}
