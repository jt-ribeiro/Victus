import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // TODO: Update this baseUrl to match your server IP/domain
  static const String baseUrl = 'http://localhost:3000/api';

  final _storage = const FlutterSecureStorage();

  // Get stored token
  Future<String?> getToken() async {
    return await _storage.read(key: 'auth_token');
  }

  // Save token
  Future<void> saveToken(String token) async {
    await _storage.write(key: 'auth_token', value: token);
  }

  // Delete token
  Future<void> deleteToken() async {
    await _storage.delete(key: 'auth_token');
  }

  // Get headers with authentication
  Future<Map<String, String>> _getHeaders({bool includeAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
    };

    if (includeAuth) {
      final token = await getToken();
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  // GET request helper
  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(includeAuth: requiresAuth);
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // POST request helper
  Future<dynamic> post(String endpoint,
      {Map<String, dynamic>? body, bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(includeAuth: requiresAuth);
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: body != null ? json.encode(body) : json.encode({}),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // PUT request helper
  Future<dynamic> put(String endpoint,
      {Map<String, dynamic>? body, bool requiresAuth = true}) async {
    try {
      final headers = await _getHeaders(includeAuth: requiresAuth);
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: headers,
        body: json.encode(body),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  // Response handler
  dynamic _handleResponse(http.Response response) {
    final data = json.decode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      // Extract error message
      final message = data['message'] ?? 'Erro desconhecido';
      throw Exception(message);
    }
  }
}
