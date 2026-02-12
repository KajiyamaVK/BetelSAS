import 'package:betelsas/core/theme/app_theme.dart';
import 'package:betelsas/data/models/lesson.dart';
import 'package:betelsas/presentation/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';

class LessonDetailScreen extends StatelessWidget {
  final Lesson lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                backgroundColor: AppTheme.primaryColor,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.favorite_border_rounded, color: Colors.white),
                    onPressed: () {
                      // Toggle favorite logic
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                       Image.asset(
                         'assets/images/lesson_${lesson.id}.png', // Ensure assets exist or mock
                         fit: BoxFit.cover,
                         errorBuilder: (context, error, stackTrace) => Container(color: AppTheme.primaryColor),
                       ),
                       Container(
                         decoration: BoxDecoration(
                           gradient: LinearGradient(
                             begin: Alignment.topCenter,
                             end: Alignment.bottomCenter,
                             colors: [
                               Colors.transparent,
                               Colors.black.withOpacity(0.7),
                             ],
                           ),
                         ),
                       ),
                       Positioned(
                         bottom: 20,
                         left: 20,
                         right: 20,
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Container(
                               padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                               decoration: BoxDecoration(
                                 color: AppTheme.primaryColor,
                                 borderRadius: BorderRadius.circular(20),
                               ),
                               child: Text(
                                 'LIÇÃO ${lesson.id}',
                                 style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                               ),
                             ),
                             const SizedBox(height: 8),
                             Text(
                               lesson.title,
                               style: AppTheme.heading1.copyWith(color: Colors.white),
                             ),
                             Text(
                               lesson.category,
                               style: AppTheme.bodyText.copyWith(color: Colors.white70),
                             ),
                           ],
                         ),
                       )
                    ],
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildScriptureCard(lesson.scriptureReference),
                      const SizedBox(height: 24),
                      Text(
                        lesson.content, // Simple string for now, could be Markdown
                        style: AppTheme.bodyText.copyWith(height: 1.6, fontSize: 18),
                      ),
                      const SizedBox(height: 100), // Space for audio player
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (lesson.song != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: AudioPlayerWidget(
                audioUrl: lesson.song!.audioUrl,
                title: lesson.song!.title,
                artist: lesson.song!.artist,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildScriptureCard(String reference) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          const Icon(Icons.menu_book_rounded, color: AppTheme.primaryColor),
          const SizedBox(height: 8),
          Text(
            reference,
            style: AppTheme.heading2.copyWith(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
