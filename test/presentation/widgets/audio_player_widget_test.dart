import 'package:betelsas/presentation/widgets/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AudioPlayerWidget has a restart button', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AudioPlayerWidget(
            audioUrl: 'https://example.com/audio.mp3',
            title: 'Test Song',
            artist: 'Test Artist',
          ),
        ),
      ),
    );

    // Verify that the title and artist are displayed.
    expect(find.text('Test Song'), findsOneWidget);
    expect(find.text('Test Artist'), findsOneWidget);

    // Verify that the restart button is present.
    // We expect an IconButton with Icons.skip_previous_rounded
    final restartButtonFinder = find.widgetWithIcon(IconButton, Icons.skip_previous_rounded);
    expect(restartButtonFinder, findsOneWidget, reason: 'Restart button (skip_previous_rounded) should be present');

    // Verify that the play/pause button is present.
    // Ideally check for Icons.play_arrow_rounded as implemented
    final playButtonFinder = find.widgetWithIcon(IconButton, Icons.play_arrow_rounded);
    expect(playButtonFinder, findsOneWidget, reason: 'Play button should be present');
  });
}
