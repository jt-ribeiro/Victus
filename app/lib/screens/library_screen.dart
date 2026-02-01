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
  // 0: Home, 1: Plano, 2: Biblioteca, 3: Perfil
  int _selectedNavIndex = 2; 

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
      
      // --- BODY ---
      body: SafeArea(
        child: Column(
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
                        color: Color(0xFFC78D86), // Cor ajustada
                      ),
                    );
                  }

                  if (videoProvider.errorMessage != null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            videoProvider.errorMessage!,
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => videoProvider.loadCourses(),
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC78D86)),
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
                          Icon(Icons.library_books_outlined, size: 48, color: Colors.grey[400]),
                          const SizedBox(height: 16),
                          Text(
                            'Nenhum curso disponível',
                            style: TextStyle(color: Colors.grey[600], fontSize: 16),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    itemCount: videoProvider.courses.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
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
      ),

      // --- FAB ---
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () {
            // Ação do botão Mais
          },
          backgroundColor: const Color(0xFFC78D86), // Terra Rosa
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 32, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // --- BOTTOM NAVIGATION ---
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        elevation: 10,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home, "Home"),
              _buildNavItem(1, Icons.restaurant_menu, "Plano"),
              const SizedBox(width: 40), // Espaço para o FAB
              _buildNavItem(2, Icons.video_library_outlined, "Biblioteca"),
              _buildProfileNavItem(3, "Perfil"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity, // Força o container a ocupar a largura total
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0), // Ajuste das margens
      child: const Text(
        'Biblioteca',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w700, // Negrito igual ao dashboard
          color: Colors.black,
        ),
        textAlign: TextAlign.left, // Alinha à esquerda
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
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: course.progressPercentage / 100,
                        minHeight: 6,
                        backgroundColor: const Color(0xFFE0E0E0),
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Color(0xFFC78D86), // Cor ajustada
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

  // --- NAV ITEMS (Igual ao Dashboard) ---

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = _selectedNavIndex == index;
    final color = isActive ? const Color(0xFFC78D86) : Colors.grey[400];

    return InkWell(
      onTap: () {
        setState(() => _selectedNavIndex = index);
        if (index == 0) {
          // Exemplo de navegação para voltar à home
          Navigator.pushNamedAndRemoveUntil(context, '/dashboard', (route) => false);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
                fontSize: 10,
                color: color,
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileNavItem(int index, String label) {
    final isActive = _selectedNavIndex == index;
    
    return InkWell(
      onTap: () => setState(() => _selectedNavIndex = index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey[300], // Fundo cinza (placeholder)
              border: isActive 
                  ? Border.all(color: const Color(0xFFC78D86), width: 2) 
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label, 
            style: TextStyle(
              fontSize: 10, 
              color: isActive ? const Color(0xFFC78D86) : Colors.grey[400], 
              fontWeight: isActive ? FontWeight.bold : FontWeight.normal
            )
          ),
        ],
      ),
    );
  }
}