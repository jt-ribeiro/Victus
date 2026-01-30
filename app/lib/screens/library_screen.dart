import 'package:flutter/material.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  int _selectedNavIndex = 3; // Library is active

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
                  child: ListView(
                    padding: const EdgeInsets.only(
                      left: 16,
                      right: 16,
                      bottom: 80, // Space for bottom nav
                    ),
                    children: [
                      _buildLibraryItem(
                        title: 'Liberdade Alimentar',
                        backgroundColor: const Color(0xFF8B2635),
                        hasProgress: true,
                        progress: 0.8,
                      ),
                      const SizedBox(height: 16),
                      _buildLibraryItem(
                        title: 'Olimpo',
                        description: 'Corpo e mente invencíveis.',
                        backgroundColor: const Color(0xFF2C2C2C),
                      ),
                      const SizedBox(height: 16),
                      _buildLibraryItem(
                        title: 'Joanaflix',
                        description: 'Desvenda o poder da nutrição com aulas didáticas.',
                        backgroundColor: const Color(0xFF1A1A1A),
                      ),
                      const SizedBox(height: 16),
                      _buildLibraryItem(
                        title: 'Workshops',
                        description: 'Lorem Ipsum is simply d text\nLorem Ipsum is simply d text',
                        backgroundColor: const Color(0xFFE5E5E5),
                      ),
                      const SizedBox(height: 16),
                      _buildLibraryItem(
                        title: 'Masterclasses',
                        description: 'Lorem Ipsum is simply d\nLorem Ipsum is simply d',
                        backgroundColor: const Color(0xFFE5E5E5),
                      ),
                      const SizedBox(height: 16),
                      _buildLibraryItem(
                        title: 'Desafio Corpo & Mente Sã',
                        description: 'Lorem Ipsum is simply d text',
                        backgroundColor: const Color(0xFFE5E5E5),
                      ),
                    ],
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

  Widget _buildLibraryItem({
    required String title,
    String? description,
    required Color backgroundColor,
    bool hasProgress = false,
    double progress = 0.0,
  }) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to content details
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
              ),
              child: backgroundColor == const Color(0xFFE5E5E5)
                  ? Icon(
                      Icons.image_outlined,
                      size: 40,
                      color: Colors.grey[400],
                    )
                  : Center(
                      child: Text(
                        title[0],
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (hasProgress) ...[
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: progress,
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
                          '${(progress * 100).toInt()}%',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF666666),
                          ),
                        ),
                      ),
                    ] else if (description != null) ...[
                      // Description
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF666666),
                          height: 1.4,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
              _buildNavItem(1, Icons.calendar_today_outlined, Icons.calendar_today, 'Plano'),
              _buildFabButton(),
              _buildNavItem(3, Icons.book_outlined, Icons.book, 'Biblioteca'),
              _buildNavItem(4, Icons.person_outline, Icons.person, 'Perfil'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData inactiveIcon, IconData activeIcon, String label) {
    final isActive = _selectedNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        // TODO: Navigate to respective screen
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
              color: isActive ? const Color(0xFFD4989E) : const Color(0xFFCCCCCC),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: isActive ? const Color(0xFFD4989E) : const Color(0xFFCCCCCC),
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
