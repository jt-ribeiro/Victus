import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';
import '../providers/auth_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentPageIndex = 0;
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load dashboard data from API
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).loadDashboard();
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
            SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 80),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(),
                  
                  const SizedBox(height: 16),
                  
                  // Welcome Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildWelcomeCard(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Reminder Card
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: _buildReminderCard(),
                  ),
                ],
              ),
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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Consumer<DashboardProvider>(
            builder: (context, dashboardProvider, _) {
              final userName = dashboardProvider.userName ?? 'Utilizador';
              return Text(
                'Olá, $userName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                ),
              );
            },
          ),
          Row(
            children: [
              _buildIconButton(Icons.people_outline, () {
                // TODO: Navigate to group
              }),
              const SizedBox(width: 12),
              _buildIconButton(Icons.notifications_outlined, () {
                // TODO: Navigate to notifications
              }),
              const SizedBox(width: 12),
              _buildIconButton(Icons.menu, () {
                // TODO: Open menu
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, color: Colors.black, size: 24),
      ),
    );
  }

  Widget _buildWelcomeCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5E6E8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bem-vinda à minha App!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Clica aqui para iniciares a tua jornada',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF666666),
                  ),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {
                    // TODO: Start journey
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Começa aqui',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Pagination dots
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: index == _currentPageIndex
                            ? const Color(0xFFD4989E)
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Image on the right
          Positioned(
            right: 20,
            top: 20,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 120,
                height: 120,
                color: const Color(0xFFD4989E).withOpacity(0.3),
                child: const Icon(
                  Icons.person,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReminderCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5D5D8),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const Text(
            'LEMBRETE DO DIA:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          const Text(
            'É importante agradecer pelo hoje, sem nunca desistir do amanhã!',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Progress Circle
              _buildProgressCircle(),
              const SizedBox(width: 16),
              // Events List
              Expanded(
                child: _buildEventsList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCircle() {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, _) {
        final progress = dashboardProvider.progress;
        final currentValue = progress?.currentValue ?? 0;
        final targetValue = progress?.targetValue ?? 10;
        final percentage = targetValue > 0 ? currentValue / targetValue : 0.0;

        return Container(
          width: 120,
          height: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: CircularProgressIndicator(
                  value: percentage,
                  strokeWidth: 12,
                  backgroundColor: const Color(0xFFF5E6E8),
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFD4A574)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    currentValue.toStringAsFixed(0),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    progress?.unit ?? 'kg',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                    ),
                  ),
                  const Text(
                    'perdidos',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF666666),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventsList() {
    return Consumer<DashboardProvider>(
      builder: (context, dashboardProvider, _) {
        final events = dashboardProvider.events;
        final displayEvents = events.take(2).toList();
        final remainingCount = events.length > 2 ? events.length - 2 : 0;

        return Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF5E6E8),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Próximos eventos:',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 12),
              ...displayEvents.map((event) {
                final date = event.date.split('-').reversed.take(2).join('/');
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _buildEventItem(date, event.title),
                );
              }).toList(),
              if (remainingCount > 0)
                GestureDetector(
                  onTap: () {
                    // TODO: View all events
                  },
                  child: Text(
                    '+ $remainingCount evento${remainingCount > 1 ? 's' : ''}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildEventItem(String date, String title) {
    return Row(
      children: [
        Text(
          date,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.black,
          ),
        ),
      ],
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
              _buildNavItem(2, Icons.book_outlined, Icons.book, 'Biblioteca'),
              _buildNavItem(3, Icons.person_outline, Icons.person, 'Perfil'),
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
