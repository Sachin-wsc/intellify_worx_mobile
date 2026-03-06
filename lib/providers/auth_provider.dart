import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../services/api_service.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  bool _isLoading = false;
  String? _errorMessage;
  String? _token;
  String? _email;

  static const _tokenKey = 'auth_token';
  final AuthService _authService = AuthService();

  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get token => _token;
  String? get email => _email;

  AuthProvider();

  void initializeSession(String? token) {
    if (token != null && token.trim().isNotEmpty) {
      _token = token;
      _isAuthenticated = true;
      _extractUserFromToken(token);
      ApiService().setAuthToken(token);
    }
  }


  Future<void> login(String email, String password) async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final token = await _authService.login(
        email: email,
        password: password,
      );

      if (token == null || token.trim().isEmpty) {
        throw AuthException('Login response did not include a token');
      }

      _token = token;
      _isAuthenticated = true;
      _extractUserFromToken(token);

      ApiService().setAuthToken(token);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      _isAuthenticated = false;
      _token = null;
      _email = null;
      _errorMessage = e.toString();
      ApiService().clearAuthToken();
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() {
    _isAuthenticated = false;
    _token = null;
    _email = null;
    _errorMessage = null;
    ApiService().clearAuthToken();
    SharedPreferences.getInstance().then((prefs) => prefs.remove(_tokenKey));
    notifyListeners();
  }



  void _extractUserFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length == 3) {
        final payloadStr = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
        final payload = jsonDecode(payloadStr);
        _email = payload['email'] as String?;
      }
    } catch (_) {}
  }
}
