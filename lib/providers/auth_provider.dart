// import 'package:flutter/material.dart';

// import '../services/local_storage_service.dart';

// class AuthProvider with ChangeNotifier {
//   final LocalStorageService _localStorageService = LocalStorageService();

//   String? _activeUserId;
//   String? _activeUserRole;
//   bool _isLoading = false;

//   String? get activeUserId => _activeUserId;
//   String? get activeUserRole => _activeUserRole;
//   bool get isLoading => _isLoading;

//   bool get hasActiveSession {
//     return _activeUserId != null &&
//         _activeUserId!.isNotEmpty &&
//         _activeUserRole != null &&
//         _activeUserRole!.isNotEmpty;
//   }

//   Future<void> loadSession() async {
//     _isLoading = true;
//     notifyListeners();

//     _activeUserId = await _localStorageService.getActiveUserId();
//     _activeUserRole = await _localStorageService.getActiveUserRole();

//     _isLoading = false;
//     notifyListeners();
//   }

//   Future<void> saveSession({
//     required String userId,
//     required String role,
//   }) async {
//     await _localStorageService.saveSession(userId: userId, role: role);

//     _activeUserId = userId;
//     _activeUserRole = role;

//     notifyListeners();
//   }

//   Future<void> clearSession() async {
//     await _localStorageService.clearSession();

//     _activeUserId = null;
//     _activeUserRole = null;

//     notifyListeners();
//   }
// }
