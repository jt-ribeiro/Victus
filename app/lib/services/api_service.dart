import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // TODO: Update this baseUrl to match your server IP/domain
  static const String baseUrl = 'http://localhost:3000/api';

  // GET request helper
  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  // POST request helper
  Future<dynamic> post(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // PUT request helper
  Future<dynamic> put(String endpoint, {Map<String, dynamic>? body, Map<String, String>? headers}) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: json.encode(body),
    );
    return _handleResponse(response);
  }

  // Response handler
  dynamic _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return json.decode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode}');
    }
  }
}
