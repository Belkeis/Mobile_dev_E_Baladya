import '../database/database_helper.dart';
import '../models/user_model.dart';

class UserRepository {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  Future<int> createUser(UserModel user) async {
    return await _dbHelper.insertUser(user);
  }

  Future<UserModel?> getUserByEmail(String email) async {
    return await _dbHelper.getUserByEmail(email);
  }

  Future<UserModel?> getUserById(int id) async {
    return await _dbHelper.getUserById(id);
  }

  Future<UserModel?> login(String email, String password) async {
    final user = await getUserByEmail(email);
    if (user != null && user.password == password) {
      return user;
    }
    return null;
  }
}

