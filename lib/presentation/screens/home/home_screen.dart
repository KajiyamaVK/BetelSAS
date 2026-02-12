import 'package:betelsas/core/theme/app_theme.dart';
import 'package:betelsas/presentation/screens/home/home_view_model.dart';
import 'package:betelsas/presentation/screens/lesson/lesson_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessonsState = ref.watch(homeViewModelProvider);

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
             SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEEE, d MMMM').format(DateTime.now()).toUpperCase(),
                      style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Vamos aprender\nsobre Deus',
                      style: AppTheme.heading1,
                    ),
                  ],
                ),
              ),
            ),
            lessonsState.when(
              data: (lessons) {
                if (lessons.isEmpty) {
                  return const SliverFillRemaining(
                    child: Center(child: Text('Nenhuma lição encontrada.')),
                  );
                }

                // In a real app, logic to determine "Current Lesson"
                final currentLesson = lessons.first; 

                return SliverList(
                  delegate: SliverChildListDelegate([
                    // Hero Card (Current Lesson)
                    _buildCurrentLessonCard(context, currentLesson),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text('Todas as Lições', style: AppTheme.heading2),
                    ),
                    const SizedBox(height: 10),
                    // List of Lessons
                    ...lessons.map((lesson) => _buildLessonTile(context, lesson)).toList(),
                    const SizedBox(height: 20),
                  ]),
                );
              },
              loading: () => const SliverFillRemaining(
                child: Center(child: CircularProgressIndicator()),
              ),
              error: (err, stack) => SliverFillRemaining(
                child: Center(child: Text('Erro ao carregar lições: $err')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentLessonCard(BuildContext context, dynamic lesson) {
    // Logic to ensure lesson is valid
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LessonDetailScreen(lesson: lesson),
          ),
        );
      },
      child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 200,
      decoration: BoxDecoration(
        color: AppTheme.primaryColor,
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
           image: AssetImage('assets/images/lesson_1.png'), // Placeholder or dynamic
           fit: BoxFit.cover,
           opacity: 0.3, // Dim for text readability
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10),
                  ),
                   child: Text(
                    'LIÇÃO ${lesson.id}',
                    style: AppTheme.caption.copyWith(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  lesson.title,
                  style: AppTheme.heading1.copyWith(color: Colors.white, shadows: [
                    const Shadow(offset: Offset(0, 1), blurRadius: 4, color: Colors.black45)
                  ]),
                ),
                const SizedBox(height: 4),
                // Progress Bar Placeholder
                LinearProgressIndicator(
                  value: 0.3, // Mock progress
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ],
            ),
          ),
          Positioned(
             right: 20,
             bottom: 20,
             child: CircleAvatar(
               backgroundColor: Colors.white,
               radius: 25,
               child: const Icon(Icons.play_arrow_rounded, color: AppTheme.primaryColor, size: 30),
             ),
          )
        ],
      ),
    ));
  }

  Widget _buildLessonTile(BuildContext context, dynamic lesson) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              '${lesson.id}',
              style: AppTheme.heading2.copyWith(color: Colors.grey),
            ),
          ),
        ),
        title: Text(lesson.title, style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text(lesson.category, style: AppTheme.caption),
        trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => LessonDetailScreen(lesson: lesson),
            ),
          );
        },
      ),
    );
  }
}
