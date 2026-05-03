import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';
import 'session_service.dart';

class UserService {
  Box<UserModel> get _userBox => Hive.box<UserModel>('users');
  final _uuid = const Uuid();
  final SessionService _sessionService = SessionService();

  Future<UserModel> registerUser({
    required String fullName,
    required String phone,
    required String password,
    required String role,
    required String location,
  }) async {
    // Check if phone already exists
    final existingUsers = _userBox.values.where((u) => u.phone == phone);
    if (existingUsers.isNotEmpty) {
      throw Exception('A user with this phone number already exists.');
    }

    final id = _uuid.v4();
    final newUser = UserModel(
      id: id,
      fullName: fullName,
      phone: phone,
      password: password,
      role: role,
      location: location,
      createdAt: DateTime.now(),
    );

    await _userBox.put(id, newUser);
    await _sessionService.login(id);
    return newUser;
  }

  Future<UserModel?> loginUser(String phone, String password) async {
    try {
      final user = _userBox.values.firstWhere(
        (u) => u.phone == phone && u.password == password,
      );
      await _sessionService.login(user.id);
      return user;
    } catch (e) {
      return null;
    }
  }

  UserModel? getUserById(String id) {
    return _userBox.get(id);
  }

  Future<void> updateUser(UserModel user) async {
    await _userBox.put(user.id, user);
  }
}
