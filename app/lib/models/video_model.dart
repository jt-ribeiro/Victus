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
    return CourseModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      thumbnailUrl: json['thumbnail_url'],
      thumbnailColor: json['thumbnail_color'] ?? '#E5E5E5',
      status: json['status'] ?? 'active',
      progressPercentage: (json['progress_percentage'] ?? 0).toDouble(),
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
    return LessonModel(
      id: json['id'],
      courseId: json['course_id'],
      title: json['title'],
      description: json['description'],
      videoUrl: json['video_url'],
      thumbnailUrl: json['thumbnail_url'],
      durationSeconds: json['duration_seconds'] ?? 0,
      orderIndex: json['order_index'] ?? 0,
      isFree: json['is_free'] == 1 || json['is_free'] == true,
      isCompleted: json['is_completed'] == 1 || json['is_completed'] == true,
      isFavorite: json['is_favorite'] == 1 || json['is_favorite'] == true,
      isLiked: json['is_liked'] == 1 || json['is_liked'] == true,
      lastPositionSeconds: json['last_position_seconds'] ?? 0,
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
    return EventModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      date: json['date'] ?? json['event_date'],
      type: json['type'] ?? json['event_type'],
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
    return ProgressModel(
      currentValue: (json['current_value'] ?? 0).toDouble(),
      targetValue: (json['target_value'] ?? 0).toDouble(),
      unit: json['unit'] ?? 'kg',
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }
}
