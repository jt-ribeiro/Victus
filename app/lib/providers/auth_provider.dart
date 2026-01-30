import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  // Login
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '/auth/login',
        body: {
          'email': email,
          'password': password,
        },
        requiresAuth: false,
      );

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final token = response['data']['token'];

        // Save token
        await _apiService.saveToken(token);

        // Save user data
        _currentUser = UserModel.fromJson(userData);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Erro ao fazer login';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Register
  Future<bool> register(String name, String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.post(
        '/auth/register',
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
        requiresAuth: false,
      );

      if (response['success'] == true) {
        final userData = response['data']['user'];
        final token = response['data']['token'];

        // Save token
        await _apiService.saveToken(token);

        // Save user data
        _currentUser = UserModel.fromJson(userData);

        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Erro ao criar conta';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Get profile (check if token is valid)
  Future<bool> loadProfile() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) return false;

      final response = await _apiService.get('/auth/profile');

      if (response['success'] == true) {
        _currentUser = UserModel.fromJson(response['data']);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    await _apiService.deleteToken();
    _currentUser = null;
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
