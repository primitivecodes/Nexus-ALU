import 'package:shared_preferences/shared_preferences.dart';

class UserModel {
  final String email;
  final String name;
  final String role; // 'student' | 'staff'
  final String cohort;
  final String avatar;

  UserModel({
    required this.email,
    required this.name,
    required this.role,
    required this.cohort,
    required this.avatar,
  });

  bool get isStaff => role == 'staff';
}

class AuthService {
  static UserModel? _currentUser;

  static UserModel? get currentUser => _currentUser;
  static bool get isLoggedIn => _currentUser != null;

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('user_email');
    final name = prefs.getString('user_name');
    final role = prefs.getString('user_role');
    final cohort = prefs.getString('user_cohort') ?? '';
    if (email != null && name != null && role != null) {
      _currentUser = UserModel(
        email: email,
        name: name,
        role: role,
        cohort: cohort,
        avatar: _avatarFromName(name),
      );
    }
  }

  static String _roleFromEmail(String email) {
    return email.toLowerCase().endsWith('@alueducation.com')
        ? 'staff'
        : 'student';
  }

  static String _avatarFromName(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static Future<String?> signUp({
    required String email,
    required String name,
    required String password,
    required String cohort,
  }) async {
    if (email.isEmpty || name.isEmpty || password.isEmpty) {
      return 'All fields are required';
    }
    if (!email.contains('@')) return 'Invalid email address';
    if (password.length < 6) return 'Password must be at least 6 characters';

    final prefs = await SharedPreferences.getInstance();
    final existingEmail = prefs.getString('user_email');
    if (existingEmail == email)
      return 'An account with this email already exists';

    final role = _roleFromEmail(email);
    await prefs.setString('user_email', email);
    await prefs.setString('user_name', name);
    await prefs.setString('user_password', password);
    await prefs.setString('user_role', role);
    await prefs.setString('user_cohort', cohort);

    _currentUser = UserModel(
      email: email,
      name: name,
      role: role,
      cohort: cohort,
      avatar: _avatarFromName(name),
    );
    return null;
  }

  static Future<String?> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) return 'All fields are required';

    final prefs = await SharedPreferences.getInstance();
    final storedEmail = prefs.getString('user_email');
    final storedPassword = prefs.getString('user_password');
    final storedName = prefs.getString('user_name');
    final storedRole = prefs.getString('user_role');
    final storedCohort = prefs.getString('user_cohort') ?? '';

    if (storedEmail != email) return 'No account found with this email';
    if (storedPassword != password) return 'Incorrect password';

    _currentUser = UserModel(
      email: email,
      name: storedName ?? 'User',
      role: storedRole ?? 'student',
      cohort: storedCohort,
      avatar: _avatarFromName(storedName ?? 'User'),
    );
    return null;
  }

  static Future<void> logout() async {
    _currentUser = null;
  }
}
