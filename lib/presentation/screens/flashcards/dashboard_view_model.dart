import 'package:betelsas/data/models/flashcard.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:betelsas/core/providers.dart';

final flashcardDashboardProvider = StateNotifierProvider<FlashcardDashboardViewModel, AsyncValue<List<Flashcard>>>((ref) {
  return FlashcardDashboardViewModel(ref);
});

class FlashcardDashboardViewModel extends StateNotifier<AsyncValue<List<Flashcard>>> {
  final Ref _ref;

  FlashcardDashboardViewModel(this._ref) : super(const AsyncValue.loading()) {
    loadDueFlashcards();
  }

  Future<void> loadDueFlashcards() async {
    try {
      final repository = _ref.read(flashcardRepositoryProvider);
      final dueCards = await repository.getDueFlashcards();
      state = AsyncValue.data(dueCards);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}
