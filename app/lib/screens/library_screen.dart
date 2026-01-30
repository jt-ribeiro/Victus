import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../models/video_model.dart';
import 'player_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedNavIndex = 3; // Library is active

  @override
  void initState() {
    super.initState();
    // Load courses from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoProvider>(context, listen: false).loadCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Header
                _buildHeader(),

                // Content List
                Expanded(
                  child: Consumer<VideoProvider>(
                    builder: (context, videoProvider, _) {
                      if (videoProvider.isLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFFD4989E),
                          ),
                        );
                      }

                      if (videoProvider.errorMessage != null) {
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
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => videoProvider.loadCourses(),
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (videoProvider.courses.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.library_books_outlined,
                                size: 48,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Nenhum curso disponível',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.separated(
                        padding: const EdgeInsets.only(
                          left: 16,
                          right: 16,
                          bottom: 80, // Space for bottom nav
                        ),
                        itemCount: videoProvider.courses.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final course = videoProvider.courses[index];
                          return _buildLibraryItem(course);
                        },
                      );
                    },
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
      padding: const EdgeInsets.all(16.0),
      child: const Text(
        'Biblioteca',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700,
          color: Colors.black,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildLibraryItem(CourseModel course) {
    final backgroundColor = _parseColor(course.thumbnailColor);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerScreen(
              courseId: course.id,
              title: course.title,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thumbnail
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(12),
                image: course.thumbnailUrl != null
                    ? DecorationImage(
                        image: NetworkImage(course.thumbnailUrl!),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {},
                      )
                    : null,
              ),
              child: course.thumbnailUrl == null
                  ? Center(
                      child: Text(
                        course.title.isNotEmpty ? course.title[0] : '',
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : null,
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      course.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Always show progress
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: course.progressPercentage / 100,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFD4989E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '${course.progressPercentage.toInt()}%',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF666666),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _parseColor(String colorString) {
    try {
      if (colorString.startsWith('#')) {
        final hexColor = colorString.replaceFirst('#', '');
        return Color(int.parse('FF$hexColor', radix: 16));
      }
    } catch (e) {
      // Return default color on error
    }
    return const Color(0xFFE5E5E5);
  }

  Widget _buildBottomNavigation() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE0E0E0),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Home'),
              _buildNavItem(1, Icons.calendar_today_outlined,
                  Icons.calendar_today, 'Plano'),
              _buildFabButton(),
              _buildNavItem(3, Icons.book_outlined, Icons.book, 'Biblioteca'),
              _buildNavItem(4, Icons.person_outline, Icons.person, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isActive = _selectedNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        if (index == 0) {
          Navigator.pushReplacementNamed(context, '/dashboard');
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : inactiveIcon,
              color:
                  isActive ? const Color(0xFFD4989E) : const Color(0xFFCCCCCC),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive
                    ? const Color(0xFFD4989E)
                    : const Color(0xFFCCCCCC),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFabButton() {
    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xFFD4989E),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4989E).withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () {
          // TODO: Add action
        },
        icon: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
