import 'package:audioplayers/audioplayers.dart';
import 'package:betelsas/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;
  final String title;
  final String artist;

  const AudioPlayerWidget({
    super.key,
    required this.audioUrl,
    required this.title,
    required this.artist,
  });

  @override
  State<AudioPlayerWidget> createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _player;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    
    // In a real app, you'd bind this to a global audio service
    // For now, we just set up local listeners
    _player.onPlayerStateChanged.listen((state) {
      if (mounted) setState(() => _isPlaying = state == PlayerState.playing);
    });

    _player.onDurationChanged.listen((newDuration) {
      if (mounted) setState(() => _duration = newDuration);
    });

    _player.onPositionChanged.listen((newPosition) {
      if (mounted) setState(() => _position = newPosition);
    });
    
    _initAudio();
  }
  
  Future<void> _initAudio() async {
      // Logic to set source. 
      // If assets/audio/..., use AssetSource
      // For now, we assume it's an asset path like 'assets/audio/lesson_1.mp3'
      // To use AssetSource, we need the path relative to assets/ IF we use AudioCache (old)
      // Or full path? AudioPlayers usually takes 'audio/lesson_1.mp3' if it's in assets.
      // Let's assume the string passed includes 'assets/'. 
      // We might need to parse it.
       try {
         if (widget.audioUrl.startsWith('assets/')) {
            // Remove 'assets/' prefix for AssetSource
            final path = widget.audioUrl.replaceFirst('assets/', '');
            await _player.setSource(AssetSource(path));
         } else {
             await _player.setSource(UrlSource(widget.audioUrl));
         }
       } catch(e) {
           print("Error loading audio: $e");
       }
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          )
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.music_note_rounded, color: AppTheme.primaryColor),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.title, style: AppTheme.heading2.copyWith(fontSize: 16)),
                      Text(widget.artist, style: AppTheme.caption),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (_isPlaying) {
                      _player.pause();
                    } else {
                      _player.resume();
                    }
                  },
                  icon: Icon(
                    _isPlaying ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                    size: 48,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(_formatTime(_position), style: AppTheme.caption),
                Expanded(
                  child: Slider(
                    min: 0,
                    max: _duration.inSeconds.toDouble(),
                    value: _position.inSeconds.toDouble().clamp(0, _duration.inSeconds.toDouble()),
                    activeColor: AppTheme.primaryColor,
                    onChanged: (value) async {
                       final position = Duration(seconds: value.toInt());
                       await _player.seek(position);
                    },
                  ),
                ),
                Text(_formatTime(_duration), style: AppTheme.caption),
              ],
            )
          ],
        ),
      ),
    );
  }
}
