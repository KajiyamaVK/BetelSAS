import 'package:betelsas/core/theme/app_theme.dart';
import 'package:betelsas/presentation/screens/music/music_view_model.dart';
import 'package:betelsas/presentation/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MusicScreen extends ConsumerStatefulWidget {
  const MusicScreen({super.key});

  @override
  ConsumerState<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends ConsumerState<MusicScreen> {
  // Simple state to track currently playing song for the bottom player
  // In a real app, this would be global state
  String? _currentAudioUrl;
  String? _currentTitle;
  String? _currentArtist;

  @override
  Widget build(BuildContext context) {
    final songsState = ref.watch(musicViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Músicas'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTheme.heading2,
      ),
      body: Stack(
        children: [
          songsState.when(
            data: (songs) {
              if (songs.isEmpty) {
                return const Center(child: Text('Nenhuma música encontrada.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(20, 10, 20, 100), // Space for player
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  final song = songs[index];
                  final isPlayingThis = _currentAudioUrl == song.audioUrl;

                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: isPlayingThis ? AppTheme.primaryColor : AppTheme.scaffoldBackgroundColor,
                        child: Icon(
                          isPlayingThis ? Icons.graphic_eq_rounded : Icons.music_note_rounded,
                          color: isPlayingThis ? Colors.white : Colors.grey,
                        ),
                      ),
                      title: Text(song.title, style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold)),
                      subtitle: Text(song.artist, style: AppTheme.caption),
                      trailing: IconButton(
                        icon: Icon(
                          isPlayingThis ? Icons.pause_circle_filled_rounded : Icons.play_circle_fill_rounded,
                          color: AppTheme.primaryColor,
                          size: 32,
                        ),
                        onPressed: () {
                          setState(() {
                            if (isPlayingThis) {
                              // Stop/Pause logic would go here if we had full control
                              // For now just re-selecting logic
                              // _currentAudioUrl = null; 
                            } else {
                              _currentAudioUrl = song.audioUrl;
                              _currentTitle = song.title;
                              _currentArtist = song.artist;
                            }
                          });
                        },
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, s) => Center(child: Text('Erro: $e')),
          ),
          
          if (_currentAudioUrl != null)
             Align(
               alignment: Alignment.bottomCenter,
               child: AudioPlayerWidget(
                  // We likely need a UniqueKey to force rebuild/reload source when song changes
                  key: ValueKey(_currentAudioUrl),
                  audioUrl: _currentAudioUrl!,
                  title: _currentTitle!,
                  artist: _currentArtist!,
               ),
             ),
        ],
      ),
    );
  }
}
