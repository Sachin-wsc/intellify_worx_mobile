import 'package:dio/dio.dart';

import 'api_service.dart';

class AuthService {
  final Dio _dio = ApiService().dio;

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {
          'email': email.trim(),
          'password': password,
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return _extractToken(response.data);
      }

      throw AuthException('Login failed (status: ${response.statusCode})');
    } on DioException catch (e) {
      final msg = _extractErrorMessage(e.response?.data) ??
          e.response?.statusMessage ??
          e.message ??
          'Login failed';
      throw AuthException(msg);
    } catch (e) {
      throw AuthException('Login failed');
    }
  }

  String? _extractToken(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      final direct = _readFirstStringKey(data, const [
        'token',
        'access_token',
        'accessToken',
        'jwt',
      ]);
      if (direct != null) return direct;

      final nestedData = data['data'];
      final nested = _extractToken(nestedData);
      if (nested != null) return nested;
    }
    return null;
  }

  String? _extractErrorMessage(dynamic data) {
    if (data == null) return null;
    if (data is Map) {
      final msg = _readFirstStringKey(data, const ['message', 'error', 'msg']);
      if (msg != null) return msg;
      return _extractErrorMessage(data['data']);
    }
    if (data is String && data.trim().isNotEmpty) return data;
    return null;
  }

  String? _readFirstStringKey(Map map, List<String> keys) {
    for (final k in keys) {
      final v = map[k];
      if (v is String && v.trim().isNotEmpty) return v;
    }
    return null;
  }
}

class AuthException implements Exception {
  final String message;
  AuthException(this.message);

  @override
  String toString() => message;
}

