import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<DashboardProvider>(context, listen: false).loadDashboard();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // --- HEADER (Olá, Cristiana) ---
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Consumer<DashboardProvider>(
          builder: (context, dashboardProvider, _) {
            final userName = dashboardProvider.userName ?? 'Cristiana';
            return Text(
              'Olá, $userName',
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.groups, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.chat_bubble_outline, color: Colors.black),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // --- BANNER PRINCIPAL ---
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color(0xFFF9ECE9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bem-vinda à minha App!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          "Clica aqui para iniciares a tua jornada",
                          style: TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: const Text(
                              "Começa aqui",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  // Placeholder para a imagem da mulher
                  Positioned(
                    right: -10,
                    bottom: 0,
                    child: Container(
                      height: 160,
                      width: 140,
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          size: 80,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- LEMBRETE DO DIA (Gradiente) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFEBC6C1),
                    Color(0xFFDDB0AC),
                  ],
                ),
              ),
              child: Column(
                children: const [
                  Text(
                    "LEMBRETE DO DIA:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "É importante agradecer pelo hoje,\nsem nunca desistir do amanhã!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, height: 1.4),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // --- GRID: Kilos e Eventos (Lado a Lado) ---
            Row(
              children: [
                // Cartão 1: Kilos Perdidos - DINÂMICO
                Expanded(
                  child: Container(
                    height: 160,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7EBE9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Consumer<DashboardProvider>(
                      builder: (context, dashboardProvider, _) {
                        final progress = dashboardProvider.progress;
                        final currentValue = progress?.currentValue ?? 0;
                        final targetValue = progress?.targetValue ?? 10;
                        final percentage = targetValue > 0
                            ? currentValue / targetValue
                            : 0.0;

                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              width: 100,
                              height: 100,
                              child: CircularProgressIndicator(
                                value: percentage,
                                strokeWidth: 8,
                                backgroundColor: Colors.white,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  Color(0xFFD4AF67),
                                ),
                              ),
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${currentValue.toStringAsFixed(0)}kg",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const Text(
                                  "perdidos",
                                  style: TextStyle(fontSize: 14),
                                ),
                              ],
                            )
                          ],
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(width: 15),

                // Cartão 2: Próximos Eventos - DINÂMICO
                Expanded(
                  child: Container(
                    height: 160,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF2DED9),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Consumer<DashboardProvider>(
                      builder: (context, dashboardProvider, _) {
                        final events = dashboardProvider.events;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Próximos eventos:",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 10),
                            if (events.isEmpty)
                              const Expanded(
                                child: Center(
                                  child: Text(
                                    "Sem eventos",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ),
                              )
                            else ...[
                              if (events.isNotEmpty)
                                _buildEventRow(
                                  events[0]
                                      .date
                                      .split('-')
                                      .reversed
                                      .take(2)
                                      .join('/'),
                                  events[0].title,
                                ),
                              if (events.length > 1) ...[
                                const SizedBox(height: 8),
                                _buildEventRow(
                                  events[1]
                                      .date
                                      .split('-')
                                      .reversed
                                      .take(2)
                                      .join('/'),
                                  events[1].title,
                                ),
                              ],
                              if (events.length > 2) ...[
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    "+ ${events.length - 2} evento${events.length - 2 > 1 ? 's' : ''}",
                                    style: const TextStyle(fontSize: 11),
                                  ),
                                ),
                              ],
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100), // Espaço para o bottom nav
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION BAR (Com o botão a sair para fora) ---
      floatingActionButton: SizedBox(
        height: 70,
        width: 70,
        child: FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFC78D86),
          elevation: 4,
          shape: const CircleBorder(),
          child: const Icon(Icons.add, size: 35, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.restaurant_menu, "Plano", 1),
              const SizedBox(width: 40), // Espaço vazio para o botão central
              _buildNavItem(Icons.video_library_outlined, "Biblioteca", 2),
              _buildNavItem(Icons.person_outline, "Perfil", 3),
            ],
          ),
        ),
      ),
    );
  }

  // Widget auxiliar para as linhas de eventos
  Widget _buildEventRow(String date, String title) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Text(
            date,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 6),
            height: 12,
            width: 1,
            color: Colors.black,
          ),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontSize: 11),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // Widget auxiliar para os itens da navbar
  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedNavIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
        if (index == 2) {
          Navigator.pushNamed(context, '/library');
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: isActive ? const Color(0xFFC78D86) : Colors.grey[400],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isActive ? const Color(0xFFC78D86) : Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}