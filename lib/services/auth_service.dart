import 'package:hive_flutter/hive_flutter.dart';
import '../models/user.dart';

class AuthService {
  static const String _usersBoxName = 'users';
  static const String _sessionBoxName = 'session';
  static late Box<User> _usersBox;
  static late Box<String> _sessionBox;

  static Future<void> init() async {
    Hive.registerAdapter(UserAdapter());
    _usersBox = await Hive.openBox<User>(_usersBoxName);
    _sessionBox = await Hive.openBox<String>(_sessionBoxName);
  }

  // Register
  static Future<User> register({
    required String name,
    required String email,
    required String password,
  }) async {
    // Check if email already exists
    final existingUser = _usersBox.values.where(
      (user) => user.email.toLowerCase() == email.toLowerCase(),
    );
    if (existingUser.isNotEmpty) {
      throw Exception('Email sudah terdaftar');
    }

    final id = DateTime.now().millisecondsSinceEpoch.toString();
    final user = User(
      id: id,
      name: name,
      email: email,
      password: _hashPassword(password),
      createdAt: DateTime.now(),
      avatarIndex: '0',
    );

    await _usersBox.put(id, user);
    await _setSession(id);
    return user;
  }

  // Login
  static Future<User> login({
    required String email,
    required String password,
  }) async {
    final hashedPassword = _hashPassword(password);
    final users = _usersBox.values.where(
      (user) =>
          user.email.toLowerCase() == email.toLowerCase() &&
          user.password == hashedPassword,
    );

    if (users.isEmpty) {
      throw Exception('Email atau password salah');
    }

    final user = users.first;
    await _setSession(user.id);
    return user;
  }

  // Logout
  static Future<void> logout() async {
    await _sessionBox.delete('current_user_id');
  }

  // Get current user
  static User? getCurrentUser() {
    final userId = _sessionBox.get('current_user_id');
    if (userId == null) return null;
    return _usersBox.get(userId);
  }

  // Check if logged in
  static bool isLoggedIn() {
    return _sessionBox.get('current_user_id') != null;
  }

  // Check if onboarding is done
  static bool isOnboardingDone() {
    return _sessionBox.get('onboarding_done') == 'true';
  }

  // Set onboarding done
  static Future<void> setOnboardingDone() async {
    await _sessionBox.put('onboarding_done', 'true');
  }

  // Update profile
  static Future<User> updateProfile({
    required String userId,
    String? name,
    String? bio,
    String? avatarIndex,
  }) async {
    final user = _usersBox.get(userId);
    if (user == null) throw Exception('User not found');

    final updatedUser = user.copyWith(
      name: name,
      bio: bio,
      avatarIndex: avatarIndex,
    );

    await _usersBox.put(userId, updatedUser);
    return updatedUser;
  }

  // Simple hash (for demo purposes)
  static String _hashPassword(String password) {
    int hash = 0;
    for (int i = 0; i < password.length; i++) {
      hash = ((hash << 5) - hash) + password.codeUnitAt(i);
      hash = hash & 0xFFFFFFFF;
    }
    return hash.toRadixString(16);
  }

  // Session management
  static Future<void> _setSession(String userId) async {
    await _sessionBox.put('current_user_id', userId);
  }
}
