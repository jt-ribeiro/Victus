class CourseModel {
  final int id;
  final String title;
  final String? description;
  final String? thumbnailUrl;
  final String thumbnailColor;
  final String status;
  final double progressPercentage;
  final bool isFavorite;

  CourseModel({
    required this.id,
    required this.title,
    this.description,
    this.thumbnailUrl,
    required this.thumbnailColor,
    required this.status,
    this.progressPercentage = 0.0,
    this.isFavorite = false,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing for progress_percentage (can be String or num from MySQL)
    double parseProgress(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      thumbnailColor: json['thumbnail_color'] ?? '#E5E5E5',
      status: json['status'] ?? 'active',
      progressPercentage: parseProgress(json['progress_percentage']),
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
    );
  }
}

class LessonModel {
  final int id;
  final int courseId;
  final String title;
  final String? description;
  final String? videoUrl;
  final String? thumbnailUrl;
  final int durationSeconds;
  final int orderIndex;
  final bool isFree;
  final bool isCompleted;
  final bool isFavorite;
  final bool isLiked;
  final int lastPositionSeconds;

  LessonModel({
    required this.id,
    required this.courseId,
    required this.title,
    this.description,
    this.videoUrl,
    this.thumbnailUrl,
    this.durationSeconds = 0,
    this.orderIndex = 0,
    this.isFree = false,
    this.isCompleted = false,
    this.isFavorite = false,
    this.isLiked = false,
    this.lastPositionSeconds = 0,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing for int fields (can be null or String from MySQL)
    int parseInt(dynamic value, {int defaultValue = 0}) {
      if (value == null) return defaultValue;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? defaultValue;
      if (value is double) return value.toInt();
      return defaultValue;
    }

    return LessonModel(
      id: parseInt(json['id']),
      courseId: parseInt(json['course_id']),
      title: json['title'] ?? '',
      description: json['description'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      durationSeconds: parseInt(json['duration_seconds']),
      orderIndex: parseInt(json['order_index']),
      isFree: json['is_free'] == 1 || json['is_free'] == true,
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
      lastPositionSeconds: parseInt(json['last_position_seconds']),
    );
  }

  // Helper to check if lesson is locked
  bool get isLocked => !isFree && !isCompleted;
}

class EventModel {
  final int id;
  final String title;
  final String? description;
  final String date;
  final String type;

  EventModel({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.type,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing for id
    int parseInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    return EventModel(
      id: parseInt(json['id']),
      title: json['title'] ?? '',
      description: json['description'],
      date: json['date'] ?? json['event_date'] ?? '',
      type: json['type'] ?? json['event_type'] ?? 'workshop',
    );
  }
}

class ProgressModel {
  final double currentValue;
  final double targetValue;
  final String unit;
  final double percentage;

  ProgressModel({
    required this.currentValue,
    required this.targetValue,
    required this.unit,
    required this.percentage,
  });

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    // Safe parsing for numeric fields
    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is num) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    return ProgressModel(
      currentValue: parseDouble(json['current_value']),
      targetValue: parseDouble(json['target_value']),
      unit: json['unit'] ?? 'kg',
      percentage: parseDouble(json['percentage']),
    );
  }
}
