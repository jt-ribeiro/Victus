import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/video_provider.dart';
import '../widgets/video_card.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('My Library'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Favorites',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // TODO: Display favorite videos
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Your favorite videos will appear here',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Continue Watching',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            // TODO: Display videos with saved position
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Videos you started will appear here',
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
