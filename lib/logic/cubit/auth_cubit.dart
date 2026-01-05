import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/user_repository.dart';
import '../../data/models/user_model.dart';
import '../../utils/fcm_service.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit(this._userRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
        // Subscribe user to FCM topic for targeted notifications
        if (user.id != null) {
          await FCMService().subscribeUserToPersonalTopic(user.id!);
        }
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('البريد الإلكتروني أو كلمة المرور غير صحيحة'));
      }
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تسجيل الدخول'));
    }
  }

  Future<void> register(UserModel user) async {
    emit(AuthLoading());
    try {
      final userId = await _userRepository.createUser(user);
      final newUser = user.copyWith(id: userId);
      
      // Subscribe new user to FCM topic
      if (newUser.id != null) {
        await FCMService().subscribeUserToPersonalTopic(newUser.id!);
      }
      
      emit(AuthAuthenticated(newUser));
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء التسجيل'));
    }
  }

  Future<void> updateUser(UserModel user) async {
    emit(AuthLoading());
    try {
      await _userRepository.updateUser(user);
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تحديث البيانات'));
    }
  }

  Future<void> logout(int? userId) async {
    // Unsubscribe user from FCM topic
    if (userId != null) {
      await FCMService().unsubscribeUserFromPersonalTopic(userId);
    }
    emit(AuthInitial());
  }

  Future<void> loadUser(int userId) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.getUserById(userId);
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(AuthError('المستخدم غير موجود'));
      }
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء تحميل بيانات المستخدم'));
    }
  }
}