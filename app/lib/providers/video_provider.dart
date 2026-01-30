import 'package:flutter/material.dart';
import '../models/video_model.dart';
import '../services/api_service.dart';

class VideoProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<CourseModel> _courses = [];
  CourseModel? _selectedCourse;
  List<LessonModel> _lessons = [];
  LessonModel? _currentLesson;
  bool _isLoading = false;
  String? _errorMessage;

  List<CourseModel> get courses => _courses;
  CourseModel? get selectedCourse => _selectedCourse;
  List<LessonModel> get lessons => _lessons;
  LessonModel? get currentLesson => _currentLesson;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load all courses
  Future<void> loadCourses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/courses');

      if (response['success'] == true) {
        _courses = (response['data'] as List)
            .map((course) => CourseModel.fromJson(course))
            .toList();

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Erro ao carregar cursos';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load course details with lessons
  Future<void> loadCourse(int courseId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/courses/$courseId');

      if (response['success'] == true) {
        final data = response['data'];

        _selectedCourse = CourseModel.fromJson(data);
        _lessons = (data['lessons'] as List)
            .map((lesson) => LessonModel.fromJson(lesson))
            .toList();

        _isLoading = false;
        notifyListeners();
      } else {
        _errorMessage = response['message'] ?? 'Erro ao carregar curso';
        _isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Load lesson details
  Future<void> loadLesson(int lessonId) async {
    try {
      final response = await _apiService.get('/lessons/$lessonId');

      if (response['success'] == true) {
        _currentLesson = LessonModel.fromJson(response['data']);
        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Toggle lesson favorite
  Future<void> toggleFavorite(int lessonId) async {
    try {
      final response = await _apiService.post('/lessons/$lessonId/favorite');

      if (response['success'] == true) {
        // Update local state
        final isFavorite = response['data']['is_favorite'];

        if (_currentLesson != null && _currentLesson!.id == lessonId) {
          _currentLesson = LessonModel.fromJson({
            ..._currentLesson!.toJson(),
            'is_favorite': isFavorite,
          });
        }

        // Update in lessons list
        final index = _lessons.indexWhere((l) => l.id == lessonId);
        if (index != -1) {
          _lessons[index] = LessonModel.fromJson({
            ..._lessons[index].toJson(),
            'is_favorite': isFavorite,
          });
        }

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Toggle lesson like
  Future<void> toggleLike(int lessonId) async {
    try {
      final response = await _apiService.post('/lessons/$lessonId/like');

      if (response['success'] == true) {
        final isLiked = response['data']['is_liked'];

        if (_currentLesson != null && _currentLesson!.id == lessonId) {
          _currentLesson = LessonModel.fromJson({
            ..._currentLesson!.toJson(),
            'is_liked': isLiked,
          });
        }

        final index = _lessons.indexWhere((l) => l.id == lessonId);
        if (index != -1) {
          _lessons[index] = LessonModel.fromJson({
            ..._lessons[index].toJson(),
            'is_liked': isLiked,
          });
        }

        notifyListeners();
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Mark lesson as complete
  Future<void> markComplete(int lessonId) async {
    try {
      final response = await _apiService.post('/lessons/$lessonId/complete');

      if (response['success'] == true) {
        final isCompleted = response['data']['is_completed'];

        if (_currentLesson != null && _currentLesson!.id == lessonId) {
          _currentLesson = LessonModel.fromJson({
            ..._currentLesson!.toJson(),
            'is_completed': isCompleted,
          });
        }

        final index = _lessons.indexWhere((l) => l.id == lessonId);
        if (index != -1) {
          _lessons[index] = LessonModel.fromJson({
            ..._lessons[index].toJson(),
            'is_completed': isCompleted,
          });
        }

        notifyListeners();

        // Reload course to update progress
        if (_selectedCourse != null) {
          loadCourse(_selectedCourse!.id);
        }
      }
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // Update video position
  Future<void> updatePosition(int lessonId, int positionSeconds) async {
    try {
      await _apiService.put(
        '/lessons/$lessonId/position',
        body: {'position': positionSeconds},
      );
    } catch (e) {
      // Silent fail for position updates
    }
  }
}

// Extension to convert LessonModel to JSON
extension LessonModelExtension on LessonModel {
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'title': title,
      'description': description,
      'video_url': videoUrl,
      'thumbnail_url': thumbnailUrl,
      'duration_seconds': durationSeconds,
      'order_index': orderIndex,
      'is_free': isFree,
      'is_completed': isCompleted,
      'is_favorite': isFavorite,
      'is_liked': isLiked,
      'last_position_seconds': lastPositionSeconds,
    };
  }
}
