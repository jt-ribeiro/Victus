import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';

class DashboardProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  String? _userName;
  ProgressModel? _progress;
  List<EventModel> _events = [];
  bool _isLoading = false;
  String? _errorMessage;

  String? get userName => _userName;
  ProgressModel? get progress => _progress;
  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load dashboard data
  Future<void> loadDashboard() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/dashboard');

      if (response['success'] == true) {
        final data = response['data'];

        _userName = data['user_name'];

        if (data['progress'] != null) {
          _progress = ProgressModel.fromJson(data['progress']);
        }

        _isLoading = false;
        notifyListeners();

        // Load events after dashboard loads
        loadEvents();
      } else {
        _errorMessage = response['message'] ?? 'Erro ao carregar dashboard';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load all events
  Future<void> loadEvents() async {
    try {
      final response = await _apiService.get('/events');

      if (response['success'] == true) {
        _events = (response['data'] as List)
            .map((event) => EventModel.fromJson(event))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }
}
