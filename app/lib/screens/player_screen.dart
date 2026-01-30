import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../providers/video_provider.dart';
import '../models/video_model.dart';

class PlayerScreen extends StatefulWidget {
  final int courseId;
  final String title;

  const PlayerScreen({
    Key? key,
    required this.courseId,
    required this.title,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int _selectedTabIndex = 0;
  VideoPlayerController? _videoPlayerController;
  ChewieController? _chewieController;
  int? _currentLessonIndex;
  bool _isVideoInitializing = false;

  @override
  void initState() {
    super.initState();
    // Load course data from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCourseData();
    });
  }

  Future<void> _loadCourseData() async {
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    await videoProvider.loadCourse(widget.courseId);

    // Auto-play first available lesson
    if (videoProvider.lessons.isNotEmpty) {
      final firstPlayableIndex = videoProvider.lessons.indexWhere((l) =>
          l.isFree || l.isCompleted || videoProvider.lessons.indexOf(l) == 0);
      if (firstPlayableIndex != -1) {
        _playLesson(firstPlayableIndex);
      }
    }
  }

  Future<void> _playLesson(int index) async {
    if (_isVideoInitializing) return;

    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    if (index < 0 || index >= videoProvider.lessons.length) return;

    final lesson = videoProvider.lessons[index];

    // Check if lesson is locked
    if (!lesson.isFree && !lesson.isCompleted && index > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Esta aula está bloqueada. Complete as aulas anteriores.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (lesson.videoUrl == null || lesson.videoUrl!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('URL do vídeo não disponível'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isVideoInitializing = true;
      _currentLessonIndex = index;
    });

    // Dispose previous controllers
    await _disposeVideoControllers();

    try {
      // Initialize video player
      _videoPlayerController = VideoPlayerController.networkUrl(
        Uri.parse(lesson.videoUrl!),
      );

      await _videoPlayerController!.initialize();

      // Seek to last position if exists
      if (lesson.lastPositionSeconds > 0) {
        await _videoPlayerController!.seekTo(
          Duration(seconds: lesson.lastPositionSeconds),
        );
      }

      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController!,
        autoPlay: true,
        looping: false,
        aspectRatio: 16 / 9,
        placeholder: Container(
          color: Colors.black,
          child: const Center(
            child: CircularProgressIndicator(color: Color(0xFFD4989E)),
          ),
        ),
        materialProgressColors: ChewieProgressColors(
          playedColor: const Color(0xFFD4989E),
          handleColor: const Color(0xFFD4989E),
          bufferedColor: Colors.grey,
          backgroundColor: Colors.grey[800]!,
        ),
      );

      // Listen for position changes to save progress
      _videoPlayerController!.addListener(_onVideoPositionChanged);

      // Load lesson details
      await videoProvider.loadLesson(lesson.id);

      setState(() {
        _isVideoInitializing = false;
      });
    } catch (e) {
      setState(() {
        _isVideoInitializing = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar vídeo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onVideoPositionChanged() {
    if (_videoPlayerController == null ||
        !_videoPlayerController!.value.isInitialized) {
      return;
    }

    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    final position = _videoPlayerController!.value.position.inSeconds;

    // Save position every 5 seconds
    if (position > 0 && position % 5 == 0 && _currentLessonIndex != null) {
      final lesson = videoProvider.lessons[_currentLessonIndex!];
      videoProvider.updatePosition(lesson.id, position);
    }
  }

  Future<void> _disposeVideoControllers() async {
    _videoPlayerController?.removeListener(_onVideoPositionChanged);
    _chewieController?.dispose();
    await _videoPlayerController?.dispose();
    _chewieController = null;
    _videoPlayerController = null;
  }

  @override
  void dispose() {
    _disposeVideoControllers();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Consumer<VideoProvider>(
          builder: (context, videoProvider, _) {
            if (videoProvider.isLoading && videoProvider.lessons.isEmpty) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFD4989E),
                ),
              );
            }

            if (videoProvider.errorMessage != null &&
                videoProvider.lessons.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 48,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      videoProvider.errorMessage!,
                      style: TextStyle(
                        color: Colors.grey[400],
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _loadCourseData,
                      child: const Text('Tentar novamente'),
                    ),
                  ],
                ),
              );
            }

            final course = videoProvider.selectedCourse;
            final lessons = videoProvider.lessons;
            final currentLesson = _currentLessonIndex != null &&
                    _currentLessonIndex! < lessons.length
                ? lessons[_currentLessonIndex!]
                : null;

            return Stack(
              children: [
                Column(
                  children: [
                    // Header with progress
                    _buildHeader(course),

                    // Scrollable Content
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.only(bottom: 80),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Video Player
                            _buildVideoPlayer(),

                            // Lesson Header
                            if (currentLesson != null)
                              _buildLessonHeader(currentLesson, videoProvider),

                            // Description
                            if (currentLesson != null)
                              _buildDescription(currentLesson),

                            // Next Lesson
                            if (_currentLessonIndex != null &&
                                _currentLessonIndex! < lessons.length - 1)
                              _buildNextLesson(
                                  lessons[_currentLessonIndex! + 1]),

                            // Lessons List
                            _buildLessonsList(lessons),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Bottom Navigation
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _buildBottomNavigation(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(CourseModel? course) {
    final progress = course?.progressPercentage ?? 0;

    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Title Row with Back Button
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 40), // Balance the back button
            ],
          ),
          const SizedBox(height: 8),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress / 100,
              minHeight: 4,
              backgroundColor: const Color(0xFF333333),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFFD4989E)),
            ),
          ),
          const SizedBox(height: 4),
          // Progress Label
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${progress.toInt()}%',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    return Container(
      height: 220,
      color: const Color(0xFF1A1A1A),
      child: _isVideoInitializing
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFD4989E)),
            )
          : _chewieController != null &&
                  _videoPlayerController != null &&
                  _videoPlayerController!.value.isInitialized
              ? Chewie(controller: _chewieController!)
              : Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.play_circle_outline,
                        size: 64,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seleciona uma aula para reproduzir',
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildLessonHeader(LessonModel lesson, VideoProvider videoProvider) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              lesson.title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  lesson.isFavorite ? Icons.star : Icons.star_outline,
                  color: lesson.isFavorite
                      ? const Color(0xFFD4989E)
                      : Colors.white,
                  size: 24,
                ),
                onPressed: () => videoProvider.toggleFavorite(lesson.id),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  lesson.isLiked ? Icons.favorite : Icons.favorite_border,
                  color:
                      lesson.isLiked ? const Color(0xFFD4989E) : Colors.white,
                  size: 24,
                ),
                onPressed: () => videoProvider.toggleLike(lesson.id),
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  lesson.isCompleted
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: lesson.isCompleted
                      ? const Color(0xFFD4989E)
                      : Colors.white,
                  size: 24,
                ),
                onPressed: () => videoProvider.markComplete(lesson.id),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(LessonModel lesson) {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Text(
        lesson.description ?? 'Sem descrição disponível.',
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFCCCCCC),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildNextLesson(LessonModel nextLesson) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Próxima aula',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: Color(0xFF999999),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  nextLesson.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Color(0xFFD4A574),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.play_arrow,
                    color: Colors.black,
                    size: 24,
                  ),
                  onPressed: () {
                    final videoProvider =
                        Provider.of<VideoProvider>(context, listen: false);
                    final nextIndex = videoProvider.lessons.indexOf(nextLesson);
                    _playLesson(nextIndex);
                  },
                  padding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLessonsList(List<LessonModel> lessons) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          return _buildLessonItem(lesson, index);
        }).toList(),
      ),
    );
  }

  Widget _buildLessonItem(LessonModel lesson, int index) {
    IconData icon;
    Color iconColor;
    bool isCurrentLesson = _currentLessonIndex == index;

    // Determine status
    bool isLocked = !lesson.isFree && !lesson.isCompleted && index > 0;

    // Check if previous lessons are completed
    final videoProvider = Provider.of<VideoProvider>(context, listen: false);
    if (index > 0) {
      bool previousCompleted = true;
      for (int i = 0; i < index; i++) {
        if (!videoProvider.lessons[i].isCompleted &&
            !videoProvider.lessons[i].isFree) {
          previousCompleted = false;
          break;
        }
      }
      isLocked = !lesson.isFree && !lesson.isCompleted && !previousCompleted;
    }

    if (lesson.isCompleted) {
      icon = Icons.check_circle;
      iconColor = const Color(0xFFD4989E);
    } else if (isLocked) {
      icon = Icons.lock_outline;
      iconColor = const Color(0xFF666666);
    } else {
      icon = Icons.check_circle_outline;
      iconColor = const Color(0xFF666666);
    }

    return GestureDetector(
      onTap: () => _playLesson(index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isCurrentLesson
              ? const Color(0xFF2A2A2A)
              : const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(12),
          border: isCurrentLesson
              ? Border.all(color: const Color(0xFFD4989E), width: 1)
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                '${index + 1} | ${lesson.title}',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: isLocked ? const Color(0xFF666666) : Colors.white,
                ),
              ),
            ),
            Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(
          top: BorderSide(
            color: Color(0xFF1A1A1A),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                  0, Icons.play_circle_outline, Icons.play_circle, 'Aulas'),
              _buildNavItem(1, Icons.chat_bubble_outline, Icons.chat_bubble,
                  'Comentários'),
              _buildNavItem(2, Icons.note_outlined, Icons.note, 'Anotações'),
              _buildNavItem(
                  3, Icons.folder_outlined, Icons.folder, 'Materiais'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isActive = _selectedTabIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTabIndex = index;
        });
        // TODO: Switch tab content
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color:
                  isActive ? const Color(0xFFD4989E) : const Color(0xFF666666),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFFD4989E)
                    : const Color(0xFF666666),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
