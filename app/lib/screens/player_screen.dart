import 'package:flutter/material.dart';

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const PlayerScreen({
    Key? key,
    required this.videoUrl,
    this.title = 'Liberdade Alimentar',
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  int _selectedTabIndex = 0;
  final List<LessonItem> _lessons = [
    LessonItem(id: 1, title: '1 | Bem-vindas', status: LessonStatus.completed),
    LessonItem(id: 2, title: '2 | Guias Alimentares', status: LessonStatus.available),
    LessonItem(id: 3, title: '3 | Alimentação Saudável', status: LessonStatus.locked),
    LessonItem(id: 4, title: '4 | Emagrecimento', status: LessonStatus.locked),
    LessonItem(id: 5, title: '5 | Planeamento Alimentar', status: LessonStatus.locked),
  ];

  bool _isFavorited = false;
  bool _isLiked = true;
  bool _isCompleted = true;
  double _courseProgress = 0.8; // 80%

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Header with progress
                _buildHeader(),
                
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
                        _buildLessonHeader(),
                        
                        // Description
                        _buildDescription(),
                        
                        // Next Lesson
                        _buildNextLesson(),
                        
                        // Lessons List
                        _buildLessonsList(),
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
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
              value: _courseProgress,
              minHeight: 4,
              backgroundColor: const Color(0xFF333333),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4989E)),
            ),
          ),
          const SizedBox(height: 4),
          // Progress Label
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '${(_courseProgress * 100).toInt()}%',
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
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Thumbnail placeholder
          Container(
            color: const Color(0xFF1A1A1A),
            child: const Center(
              child: Icon(
                Icons.live_tv,
                size: 60,
                color: Color(0xFF333333),
              ),
            ),
          ),
          // Play Button
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(
                Icons.play_arrow,
                size: 40,
                color: Colors.black,
              ),
              onPressed: () {
                // TODO: Play video
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonHeader() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Boas-vindas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(
                  _isFavorited ? Icons.star : Icons.star_outline,
                  color: _isFavorited ? const Color(0xFFD4989E) : Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _isFavorited = !_isFavorited;
                  });
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _isLiked ? Icons.favorite : Icons.favorite_border,
                  color: _isLiked ? const Color(0xFFD4989E) : Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _isLiked = !_isLiked;
                  });
                },
              ),
              const SizedBox(width: 8),
              IconButton(
                icon: Icon(
                  _isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                  color: _isCompleted ? const Color(0xFFD4989E) : Colors.white,
                  size: 24,
                ),
                onPressed: () {
                  setState(() {
                    _isCompleted = !_isCompleted;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      color: Colors.black,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: const Text(
        'Lorem ipsum dolor sit amet, consectetur. Malesuada amet magnis senectus in dictum. Egestas fusce facilisis proin gravida elit purus faucibus sit facilisis. Justo proin non ipsum fermentum. Hendrerit imperdiet turpitor molestie mattis.',
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: Color(0xFFCCCCCC),
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildNextLesson() {
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
              const Text(
                'Métodos e princípios',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
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
                    // TODO: Play next lesson
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

  Widget _buildLessonsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: _lessons.map((lesson) => _buildLessonItem(lesson)).toList(),
      ),
    );
  }

  Widget _buildLessonItem(LessonItem lesson) {
    IconData icon;
    Color iconColor;

    switch (lesson.status) {
      case LessonStatus.completed:
        icon = Icons.check_circle;
        iconColor = const Color(0xFFD4989E);
        break;
      case LessonStatus.available:
        icon = Icons.check_circle_outline;
        iconColor = const Color(0xFF666666);
        break;
      case LessonStatus.locked:
        icon = Icons.lock_outline;
        iconColor = const Color(0xFF666666);
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              lesson.title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: lesson.status == LessonStatus.locked
                    ? const Color(0xFF666666)
                    : Colors.white,
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
              _buildNavItem(0, Icons.play_circle_outline, Icons.play_circle, 'Aulas'),
              _buildNavItem(1, Icons.chat_bubble_outline, Icons.chat_bubble, 'Comentários'),
              _buildNavItem(2, Icons.note_outlined, Icons.note, 'Anotações'),
              _buildNavItem(3, Icons.folder_outlined, Icons.folder, 'Materiais'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label) {
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
              color: isActive ? const Color(0xFFD4989E) : const Color(0xFF666666),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? const Color(0xFFD4989E) : const Color(0xFF666666),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Models
class LessonItem {
  final int id;
  final String title;
  final LessonStatus status;

  LessonItem({
    required this.id,
    required this.title,
    required this.status,
  });
}

enum LessonStatus {
  completed,
  available,
  locked,
}
