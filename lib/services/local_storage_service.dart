import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static const String _userIdKey = 'activeUserId';
  static const String _userRoleKey = 'activeUserRole';

  Future<void> saveSession({
    required String userId,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_userIdKey, userId);
    await prefs.setString(_userRoleKey, role);
  }

  Future<String?> getActiveUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<String?> getActiveUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userRoleKey);
  }

  Future<bool> hasActiveSession() async {
    final userId = await getActiveUserId();
    final role = await getActiveUserRole();

    return userId != null &&
        userId.isNotEmpty &&
        role != null &&
        role.isNotEmpty;
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_userIdKey);
    await prefs.remove(_userRoleKey);
  }
}
