import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';

class VideoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<VideoModel> _videos = [];
  VideoModel? _currentVideo;
  bool _isLoading = false;
  String? _errorMessage;

  List<VideoModel> get videos => _videos;
  VideoModel? get currentVideo => _currentVideo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // TODO: Implement fetchVideos logic
  Future<void> fetchVideos() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Placeholder - implement actual API call
      await Future.delayed(const Duration(seconds: 1));
      _videos = [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // TODO: Implement fetchVideosByCategory logic
  Future<void> fetchVideosByCategory(int categoryId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Placeholder - implement actual API call
      await Future.delayed(const Duration(seconds: 1));
      _videos = [];
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  // TODO: Implement toggleFavorite logic
  Future<void> toggleFavorite(int videoId) async {
    // Placeholder - implement actual API call
    notifyListeners();
  }

  // TODO: Implement updatePosition logic
  Future<void> updatePosition(int videoId, int positionSeconds) async {
    // Placeholder - implement actual API call
  }

  void setCurrentVideo(VideoModel video) {
    _currentVideo = video;
    notifyListeners();
  }
}
