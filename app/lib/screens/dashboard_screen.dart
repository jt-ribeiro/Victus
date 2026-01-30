import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../widgets/video_card.dart';
import '../widgets/category_chip.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // TODO: Fetch videos on init
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Dashboard'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category chips
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Categories',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // TODO: Add CategoryChip widgets here
            const SizedBox(height: 5),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  CategoryChip(title: 'All', isSelected: true, onTap: () {}),
                  const SizedBox(width: 8),
                  CategoryChip(title: 'Action', isSelected: false, onTap: () {}),
                  const SizedBox(width: 8),
                  CategoryChip(title: 'Drama', isSelected: false, onTap: () {}),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Videos grid
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Trending Now',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // TODO: Add VideoCard widgets in a grid
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Videos will appear here',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
