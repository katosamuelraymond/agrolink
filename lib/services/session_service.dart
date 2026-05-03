import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class SessionService {
  Box get _sessionBox => Hive.box('session');
  Box<UserModel> get _userBox => Hive.box<UserModel>('users');

  static const String _currentUserKey = 'current_user_id';

  // Check if a user is logged in
  bool get isLoggedIn => _sessionBox.containsKey(_currentUserKey);

  // Get current user ID
  String? get currentUserId => _sessionBox.get(_currentUserKey);

  // Get current user object
  UserModel? get currentUser {
    final id = currentUserId;
    if (id != null) {
      return _userBox.get(id);
    }
    return null;
  }

  // Login a user
  Future<void> login(String userId) async {
    await _sessionBox.put(_currentUserKey, userId);
  }

  // Logout
  Future<void> logout() async {
    await _sessionBox.delete(_currentUserKey);
  }
}
