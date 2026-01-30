class VideoModel {
  final int id;
  final String title;
  final String description;
  final String thumbnailUrl;
  final String videoUrl;
  final int categoryId;
  final bool isFavorite;
  final int lastPositionSeconds;

  VideoModel({
    required this.id,
    required this.title,
    required this.description,
    required this.thumbnailUrl,
    required this.videoUrl,
    required this.categoryId,
    this.isFavorite = false,
    this.lastPositionSeconds = 0,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      id: json['id'],
      title: json['title'],
      description: json['description'] ?? '',
      thumbnailUrl: json['thumbnail_url'] ?? '',
      videoUrl: json['video_url'],
      categoryId: json['category_id'],
      isFavorite: json['is_favorite'] ?? false,
      lastPositionSeconds: json['last_position_seconds'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'thumbnail_url': thumbnailUrl,
      'video_url': videoUrl,
      'category_id': categoryId,
      'is_favorite': isFavorite,
      'last_position_seconds': lastPositionSeconds,
    };
  }
}
