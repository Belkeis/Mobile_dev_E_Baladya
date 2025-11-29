import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repo/user_repository.dart';
import '../../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository _userRepository;

  AuthCubit(this._userRepository) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _userRepository.login(email, password);
      if (user != null) {
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
      emit(AuthAuthenticated(newUser));
    } catch (e) {
      emit(AuthError('حدث خطأ أثناء التسجيل'));
    }
  }

  void logout() {
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

