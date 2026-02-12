import 'package:betelsas/core/providers.dart';
import 'package:betelsas/data/models/lesson.dart';
import 'package:betelsas/data/models/song.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoritesViewModelProvider = StateNotifierProvider<FavoritesViewModel, AsyncValue<List<dynamic>>>((ref) {
  return FavoritesViewModel(ref);
});

class FavoritesViewModel extends StateNotifier<AsyncValue<List<dynamic>>> {
  final Ref _ref;

  FavoritesViewModel(this._ref) : super(const AsyncValue.loading()) {
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final db = await _ref.read(databaseHelperProvider).database;
      final savedFavorites = await db.query('favorites');
      
      // In a real app complexity, we'd have a better way to hydrate
      // For now, load all content and match IDs
      final contentRepo = _ref.read(contentRepositoryProvider);
      final lessons = await contentRepo.loadLessons();
      final songs = lessons.where((l) => l.song != null).map((l) => l.song!).toList();

      final List<dynamic> favoriteItems = [];

      for (var fav in savedFavorites) {
        final type = fav['type'] as String;
        final id = fav['item_id'] as String;

        if (type == 'lesson') {
           // Lesson ID is int in our model, strict check needed
           final lessonId = int.tryParse(id);
           final lesson = lessons.firstWhere((l) => l.id == lessonId, orElse: () => lessons.first); // fallback bad
           if (lesson.id == lessonId) favoriteItems.add(lesson);
        } else if (type == 'song') {
           try {
             final song = songs.firstWhere((s) => s.id == id);
             favoriteItems.add(song);
           } catch (_) {}
        }
      }
      
      state = AsyncValue.data(favoriteItems);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
