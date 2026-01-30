import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class PlayerScreen extends StatefulWidget {
  final String videoUrl;
  final String title;

  const PlayerScreen({
    Key? key,
    required this.videoUrl,
    required this.title,
  }) : super(key: key);

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    // TODO: Initialize video player with widget.videoUrl
    _videoPlayerController = VideoPlayerController.network(widget.videoUrl);
    await _videoPlayerController.initialize();
    
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: false,
    );
    
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          _chewieController != null
              ? Chewie(controller: _chewieController!)
              : const Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFFE50914),
                  ),
                ),
          // TODO: Add video information and controls
          Expanded(
            child: Container(
              color: Colors.black,
              child: const Center(
                child: Text(
                  'Video Player Placeholder',
                  style: TextStyle(color: Colors.white54),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
