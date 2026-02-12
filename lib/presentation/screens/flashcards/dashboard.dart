import 'package:betelsas/core/theme/app_theme.dart';
import 'package:betelsas/presentation/screens/flashcards/dashboard_view_model.dart';
import 'package:betelsas/presentation/screens/flashcards/study_session.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FlashcardDashboard extends ConsumerWidget {
  const FlashcardDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueCardsState = ref.watch(flashcardDashboardProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: AppTheme.heading1.copyWith(color: AppTheme.textColor),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Vamos praticar?',
                    style: AppTheme.heading2.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  dueCardsState.when(
                    data: (cards) => Text(
                      '${cards.length} cards para revisar',
                      style: AppTheme.heading1.copyWith(color: Colors.white, fontSize: 32),
                    ),
                    loading: () => const CircularProgressIndicator(color: Colors.white),
                    error: (e, s) => const Text('Erro', style: TextStyle(color: Colors.white)),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      dueCardsState.whenData((cards) {
                        if (cards.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StudySession(flashcards: cards),
                            ),
                          ).then((_) {
                              // Refresh on return
                              ref.refresh(flashcardDashboardProvider);
                          });
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppTheme.textColor,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text('Começar Sessão'),
                  ),
                ],
              ),
            ),
             const SizedBox(height: 30),
             Text('Seus Baralhos', style: AppTheme.heading2),
             const SizedBox(height: 10),
             // Mock List of Decks
             Expanded(
               child: ListView(
                 children: [
                   _buildDeckTile('Teologia Sistemática', 10, 2),
                   _buildDeckTile('História da Bíblia', 15, 0),
                   _buildDeckTile('Memorização', 5, 5),
                 ],
               ),
             ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeckTile(String title, int total, int newCards) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
           padding: const EdgeInsets.all(10),
           decoration: BoxDecoration(
             color: AppTheme.scaffoldBackgroundColor,
             borderRadius: BorderRadius.circular(10),
           ),
           child: const Icon(Icons.style_rounded, color: AppTheme.primaryColor),
        ),
        title: Text(title, style: AppTheme.bodyText.copyWith(fontWeight: FontWeight.bold)),
        subtitle: Text('$total cards • $newCards novos'),
        trailing: const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}
